import { z } from "zod";

import { config } from "./config";

export const placeSchema = z.object({
  id: z.string().min(1),
  name: z.string().min(1),
  type: z.string().optional(),
  distanceM: z.number().nonnegative().optional(),
  etaMin: z.number().nonnegative().optional(),
});

export const aiSuggestSchema = z.object({
  roomId: z.string().min(1),
  context: z.object({
    format: z.string().optional(),
    places: z.array(placeSchema).min(1).max(50),
  }),
});

export type AiSuggestInput = z.infer<typeof aiSuggestSchema>;

export type AiSuggestion = {
  placeId: string;
  reason: string;
  score: number;
};

export function mockSuggest(input: AiSuggestInput): AiSuggestion[] {
  return input.context.places.slice(0, 3).map((place, index) => ({
    placeId: place.id,
    reason: `Подходит по формату и расстоянию (${place.distanceM ?? "?"} м).`,
    score: Number((1 - index * 0.1).toFixed(2)),
  }));
}

function isSuggestion(value: unknown): value is AiSuggestion {
  if (typeof value !== "object" || value === null) return false;
  const candidate = value as Record<string, unknown>;
  return (
    typeof candidate.placeId === "string" &&
    typeof candidate.reason === "string" &&
    typeof candidate.score === "number"
  );
}

function buildPrompt(input: AiSuggestInput): string {
  const places = input.context.places
    .map((place) => {
      const parts = [`id=${place.id}`, `name=${place.name}`];
      if (place.type) parts.push(`type=${place.type}`);
      if (place.distanceM != null) parts.push(`distanceM=${place.distanceM}`);
      if (place.etaMin != null) parts.push(`etaMin=${place.etaMin}`);
      return `- ${parts.join("; ")}`;
    })
    .join("\n");

  return [
    "Ты консьерж для выбора места встречи.",
    "Верни строго JSON вида:",
    '{"suggestions":[{"placeId":"<id из списка>","reason":"<1-2 предложения>","score":0.0}]}',
    "Выбери 3 места из списка и объясни выбор.",
    "Не придумывай новые placeId, используй только переданные.",
    `Формат встречи: ${input.context.format ?? "любой"}`,
    "Места:",
    places,
  ].join("\n");
}

function parseSuggestions(content: string, input: AiSuggestInput): AiSuggestion[] {
  const allowed = new Set(input.context.places.map((place) => place.id));
  let parsed: unknown;
  try {
    parsed = JSON.parse(content);
  } catch {
    return [];
  }

  if (typeof parsed !== "object" || parsed === null) return [];
  const suggestions = (parsed as { suggestions?: unknown }).suggestions;
  if (!Array.isArray(suggestions)) return [];

  return suggestions
    .filter(isSuggestion)
    .filter((suggestion) => allowed.has(suggestion.placeId))
    .slice(0, 3);
}

export async function ollamaSuggest(input: AiSuggestInput): Promise<AiSuggestion[]> {
  const baseUrl = config.ollamaBaseUrl.replace(/\/$/, "");
  const response = await fetch(`${baseUrl}/api/chat`, {
    method: "POST",
    headers: { "content-type": "application/json" },
    body: JSON.stringify({
      model: config.ollamaModel,
      stream: false,
      format: "json",
      messages: [
        {
          role: "system",
          content:
            "Ты помощник для выбора места встречи. Отвечай только JSON без пояснений.",
        },
        { role: "user", content: buildPrompt(input) },
      ],
    }),
  });

  if (!response.ok) {
    throw new Error(`ollama_http_${response.status}`);
  }

  const data = (await response.json()) as {
    message?: { content?: string };
  };
  return parseSuggestions(data.message?.content ?? "", input);
}
