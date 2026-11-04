export type EventSourceId = "ticketpro" | "manual";

export type EventItem = {
  id: string;
  source: EventSourceId;
  title: string;
  description?: string;
  category?: string;
  performer?: string;
  startsAt?: string;
  endsAt?: string;
  venueName?: string;
  address?: string;
  city?: string;
  country?: string;
  lat?: number;
  lon?: number;
  imageUrl?: string;
  url: string;
  price?: string;
};
