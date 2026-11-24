// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navMail => 'mail';

  @override
  String get navCalendar => 'calendar';

  @override
  String get navContacts => 'contacts';

  @override
  String get navTasks => 'tasks';

  @override
  String get navReminders => 'reminders';

  @override
  String get navNotes => 'notes';

  @override
  String get navFeeds => 'feeds';

  @override
  String get navMore => 'more';

  @override
  String get navMoreTooltip => 'More modules';

  @override
  String shellTitle(String module) {
    return 'courrier · $module';
  }

  @override
  String get shellModules => 'Modules';

  @override
  String get shellShortcuts => 'Keyboard shortcuts';

  @override
  String get shellShortcutsBody =>
      'Ctrl / Cmd + 1–7: switch module\nCtrl / Cmd + comma: settings\nCtrl / Cmd + Shift + A: accounts\nCtrl / Cmd + N: new note (in Notes)\nF1: show this help';

  @override
  String get shellSettings => 'Settings';

  @override
  String get shellAccounts => 'Accounts';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get bootDatabaseFailed =>
      'Could not open the local database. Free storage if necessary, then retry. Existing files have been retained.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSecurity => 'Security';

  @override
  String get settingsLockToggle => 'Toggle app lock';

  @override
  String get settingsLockTitle => 'App lock (device authentication)';

  @override
  String get settingsLockSubtitle =>
      'Require unlocking when courrier resumes from background.';

  @override
  String settingsLockUnavailable(String inBuild) {
    return 'Not available $inBuild: it has no device-authentication service.';
  }

  @override
  String get settingsExportImport => 'Settings export / import';

  @override
  String get settingsExportLabel => 'Export settings as JSON';

  @override
  String get settingsExport => 'Export';

  @override
  String get settingsImportLabel => 'Import settings from JSON';

  @override
  String get settingsImport => 'Import';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSupport => 'Support development';

  @override
  String get settingsDocs => 'Documentation';

  @override
  String get settingsLicenses => 'Open-source licenses';

  @override
  String get settingsFooter =>
      'courrier is part of the Établi Suite. AGPL-3.0-only.';

  @override
  String get settingsLockAuthRequired =>
      'Device authentication is required to change app lock.';

  @override
  String get settingsLockSaveFailed => 'Could not save app-lock settings.';

  @override
  String get settingsExportTitle => 'Non-sensitive settings';

  @override
  String get settingsCopyJson => 'Copy JSON';

  @override
  String get settingsExportFailed => 'Could not export settings.';

  @override
  String settingsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Imported $count preferences.',
      one: 'Imported 1 preference.',
    );
    return '$_temp0';
  }

  @override
  String get settingsImportFailed =>
      'Import failed. Use a supported settings export with valid preference values.';

  @override
  String get settingsLoadFailed =>
      'Could not load settings. Reopen this screen to retry.';

  @override
  String get settingsImportTitle => 'Import settings JSON';

  @override
  String get settingsImportHint =>
      'Paste a settings export. App lock and credentials are excluded.';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'App language';

  @override
  String get settingsMode => 'Mode';

  @override
  String get modeSystem => 'System';

  @override
  String get modeLight => 'Light';

  @override
  String get modeDark => 'Dark';

  @override
  String get languageSystem => 'System';

  @override
  String get settingsAccent => 'Accent colour';

  @override
  String get accentCoderBlue => 'Coder blue';

  @override
  String get accentGreen => 'Green';

  @override
  String get accentYellow => 'Yellow';

  @override
  String get accentOrange => 'Orange';

  @override
  String get accentRed => 'Red';

  @override
  String get accentPurple => 'Purple';

  @override
  String get accentGraphite => 'Graphite';

  @override
  String get settingsAppearanceNote =>
      'Language, mode and accent colour apply at once. Default: Hugo Coder palette.';

  @override
  String get platformBuildLinux => 'the Linux build';

  @override
  String get platformBuildWindows => 'the Windows build';

  @override
  String get platformBuildMacos => 'the macOS build';

  @override
  String get platformBuildThis => 'this build';

  @override
  String get platformInLinux => 'in the Linux build';

  @override
  String get platformInWindows => 'in the Windows build';

  @override
  String get platformInMacos => 'in the macOS build';

  @override
  String get platformInThis => 'in this build';

  @override
  String shellRemindersUnavailable(String inBuild) {
    return 'Reminder notifications are not delivered $inBuild yet. The list below shows what is due; check it while courrier is open.';
  }

  @override
  String get mailBodyNotDownloaded =>
      'This message body has not been downloaded. Connect the account and sync this folder to read it offline.';

  @override
  String get mailMessageFallbackTitle => 'Message';

  @override
  String get mailOpenFailed => 'Could not open this message. Please try again.';

  @override
  String get mailFoldersLoadFailed => 'Could not load mail folders.';

  @override
  String get mailNoCachedMail =>
      'No cached mail yet. Add an email account in Accounts, then sync its folders.';

  @override
  String mailFolderAccount(String accountId) {
    return 'Account $accountId';
  }

  @override
  String get mailAllFolders => 'All folders';

  @override
  String get mailMessagesLoadFailed => 'Could not load messages.';

  @override
  String get mailUnknownSender => '(unknown sender)';

  @override
  String get mailNoSubject => '(no subject)';

  @override
  String get mailNoMessages => 'No messages.';

  @override
  String get mailEmptyBody => '(empty body)';

  @override
  String get mailAttachments => 'Attachments';

  @override
  String get mailArchive => 'Archive';

  @override
  String get mailMoveToTrash => 'Move to trash';

  @override
  String get mailMoveToTrashTooltip => 'Move to trash';

  @override
  String get mailRemoteContentBlocked =>
      'Remote content blocked. Showing local content only.';

  @override
  String get mailShowImages => 'Show images';

  @override
  String get mailImageBlocked => '[image blocked]';

  @override
  String get mailComposeTo => 'To';

  @override
  String get mailComposeToHint => 'comma-separated';

  @override
  String get mailComposeSubject => 'Subject';

  @override
  String get mailComposeBody => 'Body';

  @override
  String get mailSaveDraft => 'Save draft';

  @override
  String get mailSaveDraftTooltip => 'Save draft';

  @override
  String get mailSend => 'Send';

  @override
  String get mailSending => 'Sending…';

  @override
  String get mailComposePlainTextNote =>
      'Plain text only. Attachments + HTML composition land at M11 polish.';

  @override
  String get mailQuoteDatePattern => 'EEE, MMM d yyyy, HH:mm';

  @override
  String mailReplyIntro(String date, String sender) {
    return 'On $date, $sender wrote:';
  }

  @override
  String get mailReplySomeone => 'someone';

  @override
  String get mailForwardHeader => '---------- Forwarded message ----------';

  @override
  String mailForwardFrom(String value) {
    return 'From: $value';
  }

  @override
  String mailForwardDate(String value) {
    return 'Date: $value';
  }

  @override
  String mailForwardSubject(String value) {
    return 'Subject: $value';
  }

  @override
  String mailForwardTo(String value) {
    return 'To: $value';
  }

  @override
  String mailArchivedAccountName(String timestamp) {
    return 'Archived mail · $timestamp';
  }

  @override
  String get m365ConnectTitle => 'Connect Microsoft 365';

  @override
  String get m365ConnectIntro =>
      'courrier signs in via your tenant\'s standard OAuth flow. Your password is never sent through the app.';

  @override
  String get m365SigningIn => 'Signing in…';

  @override
  String get m365SignIn => 'Sign in with Microsoft';

  @override
  String get m365TryAgain => 'Try again';

  @override
  String get m365OpenAdminDocs => 'Open admin docs';

  @override
  String get m365OpenAdminDocsTooltip => 'Open admin docs';

  @override
  String get m365ConsentTitle => 'Admin consent required';

  @override
  String get m365ConsentBody =>
      'Your IT administrator needs to grant courrier access for your tenant. Share the documentation link with them, then try again.';

  @override
  String get m365BlockedTitle => 'App blocked by tenant policy';

  @override
  String get m365BlockedBody =>
      'Your tenant blocks third-party mail apps. Ask your admin to allow courrier, then try again.';

  @override
  String get m365ImapDisabledTitle => 'IMAP disabled by your admin';

  @override
  String get m365ImapDisabledBody =>
      'IMAP is turned off on this tenant. Your admin needs to enable IMAP access for your mailbox before courrier can sync mail.';

  @override
  String get m365SmtpDisabledTitle => 'SMTP AUTH disabled for this mailbox';

  @override
  String get m365SmtpDisabledBody =>
      'Modern tenants disable SMTP AUTH per-mailbox by default. Your admin needs to enable SMTP AUTH on your mailbox to send mail.';

  @override
  String get m365FailedTitle => 'Connection failed';

  @override
  String get m365FailedBody => 'courrier could not sign in to Microsoft 365.';

  @override
  String get m365NoRefreshToken => 'No refresh token stored — sign in again.';

  @override
  String get oauthSignInCancelled => 'User cancelled the sign-in flow.';

  @override
  String get oauthPlatformError => 'AppAuth platform error';

  @override
  String get oauthRefreshError => 'AppAuth refresh error';

  @override
  String get oauthNoAccessToken => 'AppAuth returned no access token.';

  @override
  String get oauthRefreshNoAccessToken =>
      'AppAuth refresh returned no access token.';

  @override
  String get accountsSyncFailed =>
      'Could not sync. Check the network and reconnect with current credentials. Cached data is retained.';

  @override
  String get accountsDisconnected =>
      'Disconnected. Cached data remains on this device. Add the same server and username to reconnect.';

  @override
  String get accountsDisconnectFailed =>
      'Could not finish disconnecting. Please retry.';

  @override
  String get accountsConnectNextcloud => 'Connect Nextcloud';

  @override
  String get accountsConnectImap => 'Connect IMAP';

  @override
  String get accountsSyncInfo =>
      'Sync runs when you tap Refresh. Mail downloads the latest 100 envelopes per folder; open a message to cache its body. Nextcloud Notes and News require their server apps. News read state is local. Microsoft 365 OAuth is not enabled in this build; its tenant registration and device sign-in still require validation.';

  @override
  String get accountsLoadFailed => 'Could not load accounts.';

  @override
  String get accountsKindLocal => 'local';

  @override
  String accountsKindDisconnected(String kind) {
    return '$kind · disconnected';
  }

  @override
  String get accountsPreservedConflicts => 'Preserved sync conflicts';

  @override
  String accountsOfflineCopyName(String name) {
    return 'Offline copy · $name';
  }

  @override
  String get accountsRefresh => 'Refresh';

  @override
  String get accountsPendingEdits => 'Pending edits / recovery';

  @override
  String get accountsPendingEditsTooltip => 'Pending edits / recovery';

  @override
  String get accountsDisconnect => 'Disconnect; keep cache';

  @override
  String get accountsConnectionIncomplete => 'Connection did not finish.';

  @override
  String get accountsConnectFailed =>
      'Could not connect. Check the settings and try again.';

  @override
  String get accountsManualSettings => 'Enter server settings manually';

  @override
  String get accountsServerUrl => 'HTTPS server URL';

  @override
  String get accountsServerUrlHelper =>
      'Include the installation subfolder, if any.';

  @override
  String get accountsImapHost => 'IMAP hostname';

  @override
  String get accountsUsername => 'Username';

  @override
  String get accountsEmailLogin => 'Email / login username';

  @override
  String get accountsAppPassword => 'App password';

  @override
  String get accountsImapPort => 'IMAP port';

  @override
  String get accountsImapStartTls => 'IMAP STARTTLS (usually port 143)';

  @override
  String get accountsSmtpHost => 'SMTP hostname (saved for future sending)';

  @override
  String get accountsSmtpPort => 'SMTP port';

  @override
  String get accountsCredentialsNote =>
      'Credentials are kept in platform secure storage. This screen verifies incoming access. Sending and background synchronization are not available in the current production UI.';

  @override
  String get accountsConnecting => 'Connecting…';

  @override
  String get accountsConnect => 'Connect';

  @override
  String get accountsPendingTitle => 'Pending edits';

  @override
  String get accountsPreserveTitle => 'Preserve this edit offline?';

  @override
  String get accountsPreserveBody =>
      'The current local record will move to an offline collection, including a locally deleted record. Its upload will stop. The server is unchanged. Return to Accounts and Refresh to load the server version separately. A server write whose response was lost may already exist there.';

  @override
  String get accountsKeepOfflineCopy => 'Keep offline copy';

  @override
  String get accountsPreserveFailed =>
      'Could not preserve this version. Nothing was discarded; refresh the list and retry.';

  @override
  String get accountsPendingReadFailed => 'Could not read pending edits.';

  @override
  String get accountsNoPendingEdits =>
      'No pending edits. Return to Accounts to refresh.';

  @override
  String get accountsPendingIntro =>
      'Refresh normally retries pending work with its original server precondition. If it cannot be reconciled, preserve the local record offline before reloading the server.';

  @override
  String get accountsRecordNote => 'Note';

  @override
  String get accountsRecordTask => 'Task';

  @override
  String get accountsRecordEvent => 'Event';

  @override
  String get accountsRecordContact => 'Contact';

  @override
  String get accountsRecordOther => 'Record';

  @override
  String get accountsSavedEditTitle => 'Saved local edit';

  @override
  String get accountsDeletionIntent =>
      'Deletion intent; the original record is retained.';

  @override
  String get accountsReviewEdit => 'Review saved local edit';

  @override
  String get accountsKeepOfflineReload => 'Keep offline copy; reload server';

  @override
  String get accountsModuleCalendar => 'Calendar';

  @override
  String get accountsModuleContacts => 'Contacts';

  @override
  String get accountsModuleTasks => 'Tasks';

  @override
  String get accountsModuleNotes => 'Notes';

  @override
  String get accountsModuleNews => 'News';

  @override
  String get accountsAddressBook => 'Address book';

  @override
  String get accountsSyncLocal => 'Local data stays on this device.';

  @override
  String accountsSyncMailReport(int folders, int messages) {
    String _temp0 = intl.Intl.pluralLogic(
      folders,
      locale: localeName,
      other: '$folders folders',
      one: '1 folder',
    );
    String _temp1 = intl.Intl.pluralLogic(
      messages,
      locale: localeName,
      other: '$messages new envelopes',
      one: '1 new envelope',
    );
    return 'Checked $_temp0; $_temp1. Open a message to download its body.';
  }

  @override
  String accountsSyncConflict(String label) {
    return '$label: conflict; local changes retained';
  }

  @override
  String accountsSyncUploadFailed(String label) {
    return '$label: could not upload; changes retained';
  }

  @override
  String accountsSyncPulled(String label, int pulled, int pushed) {
    String _temp0 = intl.Intl.pluralLogic(
      pulled,
      locale: localeName,
      other: '$pulled records read',
      one: '1 record read',
    );
    String _temp1 = intl.Intl.pluralLogic(
      pushed,
      locale: localeName,
      other: '$pushed changes sent',
      one: '1 change sent',
    );
    return '$label: $_temp0, $_temp1';
  }

  @override
  String accountsSyncPullFailed(String label, String detail) {
    return '$label: $detail; cached data retained';
  }

  @override
  String get accountsSyncCouldNotRefresh => 'could not refresh';

  @override
  String accountsSyncBackendFailed(String label) {
    return '$label: could not refresh; cached data retained. Check connection and server app permissions.';
  }

  @override
  String get onboardingCredentialsRequired =>
      'Username and app password are required.';

  @override
  String get onboardingNoPrincipal =>
      'No authenticated DAV principal was found.';

  @override
  String onboardingNextcloudFailed(String kind) {
    return 'Nextcloud connection failed ($kind).';
  }

  @override
  String get onboardingBadUrl =>
      'Bad URL — please paste your Nextcloud base URL.';

  @override
  String get onboardingSaveFailed =>
      'Could not save the account. Check secure storage and retry.';

  @override
  String onboardingNoAutoconfig(String domain) {
    return 'No autoconfig found for $domain.';
  }

  @override
  String get onboardingAddManually =>
      'Add the server manually from Settings → Accounts.';

  @override
  String get onboardingEmailPasswordRequired =>
      'Email and password are required.';

  @override
  String get onboardingUnencrypted =>
      'Unencrypted mail connections are not supported.';

  @override
  String get onboardingInvalidServer => 'Invalid mail server or port.';

  @override
  String get onboardingSeparateSmtpUser =>
      'Separate SMTP usernames are not supported yet.';

  @override
  String get onboardingMailFailed =>
      'Mail connection failed. Check the server settings and app password.';

  @override
  String get onboardingM365Failed =>
      'Microsoft 365 sign-in failed. Cached accounts are unchanged.';

  @override
  String get netHttpsRequired =>
      'Use an HTTPS URL without embedded credentials or a fragment.';

  @override
  String get netBaseUrlQuery => 'The server base URL cannot contain a query.';

  @override
  String get netDifferentOrigin => 'The server returned a different origin.';

  @override
  String get netDtdUnsupported =>
      'DTD and entity declarations are not supported.';

  @override
  String get netErrorOffline => 'offline';

  @override
  String get netErrorUnauthorized => 'unauthorized';

  @override
  String get netErrorForbidden => 'forbidden';

  @override
  String get netErrorNotFound => 'not found';

  @override
  String get netErrorPrecondition => 'etag mismatch';

  @override
  String get netErrorConflict => 'conflict';

  @override
  String get netErrorThrottled => 'throttled';

  @override
  String get netErrorServer => 'server error';

  @override
  String netErrorParse(String detail) {
    return 'parse failure: $detail';
  }

  @override
  String get netErrorUnknown => 'unknown network error';

  @override
  String get notesNew => 'New note';

  @override
  String get notesEdit => 'Edit note';

  @override
  String get notesUnlockRequired => 'Unlock is required to open this note.';

  @override
  String get notesNoCollection =>
      'Create a notes collection in Accounts first.';

  @override
  String get notesChooseNotebook => 'Choose a notebook';

  @override
  String get notesOpenFailed => 'Could not open the note. Please try again.';

  @override
  String get notesLoadFailed => 'Could not load notes.';

  @override
  String get notesEmpty => 'No notes yet.';

  @override
  String get notesLockedPreview => '(locked)';

  @override
  String get notesChecklistBadge => 'checklist';

  @override
  String get notesDiscardTitle => 'Discard unsaved changes?';

  @override
  String get notesDiscardBody => 'Your saved note will stay unchanged.';

  @override
  String get notesKeepEditing => 'Keep editing';

  @override
  String get notesDiscard => 'Discard';

  @override
  String get notesUndo => 'Undo';

  @override
  String get notesRedo => 'Redo';

  @override
  String get notesFavorite => 'Favorite';

  @override
  String get notesLock => 'Lock';

  @override
  String get notesLockUnavailable => 'Configure an app lock first';

  @override
  String get notesKindText => 'Text';

  @override
  String get notesKindChecklist => 'Checklist';

  @override
  String get notesTitleLabel => 'Title';

  @override
  String get notesContentLabel => 'Content';

  @override
  String get notesContentHint =>
      'Type — checklist mode uses markdown task lists.';

  @override
  String get notesSaveFailed =>
      'Could not save this note. Your draft is still here; try again.';

  @override
  String get notesSaving => 'Saving…';

  @override
  String notesHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count edits in history',
      one: '1 edit in history',
    );
    return '$_temp0';
  }

  @override
  String get feedsAdd => 'Add HTTPS feed';

  @override
  String get feedsAddTooltip => 'Add HTTPS feed';

  @override
  String get feedsRefresh => 'Refresh local feeds';

  @override
  String get feedsRefreshTooltip => 'Refresh local feeds';

  @override
  String get feedsRefreshing => 'Refreshing…';

  @override
  String get feedsAddFailed =>
      'Could not add feed. Use an HTTPS RSS or Atom URL.';

  @override
  String get feedsRefreshPartial =>
      'Some feeds could not refresh. Cached articles are retained.';

  @override
  String feedsRefreshDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Checked $count articles. Nextcloud News refreshes from Accounts.',
      one: 'Checked 1 article. Nextcloud News refreshes from Accounts.',
    );
    return '$_temp0';
  }

  @override
  String get feedsRefreshFailed =>
      'Could not refresh feeds. Cached articles are retained.';

  @override
  String get feedsSubscriptionsLoadFailed => 'Could not load subscriptions.';

  @override
  String get feedsSubscriptionsEmpty => 'No subscriptions yet.';

  @override
  String get feedsNoArticleContent => 'No saved article content.';

  @override
  String get feedsArticleOpenFailed =>
      'Could not open this article. Please try again.';

  @override
  String get feedsRemoveTitle => 'Remove this local feed?';

  @override
  String get feedsRemoveBody =>
      'The subscription and its cached articles will be removed from this device. The feed website is unchanged.';

  @override
  String get feedsRemove => 'Remove';

  @override
  String get feedsRemoveFailed => 'Could not remove the feed. Please retry.';

  @override
  String get feedsRemoveTooltip => 'Remove local feed';

  @override
  String get feedsArticlesLoadFailed => 'Could not load saved articles.';

  @override
  String get feedsItemsEmpty => 'No items in this feed.';

  @override
  String get feedsAddTitle => 'Add feed';

  @override
  String get feedsUrlLabel => 'HTTPS RSS or Atom URL';

  @override
  String get feedsAddConfirm => 'Add';

  @override
  String syncConflictTitle(String table) {
    return 'Sync conflict — $table';
  }

  @override
  String get syncConflictBody =>
      'The server has a newer version than the local copy.';

  @override
  String get syncConflictLocal => 'Local';

  @override
  String get syncConflictServer => 'Server';

  @override
  String get syncConflictKeepServer => 'Keep server';

  @override
  String get syncConflictKeepBoth => 'Keep both';

  @override
  String get syncConflictKeepLocal => 'Keep local';

  @override
  String whatsNewTitle(String version) {
    return 'What\'s new in $version';
  }

  @override
  String get whatsNewGotIt => 'Got it';

  @override
  String get modulePlaceholderNote =>
      'Empty by design at M0. Module wired in during its milestone.';

  @override
  String get appLockTitle => 'Unlock courrier';

  @override
  String get appLockReason => 'Unlock courrier';

  @override
  String get appLockLoading => 'Loading security settings…';

  @override
  String get appLockSettingsFailed =>
      'Could not read app-lock settings. Retry to continue.';

  @override
  String get appLockAuthFailed =>
      'Authentication was cancelled or unavailable. Please retry.';

  @override
  String get appLockAuthenticating => 'Authenticating…';

  @override
  String get appLockUnlock => 'Unlock';

  @override
  String get calendarAgenda => 'Agenda';

  @override
  String get calendarMonth => 'Month';

  @override
  String get calendarNoTitle => '(no title)';

  @override
  String get calendarNoEvents => 'No events in this range.';

  @override
  String get calendarDeleteRecurringTitle => 'Delete recurring event';

  @override
  String get calendarDeleteThisOccurrence => 'This occurrence only';

  @override
  String get calendarDeleteThisAndFollowing => 'This and following occurrences';

  @override
  String get calendarDeleteAllOccurrences => 'All occurrences';

  @override
  String get calendarEventTitle => 'Title';

  @override
  String get calendarEventStarts => 'Starts';

  @override
  String get calendarEventEnds => 'Ends';

  @override
  String get calendarEventAllDay => 'All-day';

  @override
  String get calendarEventLocation => 'Location';

  @override
  String get calendarEventDescription => 'Description';

  @override
  String get calendarEventRecurrence => 'Recurrence (RRULE)';

  @override
  String get calendarEventOrganizer => 'Organizer';

  @override
  String get calendarEventAttendees => 'Attendees (one per line)';

  @override
  String get calendarEventReminders => 'Reminders';

  @override
  String get calendarAddReminder => 'Add reminder';

  @override
  String get calendarAddReminderTooltip => 'Add reminder';

  @override
  String calendarReminderMinutesBefore(int minutes) {
    return '$minutes min before';
  }

  @override
  String get calendarReminderAtTime => 'At a specific time';

  @override
  String get calendarRemoveReminder => 'Remove reminder';

  @override
  String get contactsBackToList => 'Back to contacts list';

  @override
  String get contactsNoName => '(no name)';

  @override
  String get contactsEmail => 'Email';

  @override
  String get contactsPhone => 'Phone';

  @override
  String get contactsAddress => 'Address';

  @override
  String get contactsDisplayName => 'Display name';

  @override
  String get contactsGivenName => 'Given name';

  @override
  String get contactsFamilyName => 'Family name';

  @override
  String get contactsOrganisation => 'Organisation';

  @override
  String get contactsEmails => 'Emails (one per line)';

  @override
  String get contactsPhones => 'Phones (one per line)';

  @override
  String get contactsNote => 'Note';

  @override
  String get contactsGroups => 'Groups';

  @override
  String get contactsEmpty => 'No contacts yet.';

  @override
  String get tasksLoadFailedRetry => 'Could not load tasks. Retry';

  @override
  String get tasksCompleteFailed =>
      'Could not complete the task. Your saved task is retained.';

  @override
  String get tasksNoSummary => '(no summary)';

  @override
  String get tasksEmpty => 'No tasks yet.';

  @override
  String get remindersUpcoming => 'Upcoming reminders';

  @override
  String get remindersReload => 'Reload';

  @override
  String remindersScheduleLimit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Notifications cover the next $count reminders. Open courrier regularly to schedule later ones.',
      one:
          'Notifications cover the next reminder. Open courrier regularly to schedule later ones.',
    );
    return '$_temp0';
  }

  @override
  String get remindersNothingScheduled => 'Nothing scheduled.';

  @override
  String get remindersPermissionTitle => 'Notification permission required';

  @override
  String get remindersPermissionBody =>
      'courrier needs permission to send reminders for calendar events and tasks.';

  @override
  String get remindersAllowNotifications => 'Allow notifications';

  @override
  String get remindersUnavailableTitle => 'Reminder notifications unavailable';

  @override
  String get remindersWeekly => 'weekly';

  @override
  String get remindersLoadFailed =>
      'Could not load reminders. Please try Reload.';

  @override
  String get remindersEnableFailed =>
      'Could not enable reminders. Check notification permissions.';

  @override
  String get remindersReloadFailed =>
      'Reload failed. Existing reminders have been retained where possible.';

  @override
  String get remindersRefreshFailed =>
      'Reminders could not refresh. Open Reminders and choose Reload.';

  @override
  String get remindersNotificationFallback => 'Reminder';

  @override
  String get remindersTaskDueTitle => 'Task due';

  @override
  String get remindersTaskDueBody => 'Task is due now.';

  @override
  String get remindersChannelName => 'Reminders';

  @override
  String get remindersChannelDescription =>
      'Event reminders and task due-dates from courrier.';

  @override
  String get intervalMinutes => 'min';

  @override
  String get intervalHours => 'hr';

  @override
  String get intervalDays => 'day';

  @override
  String get intervalMinutesTooltip => 'Minutes';

  @override
  String get intervalHoursTooltip => 'Hours';

  @override
  String get intervalDaysTooltip => 'Days';

  @override
  String get searchNoSubject => '(no subject)';

  @override
  String get searchLocked => '(locked)';

  @override
  String get rruleCustom => 'Custom recurrence';

  @override
  String rruleDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Daily',
    );
    return '$_temp0';
  }

  @override
  String rruleWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Weekly',
    );
    return '$_temp0';
  }

  @override
  String rruleMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Monthly',
    );
    return '$_temp0';
  }

  @override
  String rruleYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Yearly',
    );
    return '$_temp0';
  }

  @override
  String rruleOnWeekdays(String days) {
    return 'on $days';
  }

  @override
  String rruleOnMonthDays(String days) {
    return 'on the $days';
  }

  @override
  String rruleInMonths(String months) {
    return 'in $months';
  }

  @override
  String rruleOnMonthDaysInMonths(String days, String months) {
    return 'on the $days in $months';
  }

  @override
  String rruleWithCount(String rule, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: '1 time',
    );
    return '$rule, $_temp0';
  }

  @override
  String rruleWithUntil(String rule, String date) {
    return '$rule, until $date';
  }

  @override
  String rruleOrdinal(int n, String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'one': 'st',
      'two': 'nd',
      'few': 'rd',
      'other': 'th',
    });
    return '$n$_temp0';
  }

  @override
  String rruleOrdinalFromLast(String ordinal, int n) {
    return '$ordinal from last';
  }

  @override
  String rruleWeekdayNth(String ordinal, String day) {
    return 'the $ordinal $day';
  }

  @override
  String rruleWeekdayLast(String day) {
    return 'the last $day';
  }

  @override
  String rruleWeekdayNthFromLast(String ordinal, int n, String day) {
    return 'the $ordinal from last $day';
  }

  @override
  String rruleListPair(String first, String second) {
    return '$first and $second';
  }

  @override
  String rruleListSeries(String head, String last) {
    return '$head, and $last';
  }

  @override
  String rruleDayFallback(int day) {
    return 'Day $day';
  }
}
