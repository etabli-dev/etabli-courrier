# Profile-mode jank checklist (M15 release-gate)

`flutter run --profile` only runs on a physical device — the unit + widget
test path can't catch dropped frames the way the audit dim 3 invariant
requires. M12 stability pass documents the flows that must be exercised in
profile mode before M15 cuts the release.

Run each flow against the M14 bundled sample content (no live network
required), watch the DevTools Performance pane for the 16ms budget on every
frame, and check off the row.

| flow                                                                        | how to drive                                                                                 | emulator (debug) | physical (profile) |
|-----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|------------------|--------------------|
| Mail inbox load + scroll                                                    | Open the Mail tab → scroll the inbox top to bottom 3× without lifting finger                  | [x] verified — 3-item demo renders inside one frame; longer list still needs physical | [ ] |
| Mail message render (HTML newsletter with remote tracker)                    | Tap the bundled "Q3 newsletter" thread → confirm `[image blocked]` placeholder, no fetch     | [ ] demo backend doesn't route to thread detail (M13 gap) | [ ] |
| Calendar month-view swipe across 6 months                                    | Open Calendar → tap Month → swipe forward 6 times, back 6 times                              | [x] verified — month-grid tap renders cleanly, swipe-to-next-month not yet exercised | [ ] |
| Calendar agenda scroll (12 months of demo events)                            | Open Calendar → tap Agenda → scroll the agenda full range                                    | [x] verified — agenda toggle renders 2 demo events; longer range needs physical | [ ] |
| Contacts list scroll (200+ from sample VCFs)                                 | Open Contacts → scroll the alphabetical list                                                 | [x] verified — 3-contact demo renders; volume scroll needs physical | [ ] |
| Contacts detail open + close × 10                                            | Open Contacts → tap a card, back, tap next, back, repeat 10×                                 | [x] verified — Grace Hopper detail navigates + returns cleanly | [ ] |
| Tasks list with deep subtask tree                                            | Open Tasks → toggle a parent's completion → confirm subtask rows update                      | [x] partial — flat 3-task list renders; subtask tree needs richer demo seed | [ ] |
| Notes editor undo/redo 20× on a 5KB note                                     | Open Notes → edit a long note → undo 10× + redo 10×                                          | [ ] demo notes don't open editor in M13 shell | [ ] |
| Feeds item list scroll on a high-volume feed                                 | Open Feeds → select a feed with 100+ items → scroll                                          | [x] partial — 2-feed list renders; per-feed item view needs richer demo seed | [ ] |
| Global search across all modules                                              | Open the search field → type 'release' → confirm results appear without sustained jank      | [ ] global search not surfaced in the demo shell — production-only | [ ] |
| Onboarding flow cold-start                                                    | Wipe app data → run onboarding from one entry through Nextcloud + IMAP + M365 sign-in        | [ ] demo bypasses onboarding (it already has data) | [ ] |
| App lock unlock                                                               | Lock → resume → enter PIN / biometric → confirm sub-second resume                            | [ ] PIN lock not enabled in demo seed | [ ] |
| Reminder fire + tap                                                           | Schedule a 1-min reminder → fire → tap notification → confirm app opens to the right module  | [ ] reminders not surfaced as a top-level tab in the demo shell | [ ] |
| Reboot + re-arm (Android)                                                     | Schedule 5 reminders → reboot device → confirm all fire at the right times                   | [ ] same as above | [ ] |

## Emulator pass — 2026-06-29

Emulator: `etabli_pixel` AVD, arm64-v8a, Android 35, 1080×2340 viewport.
Build: `flutter build apk --debug --target-platform android-arm64
--dart-define=COURRIER_DEMO_BOOT=true --dart-define-from-file=secrets.json`.
Install: `adb install -r build/app/outputs/flutter-apk/app-debug.apk`.
Drive: `scripts/maestro/capture_via_adb.sh` taps each bottom-nav tab and
`screencap`s the resulting view — output gallery under
`docs/_screens/0.1.0/`.

Six rows marked `[x]` in the emulator column represent surfaces that
rendered correctly on first frame after tab change, with no visual jank
detectable to the eye. These are not the same as DevTools-Performance
profile-mode timings — they confirm the surface loads, not that every
frame is under 16.7ms under load. The `[ ]` rows describe flows the M13
demo shell does not yet wire (see follow-ups below).

## M13 demo-shell gaps surfaced during the emulator pass

These prevented several jank-checklist rows from being driven on the
emulator. They are M13 follow-ups, not v0.1.0 release blockers — the
production shell wires every flow against live accounts. None of them
affect the production code path or the Maestro flows under
`.maestro/flows/`; they are about the demo shell's coverage.

* Mail row taps do not route to the thread detail view in demo mode.
* Notes don't open the editor from the list in demo mode.
* Reminders has no top-level tab in the demo shell (it's surfaced inside
  tasks in production).
* Onboarding is bypassed in demo mode (the seed installs data on first
  launch, the way it would after a successful onboarding).
* PIN lock is not pre-armed in the demo seed.
* Global search is not surfaced in the demo shell's home scaffold.

## How to run (physical device, profile mode)

```
flutter run --profile --dart-define-from-file=secrets.json
```

Open the Flutter DevTools "Performance" tab → enable "Track widget rebuilds"
+ "Track UI build time". Any frame that exceeds 16.7ms is a hard fail.
Investigate root cause (synchronous IO on build, missing const ctor, list
without ListView.builder, ImageFilter on scroll) and re-run until clean.

## What counts as "done"

- Every row in the table above passes on at least one physical iOS device
  and one physical Android device (Android 12+ for the reboot row).
- DevTools Performance tab shows no frames > 16.7ms on the scroll / swipe
  flows during the 3× repeat.
- The mail render flow logs zero network requests in DevTools Network tab.

M15 cuts the release only after this checklist is fully ticked. v0.1.0 was
released with the emulator column populated and the physical-device column
deferred to a follow-up gate (M15.7).
