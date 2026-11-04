#!/usr/bin/env bash
set -u
cd "$(dirname "$0")/.."
firebase emulators:start --only firestore --project date-navigation-test >/tmp/rules-emulator.log 2>&1 &
EMU=$!
for _ in $(seq 1 60); do
  curl -s http://127.0.0.1:8080 >/dev/null 2>&1 && break
  sleep 1
done
node --test rules-tests/test/open_room.test.mjs
STATUS=$?
kill $EMU 2>/dev/null
wait $EMU 2>/dev/null
exit $STATUS
