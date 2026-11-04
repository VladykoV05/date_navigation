export type JsonLdNode = Record<string, unknown>;

export function extractJsonLd(html: string): JsonLdNode[] {
  const nodes: JsonLdNode[] = [];
  const regex =
    /<script[^>]*type="application\/ld\+json"[^>]*>([\s\S]*?)<\/script>/gi;
  let match: RegExpExecArray | null;

  while ((match = regex.exec(html)) !== null) {
    try {
      const parsed: unknown = JSON.parse(match[1].trim());
      if (Array.isArray(parsed)) {
        nodes.push(...parsed.filter(isNode));
      } else if (isNode(parsed)) {
        nodes.push(parsed);
      }
    } catch {
      continue;
    }
  }

  return nodes;
}

export function flattenGraph(nodes: JsonLdNode[]): JsonLdNode[] {
  const result: JsonLdNode[] = [];
  for (const node of nodes) {
    const graph = node["@graph"];
    if (Array.isArray(graph)) {
      result.push(...graph.filter(isNode));
    } else {
      result.push(node);
    }
  }
  return result;
}

export function findByType(
  nodes: JsonLdNode[],
  type: string,
): JsonLdNode | undefined {
  return nodes.find((node) => {
    const nodeType = node["@type"];
    return (
      nodeType === type ||
      (Array.isArray(nodeType) && nodeType.includes(type))
    );
  });
}

function isNode(value: unknown): value is JsonLdNode {
  return typeof value === "object" && value !== null && !Array.isArray(value);
}
