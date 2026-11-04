# Store-ready baseline checklist

Not a full store submission — minimum readiness items implemented in-app.

## Implemented
- Privacy copy in Profile → Privacy
- Account deletion (Firebase Auth user + favorites / history / address_memory)
- Crashlytics breadcrumbs for geocode / room stream retry / account delete
- Analytics funnel including `meeting_completed`
- No continuous GPS permission required (address geocoding only)

## Before App Store / Play submission
- [ ] Host `https://datenavigation.app/join/{code}` landing or Universal Links association
- [ ] Privacy policy URL for store listings
- [ ] Data safety / App Privacy questionnaire filled from [privacyBody]
- [ ] Screenshots for phone + tablet
- [ ] Confirm Google Sign-In OAuth consent / SHA keys for release
- [ ] Manual smoke: [core_loop_smoke_checklist.md](core_loop_smoke_checklist.md)
