# Core loop smoke checklist

Run on two simulators / devices before each release candidate.

## Happy path
- [ ] Sign in (Google)
- [ ] Create room, note invite code
- [ ] Second user joins with code
- [ ] Both submit addresses
- [ ] Agree on meeting format
- [ ] Places appear near midpoint
- [ ] Vote / propose / accept
- [ ] Complete session; history/favorites updated

## Lifecycle regressions
- [ ] Logout while in room: next user does not see prior addresses/room
- [ ] Change language while in room: session stays, sync continues
- [ ] Partner leaves: UI shows clear status; creator can continue or leave
- [ ] Airplane mode mid-sync: failure banner with Retry; no silent hang
- [ ] Invalid / expired invite code: clear error, can retry join

## Failure UX
- [ ] Bad address → geocode failure + Retry / dismiss
- [ ] Routing outage → routing failure or degraded midpoint warning + Retry
- [ ] Room stream drop → `room_stream` banner + Retry resubscribe
