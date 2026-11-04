import { config } from "../config";
import { extractJsonLd, findByType, flattenGraph, JsonLdNode } from "./jsonld";
import { EventItem } from "./types";

type CacheEntry<T> = {
  expiresAt: number;
  value: T;
};

export type ParsedEvent = {
  item: EventItem;
  venueUrl?: string;
};

const eventCache = new Map<string, CacheEntry<EventItem>>();
const listCache = new Map<string, CacheEntry<EventItem[]>>();

function cacheGet<T>(
  cache: Map<string, CacheEntry<T>>,
  key: string,
): T | undefined {
  const entry = cache.get(key);
  if (!entry) return undefined;
  if (entry.expiresAt <= Date.now()) {
    cache.delete(key);
    return undefined;
  }
  return entry.value;
}

function cacheSet<T>(
  cache: Map<string, CacheEntry<T>>,
  key: string,
  value: T,
): void {
  cache.set(key, {
    expiresAt: Date.now() + config.eventCacheTtlMs,
    value,
  });
}

function delay(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function text(value: unknown): string | undefined {
  return typeof value === "string" && value.trim().length > 0
    ? value.trim()
    : undefined;
}

function number(value: unknown): number | undefined {
  return typeof value === "number" && Number.isFinite(value) ? value : undefined;
}

function imageUrl(value: unknown): string | undefined {
  if (typeof value === "string") return value;
  if (Array.isArray(value)) {
    return value.find((entry): entry is string => typeof entry === "string");
  }
  return undefined;
}

function performerName(value: unknown): string | undefined {
  if (typeof value === "string") return value;
  if (Array.isArray(value)) {
    for (const entry of value) {
      const name = performerName(entry);
      if (name) return name;
    }
    return undefined;
  }
  if (typeof value === "object" && value !== null) {
    return text((value as JsonLdNode)["name"]);
  }
  return undefined;
}

function inferCategory(item: EventItem): string | undefined {
  const haystack = `${item.title} ${item.description ?? ""}`.toLowerCase();
  if (haystack.includes("концерт")) return "Концерты";
  if (haystack.includes("спектакл") || haystack.includes("театр")) return "Театр";
  if (haystack.includes("спорт") || haystack.includes("матч") || haystack.includes("кубок")) {
    return "Спорт";
  }
  if (haystack.includes("выставк")) return "Выставки";
  if (haystack.includes("фестивал")) return "Фестивали";
  if (haystack.includes("шоу")) return "Шоу";
  return undefined;
}

const CATEGORY_SLUGS: Record<string, string> = {
  concerts: "bilety-na-koncert",
  theatre: "bilety-v-teatr",
  sport: "bilety-na-sportivnye-meropriyatiya",
};

const CATEGORY_LABELS: Record<string, string> = {
  concerts: "Концерты",
  theatre: "Театр",
  sport: "Спорт",
};

function resolveCategory(category?: string): {
  slug?: string;
  label?: string;
} {
  if (!category) return {};
  const normalized = category.trim().toLowerCase();
  return {
    slug:
      CATEGORY_SLUGS[normalized] ??
      (normalized.startsWith("bilety-") ? normalized : undefined),
    label: CATEGORY_LABELS[normalized],
  };
}

function toAbsoluteUrl(value: string, baseUrl: string): string {
  try {
    return new URL(value, baseUrl).toString();
  } catch {
    return value;
  }
}

function parseAddress(location: JsonLdNode): {
  address?: string;
  city?: string;
  country?: string;
} {
  const address = location["address"];
  if (typeof address !== "object" || address === null) return {};
  const data = address as JsonLdNode;
  return {
    address: text(data["streetAddress"]),
    city: text(data["addressLocality"]),
    country: text(data["addressCountry"]),
  };
}

async function fetchHtml(url: string): Promise<string> {
  const response = await fetch(url, {
    headers: {
      "user-agent": config.eventUserAgent,
      "accept-language": "ru,en;q=0.8",
      accept: "text/html,application/xhtml+xml",
    },
    signal: AbortSignal.timeout(config.eventFetchTimeoutMs),
  });

  if (!response.ok) {
    throw new Error(`ticketpro_http_${response.status}`);
  }

  return response.text();
}

export function extractEventLinks(html: string, baseUrl: string): string[] {
  const links = new Set<string>();
  const regex = /href="(\/ru\/event\/[^"#?]+)"/g;
  let match: RegExpExecArray | null;

  while ((match = regex.exec(html)) !== null) {
    links.add(new URL(match[1], baseUrl).toString());
  }

  return [...links];
}

export function parseEventPage(html: string, url: string): ParsedEvent | undefined {
  const nodes = flattenGraph(extractJsonLd(html));
  const event = findByType(nodes, "Event");
  if (!event) return undefined;

  const location =
    typeof event["location"] === "object" && event["location"] !== null
      ? (event["location"] as JsonLdNode)
      : {};
  const address = parseAddress(location);
  const offers =
    typeof event["offers"] === "object" && event["offers"] !== null
      ? (event["offers"] as JsonLdNode)
      : {};
  const price = text(offers["price"]);
  const currency = text(offers["priceCurrency"]);
  const venueUrlRaw = text(location["url"]);

  return {
    item: {
      id: url,
      source: "ticketpro",
      title: text(event["name"]) ?? "Событие",
      description: text(event["description"]),
      performer: performerName(event["performer"]),
      startsAt: text(event["startDate"]),
      endsAt: text(event["endDate"]),
      venueName: text(location["name"]),
      address: address.address,
      city: address.city,
      country: address.country,
      imageUrl: imageUrl(event["image"]),
      url,
      price: price && currency ? `${price} ${currency}` : price,
    },
    venueUrl: venueUrlRaw ? toAbsoluteUrl(venueUrlRaw, url) : undefined,
  };
}

export function parseVenuePage(html: string): {
  lat?: number;
  lon?: number;
} {
  const nodes = flattenGraph(extractJsonLd(html));
  const place = findByType(nodes, "Place");
  if (!place) return {};
  const geo =
    typeof place["geo"] === "object" && place["geo"] !== null
      ? (place["geo"] as JsonLdNode)
      : {};
  return {
    lat: number(geo["latitude"]),
    lon: number(geo["longitude"]),
  };
}

export function isTicketProUrl(value: string): boolean {
  try {
    const url = new URL(value);
    return (
      url.protocol === "https:" &&
      (url.hostname === "ticketpro.by" || url.hostname === "www.ticketpro.by")
    );
  } catch {
    return false;
  }
}

async function loadEvent(url: string): Promise<EventItem | undefined> {
  const cached = cacheGet(eventCache, url);
  if (cached) return cached;

  const html = await fetchHtml(url);
  const parsed = parseEventPage(html, url);
  if (!parsed) return undefined;

  if (!parsed.item.category) {
    parsed.item.category = inferCategory(parsed.item);
  }

  if (parsed.venueUrl && isTicketProUrl(parsed.venueUrl)) {
    try {
      const venueHtml = await fetchHtml(parsed.venueUrl);
      const geo = parseVenuePage(venueHtml);
      parsed.item.lat = geo.lat;
      parsed.item.lon = geo.lon;
    } catch {
      parsed.item.lat = undefined;
      parsed.item.lon = undefined;
    }
  }

  cacheSet(eventCache, url, parsed.item);
  return parsed.item;
}

export async function importTicketProEvent(
  url: string,
): Promise<EventItem | undefined> {
  return loadEvent(url);
}

export async function searchTicketPro(options: {
  limit: number;
  category?: string;
}): Promise<EventItem[]> {
  const cacheKey = `list:${options.category ?? "home"}:${options.limit}`;
  const cached = cacheGet(listCache, cacheKey);
  if (cached) return cached;

  const baseUrl = config.ticketproBaseUrl.replace(/\/$/, "");
  const resolved = resolveCategory(options.category);
  const listingUrl = resolved.slug
    ? `${baseUrl}/ru/${encodeURIComponent(resolved.slug)}`
    : `${baseUrl}/ru`;

  let html: string;
  try {
    html = await fetchHtml(listingUrl);
  } catch {
    html = await fetchHtml(`${baseUrl}/ru`);
  }

  const links = extractEventLinks(html, baseUrl).slice(0, options.limit);
  const events: EventItem[] = [];

  for (const link of links) {
    try {
      const event = await loadEvent(link);
      if (event) {
        events.push({
          ...event,
          category: event.category ?? resolved.label,
        });
      }
    } catch {
      continue;
    }
    await delay(config.eventFetchDelayMs);
  }

  cacheSet(listCache, cacheKey, events);
  return events;
}
