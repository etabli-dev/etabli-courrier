import '../../l10n/l10n.dart';

extension IntlDateLocale on AppLocalizations {
  /// The locale for intl date formats and weekday/month names. Plain English
  /// maps to en_US, whose date symbols intl always has: widget tests install no
  /// localizations, so no date symbols are loaded there. The formats are equal.
  String get dateLocale => localeName == 'en' ? 'en_US' : localeName;
}
