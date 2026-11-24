# Changelog

## Unreleased

### Added

- Settings → Appearance: the app language (System / Deutsch / English), the mode (System / Light / Dark)
  and an accent colour (Coder blue, Green, Yellow, Orange, Red, Purple, Graphite), the same keys, values and
  order as the other Établi apps. All three apply at once and are stored under `app.language`,
  `appearance.mode` and `appearance.accent`; unknown stored values fall back to System and Coder blue.
- German translation of every screen, menu, dialog, error, sync report, notification and accessibility
  label (`lib/l10n/app_de.arb`), including recurrence descriptions, dates and numbers in the chosen language
  and the Face ID prompt reason. English stays the fallback for other device languages.
- `integration_test/tour_test.dart`: a screenshot tour of every module, the drawer, accounts, settings and
  the main dialogs in English and German.

### Changed

- Colours follow the Hugo Coder palette (background #FAFAFA / #212121, text #212121 / #DADADA, surface
  #E0E0E0 / #424242) with Coder blue as the default accent instead of the fixed green. Selection fills of
  the yellow and orange accents are neutral grey, so no background is tinted yellow.
- Labels never wrap or truncate on a 375-pt iPhone; where German needs a shorter label, the full wording
  stays as its tooltip or accessibility label.
- Sync reports use proper plurals ("1 folder", not "1 folders").
