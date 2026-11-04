import "dotenv/config";

export const config = {
  port: Number(process.env.PORT ?? 8080),
  projectId: process.env.FIREBASE_PROJECT_ID ?? "date-navigation",
  devSkipAuth: process.env.DEV_SKIP_AUTH === "true",
  devSkipRoomCheck: process.env.DEV_SKIP_ROOM_CHECK === "true",
  llmMock: process.env.LLM_MOCK !== "false",
  llmProvider: process.env.LLM_PROVIDER ?? "ollama",
  llmApiKey: process.env.LLM_API_KEY ?? "",
  ollamaBaseUrl: process.env.OLLAMA_BASE_URL ?? "http://127.0.0.1:11434",
  ollamaModel: process.env.OLLAMA_MODEL ?? "llama3.1:8b",
  ticketproBaseUrl: process.env.TICKETPRO_BASE_URL ?? "https://ticketpro.by",
  eventCacheTtlMs: Number(process.env.EVENT_CACHE_TTL_MS ?? 900000),
  eventFetchTimeoutMs: Number(process.env.EVENT_FETCH_TIMEOUT_MS ?? 10000),
  eventFetchDelayMs: Number(process.env.EVENT_FETCH_DELAY_MS ?? 300),
  eventUserAgent: process.env.EVENT_USER_AGENT ?? "SborDiploma/1.0",
  allowedOrigins: (process.env.ALLOWED_ORIGINS ?? "")
    .split(",")
    .map((origin) => origin.trim())
    .filter((origin) => origin.length > 0),
};
