#!/usr/bin/env bash
set -u
pkill -f "cloud-firestore-emulator" 2>/dev/null || true
sleep 1
cd "$(dirname "$0")/.."
firebase emulators:start --only firestore --project date-navigation-test >/tmp/rules-emulator.log 2>&1 &
EMU=$!
UP=0
for _ in $(seq 1 240); do
  if grep -q "All emulators ready" /tmp/rules-emulator.log 2>/dev/null; then UP=1; break; fi
  if ! kill -0 "$EMU" 2>/dev/null; then break; fi
  sleep 1
done
if [ "$UP" -ne 1 ]; then
  echo "Firestore emulator did not start"; cat /tmp/rules-emulator.log; kill "$EMU" 2>/dev/null; exit 1
fi
node --test rules-tests/test/open_room.test.mjs
STATUS=$?
kill "$EMU" 2>/dev/null
pkill -f "cloud-firestore-emulator" 2>/dev/null || true
wait "$EMU" 2>/dev/null
exit "$STATUS"
