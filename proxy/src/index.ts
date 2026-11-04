import cors from "@fastify/cors";
import Fastify from "fastify";

import { aiSuggestSchema, mockSuggest, ollamaSuggest } from "./ai";
import { config } from "./config";
import {
  importTicketProEvent,
  isTicketProUrl,
  searchTicketPro,
} from "./events/ticketpro";
import { auth, db } from "./firebase";

const app = Fastify({ logger: true });

app.register(cors, {
  origin: config.allowedOrigins.length > 0 ? config.allowedOrigins : true,
});

app.get("/health", async () => ({
  ok: true,
  service: "date-navigation-proxy",
  timestamp: new Date().toISOString(),
}));

app.post("/aiSuggest", async (request, reply) => {
  const parsed = aiSuggestSchema.safeParse(request.body);
  if (!parsed.success) {
    return reply.code(400).send({
      error: "invalid_request",
      details: parsed.error.flatten(),
    });
  }

  let uid = "dev";
  if (!config.devSkipAuth) {
    const header = request.headers.authorization ?? "";
    const token = header.startsWith("Bearer ") ? header.slice(7) : "";
    if (!token) {
      return reply.code(401).send({ error: "missing_token" });
    }
    try {
      uid = (await auth().verifyIdToken(token)).uid;
    } catch {
      return reply.code(401).send({ error: "invalid_token" });
    }
  }

  const skipRoomCheck = config.devSkipAuth && config.devSkipRoomCheck;
  if (!skipRoomCheck) {
    const room = await db().doc(`rooms/${parsed.data.roomId}`).get();
    if (!room.exists) {
      return reply.code(404).send({ error: "room_not_found" });
    }

    const participants = (room.get("participants") ?? []) as string[];
    if (!participants.includes(uid)) {
      return reply.code(403).send({ error: "not_participant" });
    }
  }

  if (config.llmMock) {
    return { suggestions: mockSuggest(parsed.data), fallback: false };
  }

  if (config.llmProvider === "ollama") {
    try {
      const suggestions = await ollamaSuggest(parsed.data);
      if (suggestions.length > 0) {
        return { suggestions, fallback: false };
      }
      request.log.warn("ollama returned no valid suggestions");
      return { suggestions: mockSuggest(parsed.data), fallback: true };
    } catch (error) {
      request.log.error({ error }, "ollama request failed");
      return { suggestions: mockSuggest(parsed.data), fallback: true };
    }
  }

  if (!config.llmApiKey) {
    return reply.code(503).send({ error: "llm_not_configured" });
  }
  return reply.code(501).send({ error: "llm_provider_not_implemented" });
});

app.get("/events/search", async (request, reply) => {
  const query = request.query as { limit?: string; category?: string };
  const limit = Math.min(Math.max(Number(query.limit ?? 5), 1), 10);

  try {
    const events = await searchTicketPro({
      limit,
      category: query.category,
    });
    return { source: "ticketpro", events };
  } catch (error) {
    request.log.error({ error }, "ticketpro search failed");
    return reply.code(502).send({
      error: "event_source_unavailable",
      source: "ticketpro",
      events: [],
    });
  }
});

app.post("/events/import", async (request, reply) => {
  const body = request.body as { url?: string };
  if (!body?.url || !isTicketProUrl(body.url)) {
    return reply.code(400).send({ error: "invalid_url" });
  }

  try {
    const event = await importTicketProEvent(body.url);
    if (!event) {
      return reply.code(404).send({ error: "event_not_found" });
    }
    return { source: "ticketpro", event };
  } catch (error) {
    request.log.error({ error }, "ticketpro import failed");
    return reply.code(502).send({ error: "event_source_unavailable" });
  }
});

app.listen({ port: config.port, host: "0.0.0.0" }).catch((error) => {
  app.log.error(error);
  process.exit(1);
});
