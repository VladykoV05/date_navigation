import { setGlobalOptions } from "firebase-functions/v2";
import { onRequest } from "firebase-functions/v2/https";

setGlobalOptions({ region: "europe-west1", maxInstances: 10 });

export const healthCheck = onRequest({ cors: true }, (_req, res) => {
  res.status(200).json({
    ok: true,
    service: "date-navigation-functions",
    region: "europe-west1",
    timestamp: new Date().toISOString(),
  });
});
