import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @navMail.
  ///
  /// In en, this message translates to:
  /// **'mail'**
  String get navMail;

  /// No description provided for @navCalendar.
  ///
  /// In en, this message translates to:
  /// **'calendar'**
  String get navCalendar;

  /// No description provided for @navContacts.
  ///
  /// In en, this message translates to:
  /// **'contacts'**
  String get navContacts;

  /// No description provided for @navTasks.
  ///
  /// In en, this message translates to:
  /// **'tasks'**
  String get navTasks;

  /// No description provided for @navReminders.
  ///
  /// In en, this message translates to:
  /// **'reminders'**
  String get navReminders;

  /// No description provided for @navNotes.
  ///
  /// In en, this message translates to:
  /// **'notes'**
  String get navNotes;

  /// No description provided for @navFeeds.
  ///
  /// In en, this message translates to:
  /// **'feeds'**
  String get navFeeds;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get navMore;

  /// No description provided for @navMoreTooltip.
  ///
  /// In en, this message translates to:
  /// **'More modules'**
  String get navMoreTooltip;

  /// No description provided for @shellTitle.
  ///
  /// In en, this message translates to:
  /// **'courrier · {module}'**
  String shellTitle(String module);

  /// No description provided for @shellModules.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get shellModules;

  /// No description provided for @shellShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get shellShortcuts;

  /// No description provided for @shellShortcutsBody.
  ///
  /// In en, this message translates to:
  /// **'Ctrl / Cmd + 1–7: switch module\nCtrl / Cmd + comma: settings\nCtrl / Cmd + Shift + A: accounts\nCtrl / Cmd + N: new note (in Notes)\nF1: show this help'**
  String get shellShortcutsBody;

  /// No description provided for @shellSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get shellSettings;

  /// No description provided for @shellAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get shellAccounts;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @bootDatabaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the local database. Free storage if necessary, then retry. Existing files have been retained.'**
  String get bootDatabaseFailed;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsLockToggle.
  ///
  /// In en, this message translates to:
  /// **'Toggle app lock'**
  String get settingsLockToggle;

  /// No description provided for @settingsLockTitle.
  ///
  /// In en, this message translates to:
  /// **'App lock (device authentication)'**
  String get settingsLockTitle;

  /// No description provided for @settingsLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require unlocking when courrier resumes from background.'**
  String get settingsLockSubtitle;

  /// No description provided for @settingsLockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Not available {inBuild}: it has no device-authentication service.'**
  String settingsLockUnavailable(String inBuild);

  /// No description provided for @settingsExportImport.
  ///
  /// In en, this message translates to:
  /// **'Settings export / import'**
  String get settingsExportImport;

  /// No description provided for @settingsExportLabel.
  ///
  /// In en, this message translates to:
  /// **'Export settings as JSON'**
  String get settingsExportLabel;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get settingsExport;

  /// No description provided for @settingsImportLabel.
  ///
  /// In en, this message translates to:
  /// **'Import settings from JSON'**
  String get settingsImportLabel;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get settingsImport;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsSupport.
  ///
  /// In en, this message translates to:
  /// **'Support development'**
  String get settingsSupport;

  /// No description provided for @settingsDocs.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get settingsDocs;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'courrier is part of the Établi Suite. AGPL-3.0-only.'**
  String get settingsFooter;

  /// No description provided for @settingsLockAuthRequired.
  ///
  /// In en, this message translates to:
  /// **'Device authentication is required to change app lock.'**
  String get settingsLockAuthRequired;

  /// No description provided for @settingsLockSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save app-lock settings.'**
  String get settingsLockSaveFailed;

  /// No description provided for @settingsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Non-sensitive settings'**
  String get settingsExportTitle;

  /// No description provided for @settingsCopyJson.
  ///
  /// In en, this message translates to:
  /// **'Copy JSON'**
  String get settingsCopyJson;

  /// No description provided for @settingsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export settings.'**
  String get settingsExportFailed;

  /// No description provided for @settingsImported.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Imported 1 preference.} other{Imported {count} preferences.}}'**
  String settingsImported(int count);

  /// No description provided for @settingsImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed. Use a supported settings export with valid preference values.'**
  String get settingsImportFailed;

  /// No description provided for @settingsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load settings. Reopen this screen to retry.'**
  String get settingsLoadFailed;

  /// No description provided for @settingsImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Import settings JSON'**
  String get settingsImportTitle;

  /// No description provided for @settingsImportHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a settings export. App lock and credentials are excluded.'**
  String get settingsImportHint;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get settingsLanguage;

  /// No description provided for @settingsMode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get settingsMode;

  /// No description provided for @modeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get modeSystem;

  /// No description provided for @modeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get modeLight;

  /// No description provided for @modeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get modeDark;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @settingsAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent colour'**
  String get settingsAccent;

  /// No description provided for @accentCoderBlue.
  ///
  /// In en, this message translates to:
  /// **'Coder blue'**
  String get accentCoderBlue;

  /// No description provided for @accentGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get accentGreen;

  /// No description provided for @accentYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get accentYellow;

  /// No description provided for @accentOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get accentOrange;

  /// No description provided for @accentRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get accentRed;

  /// No description provided for @accentPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get accentPurple;

  /// No description provided for @accentGraphite.
  ///
  /// In en, this message translates to:
  /// **'Graphite'**
  String get accentGraphite;

  /// No description provided for @settingsAppearanceNote.
  ///
  /// In en, this message translates to:
  /// **'Language, mode and accent colour apply at once. Default: Hugo Coder palette.'**
  String get settingsAppearanceNote;

  /// No description provided for @platformBuildLinux.
  ///
  /// In en, this message translates to:
  /// **'the Linux build'**
  String get platformBuildLinux;

  /// No description provided for @platformBuildWindows.
  ///
  /// In en, this message translates to:
  /// **'the Windows build'**
  String get platformBuildWindows;

  /// No description provided for @platformBuildMacos.
  ///
  /// In en, this message translates to:
  /// **'the macOS build'**
  String get platformBuildMacos;

  /// No description provided for @platformBuildThis.
  ///
  /// In en, this message translates to:
  /// **'this build'**
  String get platformBuildThis;

  /// No description provided for @platformInLinux.
  ///
  /// In en, this message translates to:
  /// **'in the Linux build'**
  String get platformInLinux;

  /// No description provided for @platformInWindows.
  ///
  /// In en, this message translates to:
  /// **'in the Windows build'**
  String get platformInWindows;

  /// No description provided for @platformInMacos.
  ///
  /// In en, this message translates to:
  /// **'in the macOS build'**
  String get platformInMacos;

  /// No description provided for @platformInThis.
  ///
  /// In en, this message translates to:
  /// **'in this build'**
  String get platformInThis;

  /// No description provided for @shellRemindersUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Reminder notifications are not delivered {inBuild} yet. The list below shows what is due; check it while courrier is open.'**
  String shellRemindersUnavailable(String inBuild);

  /// No description provided for @mailBodyNotDownloaded.
  ///
  /// In en, this message translates to:
  /// **'This message body has not been downloaded. Connect the account and sync this folder to read it offline.'**
  String get mailBodyNotDownloaded;

  /// No description provided for @mailMessageFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get mailMessageFallbackTitle;

  /// No description provided for @mailOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open this message. Please try again.'**
  String get mailOpenFailed;

  /// No description provided for @mailFoldersLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load mail folders.'**
  String get mailFoldersLoadFailed;

  /// No description provided for @mailNoCachedMail.
  ///
  /// In en, this message translates to:
  /// **'No cached mail yet. Add an email account in Accounts, then sync its folders.'**
  String get mailNoCachedMail;

  /// No description provided for @mailFolderAccount.
  ///
  /// In en, this message translates to:
  /// **'Account {accountId}'**
  String mailFolderAccount(String accountId);

  /// No description provided for @mailAllFolders.
  ///
  /// In en, this message translates to:
  /// **'All folders'**
  String get mailAllFolders;

  /// No description provided for @mailMessagesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load messages.'**
  String get mailMessagesLoadFailed;

  /// No description provided for @mailUnknownSender.
  ///
  /// In en, this message translates to:
  /// **'(unknown sender)'**
  String get mailUnknownSender;

  /// No description provided for @mailNoSubject.
  ///
  /// In en, this message translates to:
  /// **'(no subject)'**
  String get mailNoSubject;

  /// No description provided for @mailNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages.'**
  String get mailNoMessages;

  /// No description provided for @mailEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'(empty body)'**
  String get mailEmptyBody;

  /// No description provided for @mailAttachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get mailAttachments;

  /// No description provided for @mailArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get mailArchive;

  /// No description provided for @mailMoveToTrash.
  ///
  /// In en, this message translates to:
  /// **'Move to trash'**
  String get mailMoveToTrash;

  /// No description provided for @mailMoveToTrashTooltip.
  ///
  /// In en, this message translates to:
  /// **'Move to trash'**
  String get mailMoveToTrashTooltip;

  /// No description provided for @mailRemoteContentBlocked.
  ///
  /// In en, this message translates to:
  /// **'Remote content blocked. Showing local content only.'**
  String get mailRemoteContentBlocked;

  /// No description provided for @mailShowImages.
  ///
  /// In en, this message translates to:
  /// **'Show images'**
  String get mailShowImages;

  /// No description provided for @mailImageBlocked.
  ///
  /// In en, this message translates to:
  /// **'[image blocked]'**
  String get mailImageBlocked;

  /// No description provided for @mailComposeTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get mailComposeTo;

  /// No description provided for @mailComposeToHint.
  ///
  /// In en, this message translates to:
  /// **'comma-separated'**
  String get mailComposeToHint;

  /// No description provided for @mailComposeSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get mailComposeSubject;

  /// No description provided for @mailComposeBody.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get mailComposeBody;

  /// No description provided for @mailSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get mailSaveDraft;

  /// No description provided for @mailSaveDraftTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get mailSaveDraftTooltip;

  /// No description provided for @mailSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get mailSend;

  /// No description provided for @mailSending.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get mailSending;

  /// No description provided for @mailComposePlainTextNote.
  ///
  /// In en, this message translates to:
  /// **'Plain text only. Attachments + HTML composition land at M11 polish.'**
  String get mailComposePlainTextNote;

  /// intl DateFormat pattern for the date in reply quotes and forwarded-message headers.
  ///
  /// In en, this message translates to:
  /// **'EEE, MMM d yyyy, HH:mm'**
  String get mailQuoteDatePattern;

  /// No description provided for @mailReplyIntro.
  ///
  /// In en, this message translates to:
  /// **'On {date}, {sender} wrote:'**
  String mailReplyIntro(String date, String sender);

  /// No description provided for @mailReplySomeone.
  ///
  /// In en, this message translates to:
  /// **'someone'**
  String get mailReplySomeone;

  /// No description provided for @mailForwardHeader.
  ///
  /// In en, this message translates to:
  /// **'---------- Forwarded message ----------'**
  String get mailForwardHeader;

  /// No description provided for @mailForwardFrom.
  ///
  /// In en, this message translates to:
  /// **'From: {value}'**
  String mailForwardFrom(String value);

  /// No description provided for @mailForwardDate.
  ///
  /// In en, this message translates to:
  /// **'Date: {value}'**
  String mailForwardDate(String value);

  /// No description provided for @mailForwardSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject: {value}'**
  String mailForwardSubject(String value);

  /// No description provided for @mailForwardTo.
  ///
  /// In en, this message translates to:
  /// **'To: {value}'**
  String mailForwardTo(String value);

  /// No description provided for @mailArchivedAccountName.
  ///
  /// In en, this message translates to:
  /// **'Archived mail · {timestamp}'**
  String mailArchivedAccountName(String timestamp);

  /// No description provided for @m365ConnectTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Microsoft 365'**
  String get m365ConnectTitle;

  /// No description provided for @m365ConnectIntro.
  ///
  /// In en, this message translates to:
  /// **'courrier signs in via your tenant\'s standard OAuth flow. Your password is never sent through the app.'**
  String get m365ConnectIntro;

  /// No description provided for @m365SigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get m365SigningIn;

  /// No description provided for @m365SignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Microsoft'**
  String get m365SignIn;

  /// No description provided for @m365TryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get m365TryAgain;

  /// No description provided for @m365OpenAdminDocs.
  ///
  /// In en, this message translates to:
  /// **'Open admin docs'**
  String get m365OpenAdminDocs;

  /// No description provided for @m365OpenAdminDocsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open admin docs'**
  String get m365OpenAdminDocsTooltip;

  /// No description provided for @m365ConsentTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin consent required'**
  String get m365ConsentTitle;

  /// No description provided for @m365ConsentBody.
  ///
  /// In en, this message translates to:
  /// **'Your IT administrator needs to grant courrier access for your tenant. Share the documentation link with them, then try again.'**
  String get m365ConsentBody;

  /// No description provided for @m365BlockedTitle.
  ///
  /// In en, this message translates to:
  /// **'App blocked by tenant policy'**
  String get m365BlockedTitle;

  /// No description provided for @m365BlockedBody.
  ///
  /// In en, this message translates to:
  /// **'Your tenant blocks third-party mail apps. Ask your admin to allow courrier, then try again.'**
  String get m365BlockedBody;

  /// No description provided for @m365ImapDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'IMAP disabled by your admin'**
  String get m365ImapDisabledTitle;

  /// No description provided for @m365ImapDisabledBody.
  ///
  /// In en, this message translates to:
  /// **'IMAP is turned off on this tenant. Your admin needs to enable IMAP access for your mailbox before courrier can sync mail.'**
  String get m365ImapDisabledBody;

  /// No description provided for @m365SmtpDisabledTitle.
  ///
  /// In en, this message translates to:
  /// **'SMTP AUTH disabled for this mailbox'**
  String get m365SmtpDisabledTitle;

  /// No description provided for @m365SmtpDisabledBody.
  ///
  /// In en, this message translates to:
  /// **'Modern tenants disable SMTP AUTH per-mailbox by default. Your admin needs to enable SMTP AUTH on your mailbox to send mail.'**
  String get m365SmtpDisabledBody;

  /// No description provided for @m365FailedTitle.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get m365FailedTitle;

  /// No description provided for @m365FailedBody.
  ///
  /// In en, this message translates to:
  /// **'courrier could not sign in to Microsoft 365.'**
  String get m365FailedBody;

  /// No description provided for @m365NoRefreshToken.
  ///
  /// In en, this message translates to:
  /// **'No refresh token stored — sign in again.'**
  String get m365NoRefreshToken;

  /// No description provided for @oauthSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'User cancelled the sign-in flow.'**
  String get oauthSignInCancelled;

  /// No description provided for @oauthPlatformError.
  ///
  /// In en, this message translates to:
  /// **'AppAuth platform error'**
  String get oauthPlatformError;

  /// No description provided for @oauthRefreshError.
  ///
  /// In en, this message translates to:
  /// **'AppAuth refresh error'**
  String get oauthRefreshError;

  /// No description provided for @oauthNoAccessToken.
  ///
  /// In en, this message translates to:
  /// **'AppAuth returned no access token.'**
  String get oauthNoAccessToken;

  /// No description provided for @oauthRefreshNoAccessToken.
  ///
  /// In en, this message translates to:
  /// **'AppAuth refresh returned no access token.'**
  String get oauthRefreshNoAccessToken;

  /// No description provided for @accountsSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not sync. Check the network and reconnect with current credentials. Cached data is retained.'**
  String get accountsSyncFailed;

  /// No description provided for @accountsDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected. Cached data remains on this device. Add the same server and username to reconnect.'**
  String get accountsDisconnected;

  /// No description provided for @accountsDisconnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not finish disconnecting. Please retry.'**
  String get accountsDisconnectFailed;

  /// No description provided for @accountsConnectNextcloud.
  ///
  /// In en, this message translates to:
  /// **'Connect Nextcloud'**
  String get accountsConnectNextcloud;

  /// No description provided for @accountsConnectImap.
  ///
  /// In en, this message translates to:
  /// **'Connect IMAP'**
  String get accountsConnectImap;

  /// No description provided for @accountsSyncInfo.
  ///
  /// In en, this message translates to:
  /// **'Sync runs when you tap Refresh. Mail downloads the latest 100 envelopes per folder; open a message to cache its body. Nextcloud Notes and News require their server apps. News read state is local. Microsoft 365 OAuth is not enabled in this build; its tenant registration and device sign-in still require validation.'**
  String get accountsSyncInfo;

  /// No description provided for @accountsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load accounts.'**
  String get accountsLoadFailed;

  /// No description provided for @accountsKindLocal.
  ///
  /// In en, this message translates to:
  /// **'local'**
  String get accountsKindLocal;

  /// No description provided for @accountsKindDisconnected.
  ///
  /// In en, this message translates to:
  /// **'{kind} · disconnected'**
  String accountsKindDisconnected(String kind);

  /// No description provided for @accountsPreservedConflicts.
  ///
  /// In en, this message translates to:
  /// **'Preserved sync conflicts'**
  String get accountsPreservedConflicts;

  /// No description provided for @accountsOfflineCopyName.
  ///
  /// In en, this message translates to:
  /// **'Offline copy · {name}'**
  String accountsOfflineCopyName(String name);

  /// No description provided for @accountsRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get accountsRefresh;

  /// No description provided for @accountsPendingEdits.
  ///
  /// In en, this message translates to:
  /// **'Pending edits / recovery'**
  String get accountsPendingEdits;

  /// No description provided for @accountsPendingEditsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Pending edits / recovery'**
  String get accountsPendingEditsTooltip;

  /// No description provided for @accountsDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect; keep cache'**
  String get accountsDisconnect;

  /// No description provided for @accountsConnectionIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Connection did not finish.'**
  String get accountsConnectionIncomplete;

  /// No description provided for @accountsConnectFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not connect. Check the settings and try again.'**
  String get accountsConnectFailed;

  /// No description provided for @accountsManualSettings.
  ///
  /// In en, this message translates to:
  /// **'Enter server settings manually'**
  String get accountsManualSettings;

  /// No description provided for @accountsServerUrl.
  ///
  /// In en, this message translates to:
  /// **'HTTPS server URL'**
  String get accountsServerUrl;

  /// No description provided for @accountsServerUrlHelper.
  ///
  /// In en, this message translates to:
  /// **'Include the installation subfolder, if any.'**
  String get accountsServerUrlHelper;

  /// No description provided for @accountsImapHost.
  ///
  /// In en, this message translates to:
  /// **'IMAP hostname'**
  String get accountsImapHost;

  /// No description provided for @accountsUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get accountsUsername;

  /// No description provided for @accountsEmailLogin.
  ///
  /// In en, this message translates to:
  /// **'Email / login username'**
  String get accountsEmailLogin;

  /// No description provided for @accountsAppPassword.
  ///
  /// In en, this message translates to:
  /// **'App password'**
  String get accountsAppPassword;

  /// No description provided for @accountsImapPort.
  ///
  /// In en, this message translates to:
  /// **'IMAP port'**
  String get accountsImapPort;

  /// No description provided for @accountsImapStartTls.
  ///
  /// In en, this message translates to:
  /// **'IMAP STARTTLS (usually port 143)'**
  String get accountsImapStartTls;

  /// No description provided for @accountsSmtpHost.
  ///
  /// In en, this message translates to:
  /// **'SMTP hostname (saved for future sending)'**
  String get accountsSmtpHost;

  /// No description provided for @accountsSmtpPort.
  ///
  /// In en, this message translates to:
  /// **'SMTP port'**
  String get accountsSmtpPort;

  /// No description provided for @accountsCredentialsNote.
  ///
  /// In en, this message translates to:
  /// **'Credentials are kept in platform secure storage. This screen verifies incoming access. Sending and background synchronization are not available in the current production UI.'**
  String get accountsCredentialsNote;

  /// No description provided for @accountsConnecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get accountsConnecting;

  /// No description provided for @accountsConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get accountsConnect;

  /// No description provided for @accountsPendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending edits'**
  String get accountsPendingTitle;

  /// No description provided for @accountsPreserveTitle.
  ///
  /// In en, this message translates to:
  /// **'Preserve this edit offline?'**
  String get accountsPreserveTitle;

  /// No description provided for @accountsPreserveBody.
  ///
  /// In en, this message translates to:
  /// **'The current local record will move to an offline collection, including a locally deleted record. Its upload will stop. The server is unchanged. Return to Accounts and Refresh to load the server version separately. A server write whose response was lost may already exist there.'**
  String get accountsPreserveBody;

  /// No description provided for @accountsKeepOfflineCopy.
  ///
  /// In en, this message translates to:
  /// **'Keep offline copy'**
  String get accountsKeepOfflineCopy;

  /// No description provided for @accountsPreserveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not preserve this version. Nothing was discarded; refresh the list and retry.'**
  String get accountsPreserveFailed;

  /// No description provided for @accountsPendingReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read pending edits.'**
  String get accountsPendingReadFailed;

  /// No description provided for @accountsNoPendingEdits.
  ///
  /// In en, this message translates to:
  /// **'No pending edits. Return to Accounts to refresh.'**
  String get accountsNoPendingEdits;

  /// No description provided for @accountsPendingIntro.
  ///
  /// In en, this message translates to:
  /// **'Refresh normally retries pending work with its original server precondition. If it cannot be reconciled, preserve the local record offline before reloading the server.'**
  String get accountsPendingIntro;

  /// No description provided for @accountsRecordNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get accountsRecordNote;

  /// No description provided for @accountsRecordTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get accountsRecordTask;

  /// No description provided for @accountsRecordEvent.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get accountsRecordEvent;

  /// No description provided for @accountsRecordContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get accountsRecordContact;

  /// No description provided for @accountsRecordOther.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get accountsRecordOther;

  /// No description provided for @accountsSavedEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved local edit'**
  String get accountsSavedEditTitle;

  /// No description provided for @accountsDeletionIntent.
  ///
  /// In en, this message translates to:
  /// **'Deletion intent; the original record is retained.'**
  String get accountsDeletionIntent;

  /// No description provided for @accountsReviewEdit.
  ///
  /// In en, this message translates to:
  /// **'Review saved local edit'**
  String get accountsReviewEdit;

  /// No description provided for @accountsKeepOfflineReload.
  ///
  /// In en, this message translates to:
  /// **'Keep offline copy; reload server'**
  String get accountsKeepOfflineReload;

  /// No description provided for @accountsModuleCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get accountsModuleCalendar;

  /// No description provided for @accountsModuleContacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get accountsModuleContacts;

  /// No description provided for @accountsModuleTasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get accountsModuleTasks;

  /// No description provided for @accountsModuleNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get accountsModuleNotes;

  /// No description provided for @accountsModuleNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get accountsModuleNews;

  /// No description provided for @accountsAddressBook.
  ///
  /// In en, this message translates to:
  /// **'Address book'**
  String get accountsAddressBook;

  /// No description provided for @accountsSyncLocal.
  ///
  /// In en, this message translates to:
  /// **'Local data stays on this device.'**
  String get accountsSyncLocal;

  /// No description provided for @accountsSyncMailReport.
  ///
  /// In en, this message translates to:
  /// **'Checked {folders, plural, =1{1 folder} other{{folders} folders}}; {messages, plural, =1{1 new envelope} other{{messages} new envelopes}}. Open a message to download its body.'**
  String accountsSyncMailReport(int folders, int messages);

  /// No description provided for @accountsSyncConflict.
  ///
  /// In en, this message translates to:
  /// **'{label}: conflict; local changes retained'**
  String accountsSyncConflict(String label);

  /// No description provided for @accountsSyncUploadFailed.
  ///
  /// In en, this message translates to:
  /// **'{label}: could not upload; changes retained'**
  String accountsSyncUploadFailed(String label);

  /// No description provided for @accountsSyncPulled.
  ///
  /// In en, this message translates to:
  /// **'{label}: {pulled, plural, =1{1 record read} other{{pulled} records read}}, {pushed, plural, =1{1 change sent} other{{pushed} changes sent}}'**
  String accountsSyncPulled(String label, int pulled, int pushed);

  /// No description provided for @accountsSyncPullFailed.
  ///
  /// In en, this message translates to:
  /// **'{label}: {detail}; cached data retained'**
  String accountsSyncPullFailed(String label, String detail);

  /// No description provided for @accountsSyncCouldNotRefresh.
  ///
  /// In en, this message translates to:
  /// **'could not refresh'**
  String get accountsSyncCouldNotRefresh;

  /// No description provided for @accountsSyncBackendFailed.
  ///
  /// In en, this message translates to:
  /// **'{label}: could not refresh; cached data retained. Check connection and server app permissions.'**
  String accountsSyncBackendFailed(String label);

  /// No description provided for @onboardingCredentialsRequired.
  ///
  /// In en, this message translates to:
  /// **'Username and app password are required.'**
  String get onboardingCredentialsRequired;

  /// No description provided for @onboardingNoPrincipal.
  ///
  /// In en, this message translates to:
  /// **'No authenticated DAV principal was found.'**
  String get onboardingNoPrincipal;

  /// No description provided for @onboardingNextcloudFailed.
  ///
  /// In en, this message translates to:
  /// **'Nextcloud connection failed ({kind}).'**
  String onboardingNextcloudFailed(String kind);

  /// No description provided for @onboardingBadUrl.
  ///
  /// In en, this message translates to:
  /// **'Bad URL — please paste your Nextcloud base URL.'**
  String get onboardingBadUrl;

  /// No description provided for @onboardingSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the account. Check secure storage and retry.'**
  String get onboardingSaveFailed;

  /// No description provided for @onboardingNoAutoconfig.
  ///
  /// In en, this message translates to:
  /// **'No autoconfig found for {domain}.'**
  String onboardingNoAutoconfig(String domain);

  /// No description provided for @onboardingAddManually.
  ///
  /// In en, this message translates to:
  /// **'Add the server manually from Settings → Accounts.'**
  String get onboardingAddManually;

  /// No description provided for @onboardingEmailPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Email and password are required.'**
  String get onboardingEmailPasswordRequired;

  /// No description provided for @onboardingUnencrypted.
  ///
  /// In en, this message translates to:
  /// **'Unencrypted mail connections are not supported.'**
  String get onboardingUnencrypted;

  /// No description provided for @onboardingInvalidServer.
  ///
  /// In en, this message translates to:
  /// **'Invalid mail server or port.'**
  String get onboardingInvalidServer;

  /// No description provided for @onboardingSeparateSmtpUser.
  ///
  /// In en, this message translates to:
  /// **'Separate SMTP usernames are not supported yet.'**
  String get onboardingSeparateSmtpUser;

  /// No description provided for @onboardingMailFailed.
  ///
  /// In en, this message translates to:
  /// **'Mail connection failed. Check the server settings and app password.'**
  String get onboardingMailFailed;

  /// No description provided for @onboardingM365Failed.
  ///
  /// In en, this message translates to:
  /// **'Microsoft 365 sign-in failed. Cached accounts are unchanged.'**
  String get onboardingM365Failed;

  /// No description provided for @netHttpsRequired.
  ///
  /// In en, this message translates to:
  /// **'Use an HTTPS URL without embedded credentials or a fragment.'**
  String get netHttpsRequired;

  /// No description provided for @netBaseUrlQuery.
  ///
  /// In en, this message translates to:
  /// **'The server base URL cannot contain a query.'**
  String get netBaseUrlQuery;

  /// No description provided for @netDifferentOrigin.
  ///
  /// In en, this message translates to:
  /// **'The server returned a different origin.'**
  String get netDifferentOrigin;

  /// No description provided for @netDtdUnsupported.
  ///
  /// In en, this message translates to:
  /// **'DTD and entity declarations are not supported.'**
  String get netDtdUnsupported;

  /// No description provided for @netErrorOffline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get netErrorOffline;

  /// No description provided for @netErrorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'unauthorized'**
  String get netErrorUnauthorized;

  /// No description provided for @netErrorForbidden.
  ///
  /// In en, this message translates to:
  /// **'forbidden'**
  String get netErrorForbidden;

  /// No description provided for @netErrorNotFound.
  ///
  /// In en, this message translates to:
  /// **'not found'**
  String get netErrorNotFound;

  /// No description provided for @netErrorPrecondition.
  ///
  /// In en, this message translates to:
  /// **'etag mismatch'**
  String get netErrorPrecondition;

  /// No description provided for @netErrorConflict.
  ///
  /// In en, this message translates to:
  /// **'conflict'**
  String get netErrorConflict;

  /// No description provided for @netErrorThrottled.
  ///
  /// In en, this message translates to:
  /// **'throttled'**
  String get netErrorThrottled;

  /// No description provided for @netErrorServer.
  ///
  /// In en, this message translates to:
  /// **'server error'**
  String get netErrorServer;

  /// No description provided for @netErrorParse.
  ///
  /// In en, this message translates to:
  /// **'parse failure: {detail}'**
  String netErrorParse(String detail);

  /// No description provided for @netErrorUnknown.
  ///
  /// In en, this message translates to:
  /// **'unknown network error'**
  String get netErrorUnknown;

  /// No description provided for @notesNew.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get notesNew;

  /// No description provided for @notesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get notesEdit;

  /// No description provided for @notesUnlockRequired.
  ///
  /// In en, this message translates to:
  /// **'Unlock is required to open this note.'**
  String get notesUnlockRequired;

  /// No description provided for @notesNoCollection.
  ///
  /// In en, this message translates to:
  /// **'Create a notes collection in Accounts first.'**
  String get notesNoCollection;

  /// No description provided for @notesChooseNotebook.
  ///
  /// In en, this message translates to:
  /// **'Choose a notebook'**
  String get notesChooseNotebook;

  /// No description provided for @notesOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the note. Please try again.'**
  String get notesOpenFailed;

  /// No description provided for @notesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load notes.'**
  String get notesLoadFailed;

  /// No description provided for @notesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No notes yet.'**
  String get notesEmpty;

  /// Shown instead of the first line of a locked note in the note list.
  ///
  /// In en, this message translates to:
  /// **'(locked)'**
  String get notesLockedPreview;

  /// Small marker next to the title of a checklist note.
  ///
  /// In en, this message translates to:
  /// **'checklist'**
  String get notesChecklistBadge;

  /// No description provided for @notesDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved changes?'**
  String get notesDiscardTitle;

  /// No description provided for @notesDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'Your saved note will stay unchanged.'**
  String get notesDiscardBody;

  /// No description provided for @notesKeepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get notesKeepEditing;

  /// No description provided for @notesDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get notesDiscard;

  /// No description provided for @notesUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get notesUndo;

  /// No description provided for @notesRedo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get notesRedo;

  /// No description provided for @notesFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get notesFavorite;

  /// No description provided for @notesLock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get notesLock;

  /// No description provided for @notesLockUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Configure an app lock first'**
  String get notesLockUnavailable;

  /// No description provided for @notesKindText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get notesKindText;

  /// No description provided for @notesKindChecklist.
  ///
  /// In en, this message translates to:
  /// **'Checklist'**
  String get notesKindChecklist;

  /// No description provided for @notesTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get notesTitleLabel;

  /// No description provided for @notesContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get notesContentLabel;

  /// No description provided for @notesContentHint.
  ///
  /// In en, this message translates to:
  /// **'Type — checklist mode uses markdown task lists.'**
  String get notesContentHint;

  /// No description provided for @notesSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save this note. Your draft is still here; try again.'**
  String get notesSaveFailed;

  /// No description provided for @notesSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get notesSaving;

  /// No description provided for @notesHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 edit in history} other{{count} edits in history}}'**
  String notesHistoryCount(int count);

  /// Button next to the refresh button; keep it short (full wording: feedsAddTooltip).
  ///
  /// In en, this message translates to:
  /// **'Add HTTPS feed'**
  String get feedsAdd;

  /// No description provided for @feedsAddTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add HTTPS feed'**
  String get feedsAddTooltip;

  /// Button next to the add button; keep it short (full wording: feedsRefreshTooltip).
  ///
  /// In en, this message translates to:
  /// **'Refresh local feeds'**
  String get feedsRefresh;

  /// No description provided for @feedsRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh local feeds'**
  String get feedsRefreshTooltip;

  /// No description provided for @feedsRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing…'**
  String get feedsRefreshing;

  /// No description provided for @feedsAddFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not add feed. Use an HTTPS RSS or Atom URL.'**
  String get feedsAddFailed;

  /// No description provided for @feedsRefreshPartial.
  ///
  /// In en, this message translates to:
  /// **'Some feeds could not refresh. Cached articles are retained.'**
  String get feedsRefreshPartial;

  /// No description provided for @feedsRefreshDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Checked 1 article. Nextcloud News refreshes from Accounts.} other{Checked {count} articles. Nextcloud News refreshes from Accounts.}}'**
  String feedsRefreshDone(int count);

  /// No description provided for @feedsRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh feeds. Cached articles are retained.'**
  String get feedsRefreshFailed;

  /// No description provided for @feedsSubscriptionsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load subscriptions.'**
  String get feedsSubscriptionsLoadFailed;

  /// No description provided for @feedsSubscriptionsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions yet.'**
  String get feedsSubscriptionsEmpty;

  /// No description provided for @feedsNoArticleContent.
  ///
  /// In en, this message translates to:
  /// **'No saved article content.'**
  String get feedsNoArticleContent;

  /// No description provided for @feedsArticleOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open this article. Please try again.'**
  String get feedsArticleOpenFailed;

  /// No description provided for @feedsRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove this local feed?'**
  String get feedsRemoveTitle;

  /// No description provided for @feedsRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'The subscription and its cached articles will be removed from this device. The feed website is unchanged.'**
  String get feedsRemoveBody;

  /// No description provided for @feedsRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get feedsRemove;

  /// No description provided for @feedsRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not remove the feed. Please retry.'**
  String get feedsRemoveFailed;

  /// No description provided for @feedsRemoveTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove local feed'**
  String get feedsRemoveTooltip;

  /// No description provided for @feedsArticlesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load saved articles.'**
  String get feedsArticlesLoadFailed;

  /// No description provided for @feedsItemsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No items in this feed.'**
  String get feedsItemsEmpty;

  /// No description provided for @feedsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add feed'**
  String get feedsAddTitle;

  /// No description provided for @feedsUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'HTTPS RSS or Atom URL'**
  String get feedsUrlLabel;

  /// No description provided for @feedsAddConfirm.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get feedsAddConfirm;

  /// table is the internal name of the affected data table.
  ///
  /// In en, this message translates to:
  /// **'Sync conflict — {table}'**
  String syncConflictTitle(String table);

  /// No description provided for @syncConflictBody.
  ///
  /// In en, this message translates to:
  /// **'The server has a newer version than the local copy.'**
  String get syncConflictBody;

  /// No description provided for @syncConflictLocal.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get syncConflictLocal;

  /// No description provided for @syncConflictServer.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get syncConflictServer;

  /// No description provided for @syncConflictKeepServer.
  ///
  /// In en, this message translates to:
  /// **'Keep server'**
  String get syncConflictKeepServer;

  /// No description provided for @syncConflictKeepBoth.
  ///
  /// In en, this message translates to:
  /// **'Keep both'**
  String get syncConflictKeepBoth;

  /// No description provided for @syncConflictKeepLocal.
  ///
  /// In en, this message translates to:
  /// **'Keep local'**
  String get syncConflictKeepLocal;

  /// No description provided for @whatsNewTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s new in {version}'**
  String whatsNewTitle(String version);

  /// No description provided for @whatsNewGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get whatsNewGotIt;

  /// No description provided for @modulePlaceholderNote.
  ///
  /// In en, this message translates to:
  /// **'Empty by design at M0. Module wired in during its milestone.'**
  String get modulePlaceholderNote;

  /// No description provided for @appLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock courrier'**
  String get appLockTitle;

  /// Reason shown in the system's device-authentication prompt.
  ///
  /// In en, this message translates to:
  /// **'Unlock courrier'**
  String get appLockReason;

  /// No description provided for @appLockLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading security settings…'**
  String get appLockLoading;

  /// No description provided for @appLockSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not read app-lock settings. Retry to continue.'**
  String get appLockSettingsFailed;

  /// No description provided for @appLockAuthFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication was cancelled or unavailable. Please retry.'**
  String get appLockAuthFailed;

  /// No description provided for @appLockAuthenticating.
  ///
  /// In en, this message translates to:
  /// **'Authenticating…'**
  String get appLockAuthenticating;

  /// No description provided for @appLockUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get appLockUnlock;

  /// No description provided for @calendarAgenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get calendarAgenda;

  /// No description provided for @calendarMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarMonth;

  /// No description provided for @calendarNoTitle.
  ///
  /// In en, this message translates to:
  /// **'(no title)'**
  String get calendarNoTitle;

  /// No description provided for @calendarNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events in this range.'**
  String get calendarNoEvents;

  /// No description provided for @calendarDeleteRecurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete recurring event'**
  String get calendarDeleteRecurringTitle;

  /// No description provided for @calendarDeleteThisOccurrence.
  ///
  /// In en, this message translates to:
  /// **'This occurrence only'**
  String get calendarDeleteThisOccurrence;

  /// No description provided for @calendarDeleteThisAndFollowing.
  ///
  /// In en, this message translates to:
  /// **'This and following occurrences'**
  String get calendarDeleteThisAndFollowing;

  /// No description provided for @calendarDeleteAllOccurrences.
  ///
  /// In en, this message translates to:
  /// **'All occurrences'**
  String get calendarDeleteAllOccurrences;

  /// No description provided for @calendarEventTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get calendarEventTitle;

  /// No description provided for @calendarEventStarts.
  ///
  /// In en, this message translates to:
  /// **'Starts'**
  String get calendarEventStarts;

  /// No description provided for @calendarEventEnds.
  ///
  /// In en, this message translates to:
  /// **'Ends'**
  String get calendarEventEnds;

  /// No description provided for @calendarEventAllDay.
  ///
  /// In en, this message translates to:
  /// **'All-day'**
  String get calendarEventAllDay;

  /// No description provided for @calendarEventLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get calendarEventLocation;

  /// No description provided for @calendarEventDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get calendarEventDescription;

  /// No description provided for @calendarEventRecurrence.
  ///
  /// In en, this message translates to:
  /// **'Recurrence (RRULE)'**
  String get calendarEventRecurrence;

  /// No description provided for @calendarEventOrganizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get calendarEventOrganizer;

  /// No description provided for @calendarEventAttendees.
  ///
  /// In en, this message translates to:
  /// **'Attendees (one per line)'**
  String get calendarEventAttendees;

  /// No description provided for @calendarEventReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get calendarEventReminders;

  /// Short button label next to the Reminders heading; the full wording is calendarAddReminderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get calendarAddReminder;

  /// No description provided for @calendarAddReminderTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get calendarAddReminderTooltip;

  /// No description provided for @calendarReminderMinutesBefore.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min before'**
  String calendarReminderMinutesBefore(int minutes);

  /// No description provided for @calendarReminderAtTime.
  ///
  /// In en, this message translates to:
  /// **'At a specific time'**
  String get calendarReminderAtTime;

  /// No description provided for @calendarRemoveReminder.
  ///
  /// In en, this message translates to:
  /// **'Remove reminder'**
  String get calendarRemoveReminder;

  /// No description provided for @contactsBackToList.
  ///
  /// In en, this message translates to:
  /// **'Back to contacts list'**
  String get contactsBackToList;

  /// No description provided for @contactsNoName.
  ///
  /// In en, this message translates to:
  /// **'(no name)'**
  String get contactsNoName;

  /// No description provided for @contactsEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactsEmail;

  /// No description provided for @contactsPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactsPhone;

  /// No description provided for @contactsAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get contactsAddress;

  /// No description provided for @contactsDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get contactsDisplayName;

  /// No description provided for @contactsGivenName.
  ///
  /// In en, this message translates to:
  /// **'Given name'**
  String get contactsGivenName;

  /// No description provided for @contactsFamilyName.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get contactsFamilyName;

  /// No description provided for @contactsOrganisation.
  ///
  /// In en, this message translates to:
  /// **'Organisation'**
  String get contactsOrganisation;

  /// No description provided for @contactsEmails.
  ///
  /// In en, this message translates to:
  /// **'Emails (one per line)'**
  String get contactsEmails;

  /// No description provided for @contactsPhones.
  ///
  /// In en, this message translates to:
  /// **'Phones (one per line)'**
  String get contactsPhones;

  /// No description provided for @contactsNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get contactsNote;

  /// No description provided for @contactsGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get contactsGroups;

  /// No description provided for @contactsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No contacts yet.'**
  String get contactsEmpty;

  /// No description provided for @tasksLoadFailedRetry.
  ///
  /// In en, this message translates to:
  /// **'Could not load tasks. Retry'**
  String get tasksLoadFailedRetry;

  /// No description provided for @tasksCompleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not complete the task. Your saved task is retained.'**
  String get tasksCompleteFailed;

  /// No description provided for @tasksNoSummary.
  ///
  /// In en, this message translates to:
  /// **'(no summary)'**
  String get tasksNoSummary;

  /// No description provided for @tasksEmpty.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet.'**
  String get tasksEmpty;

  /// No description provided for @remindersUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming reminders'**
  String get remindersUpcoming;

  /// No description provided for @remindersReload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get remindersReload;

  /// No description provided for @remindersScheduleLimit.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Notifications cover the next reminder. Open courrier regularly to schedule later ones.} other{Notifications cover the next {count} reminders. Open courrier regularly to schedule later ones.}}'**
  String remindersScheduleLimit(int count);

  /// No description provided for @remindersNothingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled.'**
  String get remindersNothingScheduled;

  /// No description provided for @remindersPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification permission required'**
  String get remindersPermissionTitle;

  /// No description provided for @remindersPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'courrier needs permission to send reminders for calendar events and tasks.'**
  String get remindersPermissionBody;

  /// No description provided for @remindersAllowNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get remindersAllowNotifications;

  /// No description provided for @remindersUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder notifications unavailable'**
  String get remindersUnavailableTitle;

  /// No description provided for @remindersWeekly.
  ///
  /// In en, this message translates to:
  /// **'weekly'**
  String get remindersWeekly;

  /// No description provided for @remindersLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load reminders. Please try Reload.'**
  String get remindersLoadFailed;

  /// No description provided for @remindersEnableFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not enable reminders. Check notification permissions.'**
  String get remindersEnableFailed;

  /// No description provided for @remindersReloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Reload failed. Existing reminders have been retained where possible.'**
  String get remindersReloadFailed;

  /// No description provided for @remindersRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Reminders could not refresh. Open Reminders and choose Reload.'**
  String get remindersRefreshFailed;

  /// Notification title or body when the event has no title, location or label.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get remindersNotificationFallback;

  /// Notification title for a task without a title.
  ///
  /// In en, this message translates to:
  /// **'Task due'**
  String get remindersTaskDueTitle;

  /// Notification body for a task without a description.
  ///
  /// In en, this message translates to:
  /// **'Task is due now.'**
  String get remindersTaskDueBody;

  /// Android notification channel name, shown in the system notification settings.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersChannelName;

  /// No description provided for @remindersChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Event reminders and task due-dates from courrier.'**
  String get remindersChannelDescription;

  /// No description provided for @intervalMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get intervalMinutes;

  /// No description provided for @intervalHours.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get intervalHours;

  /// No description provided for @intervalDays.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get intervalDays;

  /// No description provided for @intervalMinutesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get intervalMinutesTooltip;

  /// No description provided for @intervalHoursTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get intervalHoursTooltip;

  /// No description provided for @intervalDaysTooltip.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get intervalDaysTooltip;

  /// No description provided for @searchNoSubject.
  ///
  /// In en, this message translates to:
  /// **'(no subject)'**
  String get searchNoSubject;

  /// No description provided for @searchLocked.
  ///
  /// In en, this message translates to:
  /// **'(locked)'**
  String get searchLocked;

  /// No description provided for @rruleCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom recurrence'**
  String get rruleCustom;

  /// No description provided for @rruleDaily.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Daily} other{Every {count} days}}'**
  String rruleDaily(int count);

  /// No description provided for @rruleWeekly.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Weekly} other{Every {count} weeks}}'**
  String rruleWeekly(int count);

  /// No description provided for @rruleMonthly.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Monthly} other{Every {count} months}}'**
  String rruleMonthly(int count);

  /// No description provided for @rruleYearly.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Yearly} other{Every {count} years}}'**
  String rruleYearly(int count);

  /// No description provided for @rruleOnWeekdays.
  ///
  /// In en, this message translates to:
  /// **'on {days}'**
  String rruleOnWeekdays(String days);

  /// No description provided for @rruleOnMonthDays.
  ///
  /// In en, this message translates to:
  /// **'on the {days}'**
  String rruleOnMonthDays(String days);

  /// No description provided for @rruleInMonths.
  ///
  /// In en, this message translates to:
  /// **'in {months}'**
  String rruleInMonths(String months);

  /// No description provided for @rruleOnMonthDaysInMonths.
  ///
  /// In en, this message translates to:
  /// **'on the {days} in {months}'**
  String rruleOnMonthDaysInMonths(String days, String months);

  /// No description provided for @rruleWithCount.
  ///
  /// In en, this message translates to:
  /// **'{rule}, {count, plural, =1{1 time} other{{count} times}}'**
  String rruleWithCount(String rule, int count);

  /// No description provided for @rruleWithUntil.
  ///
  /// In en, this message translates to:
  /// **'{rule}, until {date}'**
  String rruleWithUntil(String rule, String date);

  /// Ordinal number; category is the English ordinal plural category of n (one, two, few, other).
  ///
  /// In en, this message translates to:
  /// **'{n}{category, select, one{st} two{nd} few{rd} other{th}}'**
  String rruleOrdinal(int n, String category);

  /// Day of the month counted from the end; ordinal is rruleOrdinal of n.
  ///
  /// In en, this message translates to:
  /// **'{ordinal} from last'**
  String rruleOrdinalFromLast(String ordinal, int n);

  /// No description provided for @rruleWeekdayNth.
  ///
  /// In en, this message translates to:
  /// **'the {ordinal} {day}'**
  String rruleWeekdayNth(String ordinal, String day);

  /// No description provided for @rruleWeekdayLast.
  ///
  /// In en, this message translates to:
  /// **'the last {day}'**
  String rruleWeekdayLast(String day);

  /// Weekday counted from the end of the period; ordinal is rruleOrdinal of n.
  ///
  /// In en, this message translates to:
  /// **'the {ordinal} from last {day}'**
  String rruleWeekdayNthFromLast(String ordinal, int n, String day);

  /// No description provided for @rruleListPair.
  ///
  /// In en, this message translates to:
  /// **'{first} and {second}'**
  String rruleListPair(String first, String second);

  /// Last item of a list of three or more; head is the earlier items joined with commas.
  ///
  /// In en, this message translates to:
  /// **'{head}, and {last}'**
  String rruleListSeries(String head, String last);

  /// No description provided for @rruleDayFallback.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String rruleDayFallback(int day);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
