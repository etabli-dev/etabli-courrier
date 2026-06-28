# Profile-mode jank checklist (M15 release-gate)

`flutter run --profile` only runs on a physical device — the unit + widget
test path can't catch dropped frames the way the audit dim 3 invariant
requires. M12 stability pass documents the flows that must be exercised in
profile mode before M15 cuts the release.

Run each flow against the M14 bundled sample content (no live network
required), watch the DevTools Performance pane for the 16ms budget on every
frame, and check off the row.

| flow                                                                        | how to drive                                                                                 | done? |
|-----------------------------------------------------------------------------|----------------------------------------------------------------------------------------------|-------|
| Mail thread list scroll (1k+ rows from DemoMailBackend)                      | Open the Mail tab → scroll the inbox top to bottom 3× without lifting finger                  | [ ]   |
| Mail message render (HTML newsletter with remote tracker)                    | Tap the bundled "Q3 newsletter" thread → confirm `[image blocked]` placeholder, no fetch     | [ ]   |
| Calendar month-view swipe across 6 months                                    | Open Calendar → tap Month → swipe forward 6 times, back 6 times                              | [ ]   |
| Calendar agenda scroll (12 months of demo events)                            | Open Calendar → tap Agenda → scroll the agenda full range                                    | [ ]   |
| Contacts list scroll (200+ from sample VCFs)                                 | Open Contacts → scroll the alphabetical list                                                 | [ ]   |
| Contacts detail open + close × 10                                            | Open Contacts → tap a card, back, tap next, back, repeat 10×                                 | [ ]   |
| Tasks list with deep subtask tree                                            | Open Tasks → toggle a parent's completion → confirm subtask rows update                      | [ ]   |
| Notes editor undo/redo 20× on a 5KB note                                     | Open Notes → edit a long note → undo 10× + redo 10×                                          | [ ]   |
| Feeds item list scroll on a high-volume feed                                  | Open Feeds → select a feed with 100+ items → scroll                                          | [ ]   |
| Global search across all modules                                              | Open the search field → type 'release' → confirm results appear without sustained jank      | [ ]   |
| Onboarding flow cold-start                                                    | Wipe app data → run onboarding from one entry through Nextcloud + IMAP + M365 sign-in        | [ ]   |
| App lock unlock                                                               | Lock → resume → enter PIN / biometric → confirm sub-second resume                            | [ ]   |
| Reminder fire + tap                                                           | Schedule a 1-min reminder → fire → tap notification → confirm app opens to the right module  | [ ]   |
| Reboot + re-arm (Android)                                                     | Schedule 5 reminders → reboot device → confirm all fire at the right times                   | [ ]   |

## How to run

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

M15 cuts the release only after this checklist is fully ticked.
