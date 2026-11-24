// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navMail => 'mail';

  @override
  String get navCalendar => 'kalender';

  @override
  String get navContacts => 'kontakte';

  @override
  String get navTasks => 'aufgaben';

  @override
  String get navReminders => 'erinnerungen';

  @override
  String get navNotes => 'notizen';

  @override
  String get navFeeds => 'feeds';

  @override
  String get navMore => 'mehr';

  @override
  String get navMoreTooltip => 'Weitere Module';

  @override
  String shellTitle(String module) {
    return 'courrier · $module';
  }

  @override
  String get shellModules => 'Module';

  @override
  String get shellShortcuts => 'Tastenkürzel';

  @override
  String get shellShortcutsBody =>
      'Strg / Cmd + 1–7: Modul wechseln\nStrg / Cmd + Komma: Einstellungen\nStrg / Cmd + Umschalt + A: Konten\nStrg / Cmd + N: neue Notiz (in Notizen)\nF1: diese Hilfe anzeigen';

  @override
  String get shellSettings => 'Einstellungen';

  @override
  String get shellAccounts => 'Konten';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonOk => 'OK';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get bootDatabaseFailed =>
      'Die lokale Datenbank konnte nicht geöffnet werden. Gib bei Bedarf Speicher frei und versuche es erneut. Vorhandene Dateien bleiben erhalten.';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsSecurity => 'Sicherheit';

  @override
  String get settingsLockToggle => 'App-Sperre umschalten';

  @override
  String get settingsLockTitle => 'App-Sperre (Geräteauthentifizierung)';

  @override
  String get settingsLockSubtitle =>
      'Beim Zurückkehren aus dem Hintergrund entsperren lassen.';

  @override
  String settingsLockUnavailable(String inBuild) {
    return 'Nicht verfügbar $inBuild: Dort gibt es keinen Dienst für die Geräteauthentifizierung.';
  }

  @override
  String get settingsExportImport => 'Einstellungen exportieren / importieren';

  @override
  String get settingsExportLabel => 'Einstellungen als JSON exportieren';

  @override
  String get settingsExport => 'Exportieren';

  @override
  String get settingsImportLabel => 'Einstellungen aus JSON importieren';

  @override
  String get settingsImport => 'Importieren';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsSupport => 'Entwicklung unterstützen';

  @override
  String get settingsDocs => 'Dokumentation';

  @override
  String get settingsLicenses => 'Open-Source-Lizenzen';

  @override
  String get settingsFooter =>
      'courrier gehört zur Établi Suite. AGPL-3.0-only.';

  @override
  String get settingsLockAuthRequired =>
      'Zum Ändern der App-Sperre ist die Geräteauthentifizierung nötig.';

  @override
  String get settingsLockSaveFailed =>
      'Die App-Sperre konnte nicht gespeichert werden.';

  @override
  String get settingsExportTitle => 'Nicht vertrauliche Einstellungen';

  @override
  String get settingsCopyJson => 'JSON kopieren';

  @override
  String get settingsExportFailed =>
      'Die Einstellungen konnten nicht exportiert werden.';

  @override
  String settingsImported(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Einstellungen importiert.',
      one: '1 Einstellung importiert.',
    );
    return '$_temp0';
  }

  @override
  String get settingsImportFailed =>
      'Import fehlgeschlagen. Verwende einen unterstützten Einstellungsexport mit gültigen Werten.';

  @override
  String get settingsLoadFailed =>
      'Die Einstellungen konnten nicht geladen werden. Öffne diese Seite erneut.';

  @override
  String get settingsImportTitle => 'Einstellungs-JSON importieren';

  @override
  String get settingsImportHint =>
      'Einstellungsexport einfügen. App-Sperre und Zugangsdaten sind ausgenommen.';

  @override
  String get settingsAppearance => 'Darstellung';

  @override
  String get settingsLanguage => 'App-Sprache';

  @override
  String get settingsMode => 'Modus';

  @override
  String get modeSystem => 'System';

  @override
  String get modeLight => 'Hell';

  @override
  String get modeDark => 'Dunkel';

  @override
  String get languageSystem => 'System';

  @override
  String get settingsAccent => 'Akzentfarbe';

  @override
  String get accentCoderBlue => 'Coder-Blau';

  @override
  String get accentGreen => 'Grün';

  @override
  String get accentYellow => 'Gelb';

  @override
  String get accentOrange => 'Orange';

  @override
  String get accentRed => 'Rot';

  @override
  String get accentPurple => 'Violett';

  @override
  String get accentGraphite => 'Graphit';

  @override
  String get settingsAppearanceNote =>
      'Sprache, Modus und Akzentfarbe gelten sofort. Voreinstellung: Hugo-Coder-Palette.';

  @override
  String get platformBuildLinux => 'der Linux-Build';

  @override
  String get platformBuildWindows => 'der Windows-Build';

  @override
  String get platformBuildMacos => 'der macOS-Build';

  @override
  String get platformBuildThis => 'dieser Build';

  @override
  String get platformInLinux => 'im Linux-Build';

  @override
  String get platformInWindows => 'im Windows-Build';

  @override
  String get platformInMacos => 'im macOS-Build';

  @override
  String get platformInThis => 'in diesem Build';

  @override
  String shellRemindersUnavailable(String inBuild) {
    return 'Erinnerungen werden $inBuild noch nicht zugestellt. Die Liste unten zeigt, was fällig ist; sieh sie dir an, solange courrier geöffnet ist.';
  }

  @override
  String get mailBodyNotDownloaded =>
      'Der Inhalt dieser Nachricht wurde noch nicht geladen. Verbinde das Konto und synchronisiere diesen Ordner, um sie offline zu lesen.';

  @override
  String get mailMessageFallbackTitle => 'Nachricht';

  @override
  String get mailOpenFailed =>
      'Die Nachricht konnte nicht geöffnet werden. Bitte versuche es erneut.';

  @override
  String get mailFoldersLoadFailed =>
      'Die Mail-Ordner konnten nicht geladen werden.';

  @override
  String get mailNoCachedMail =>
      'Noch keine Mails gespeichert. Füge unter „Konten“ ein E-Mail-Konto hinzu und synchronisiere dann seine Ordner.';

  @override
  String mailFolderAccount(String accountId) {
    return 'Konto $accountId';
  }

  @override
  String get mailAllFolders => 'Alle Ordner';

  @override
  String get mailMessagesLoadFailed =>
      'Die Nachrichten konnten nicht geladen werden.';

  @override
  String get mailUnknownSender => '(unbekannter Absender)';

  @override
  String get mailNoSubject => '(kein Betreff)';

  @override
  String get mailNoMessages => 'Keine Nachrichten.';

  @override
  String get mailEmptyBody => '(kein Inhalt)';

  @override
  String get mailAttachments => 'Anhänge';

  @override
  String get mailArchive => 'Archivieren';

  @override
  String get mailMoveToTrash => 'In Papierkorb';

  @override
  String get mailMoveToTrashTooltip => 'In den Papierkorb verschieben';

  @override
  String get mailRemoteContentBlocked =>
      'Externe Inhalte blockiert. Es werden nur lokale Inhalte angezeigt.';

  @override
  String get mailShowImages => 'Bilder laden';

  @override
  String get mailImageBlocked => '[Bild blockiert]';

  @override
  String get mailComposeTo => 'An';

  @override
  String get mailComposeToHint => 'durch Kommas getrennt';

  @override
  String get mailComposeSubject => 'Betreff';

  @override
  String get mailComposeBody => 'Nachricht';

  @override
  String get mailSaveDraft => 'Speichern';

  @override
  String get mailSaveDraftTooltip => 'Entwurf speichern';

  @override
  String get mailSend => 'Senden';

  @override
  String get mailSending => 'Wird gesendet …';

  @override
  String get mailComposePlainTextNote =>
      'Nur reiner Text. Anhänge und HTML-Nachrichten folgen mit dem M11-Feinschliff.';

  @override
  String get mailQuoteDatePattern => 'EEE, d. MMM yyyy, HH:mm';

  @override
  String mailReplyIntro(String date, String sender) {
    return 'Am $date schrieb $sender:';
  }

  @override
  String get mailReplySomeone => 'jemand';

  @override
  String get mailForwardHeader =>
      '---------- Weitergeleitete Nachricht ----------';

  @override
  String mailForwardFrom(String value) {
    return 'Von: $value';
  }

  @override
  String mailForwardDate(String value) {
    return 'Datum: $value';
  }

  @override
  String mailForwardSubject(String value) {
    return 'Betreff: $value';
  }

  @override
  String mailForwardTo(String value) {
    return 'An: $value';
  }

  @override
  String mailArchivedAccountName(String timestamp) {
    return 'Archivierte Mails · $timestamp';
  }

  @override
  String get m365ConnectTitle => 'Microsoft 365 verbinden';

  @override
  String get m365ConnectIntro =>
      'courrier meldet dich über den Standard-OAuth-Ablauf deines Mandanten an. Dein Passwort wird nie über die App gesendet.';

  @override
  String get m365SigningIn => 'Anmelden …';

  @override
  String get m365SignIn => 'Mit Microsoft anmelden';

  @override
  String get m365TryAgain => 'Wiederholen';

  @override
  String get m365OpenAdminDocs => 'Admin-Doku';

  @override
  String get m365OpenAdminDocsTooltip => 'Dokumentation für Admins öffnen';

  @override
  String get m365ConsentTitle => 'Zustimmung des Admins nötig';

  @override
  String get m365ConsentBody =>
      'Deine IT-Administration muss courrier für deinen Mandanten freigeben. Teile den Link zur Dokumentation mit ihr und versuche es dann erneut.';

  @override
  String get m365BlockedTitle => 'App durch Mandantenrichtlinie blockiert';

  @override
  String get m365BlockedBody =>
      'Dein Mandant blockiert Mail-Apps von Drittanbietern. Bitte deinen Admin, courrier zuzulassen, und versuche es dann erneut.';

  @override
  String get m365ImapDisabledTitle => 'IMAP von deinem Admin deaktiviert';

  @override
  String get m365ImapDisabledBody =>
      'IMAP ist für diesen Mandanten ausgeschaltet. Dein Admin muss den IMAP-Zugriff für dein Postfach aktivieren, bevor courrier Mails synchronisieren kann.';

  @override
  String get m365SmtpDisabledTitle =>
      'SMTP AUTH für dieses Postfach deaktiviert';

  @override
  String get m365SmtpDisabledBody =>
      'Neuere Mandanten deaktivieren SMTP AUTH standardmäßig pro Postfach. Dein Admin muss SMTP AUTH für dein Postfach aktivieren, damit du Mails senden kannst.';

  @override
  String get m365FailedTitle => 'Verbindung fehlgeschlagen';

  @override
  String get m365FailedBody =>
      'courrier konnte sich nicht bei Microsoft 365 anmelden.';

  @override
  String get m365NoRefreshToken =>
      'Kein Aktualisierungstoken gespeichert – melde dich erneut an.';

  @override
  String get oauthSignInCancelled => 'Die Anmeldung wurde abgebrochen.';

  @override
  String get oauthPlatformError => 'AppAuth-Plattformfehler';

  @override
  String get oauthRefreshError => 'AppAuth-Fehler beim Aktualisieren';

  @override
  String get oauthNoAccessToken => 'AppAuth hat kein Zugriffstoken geliefert.';

  @override
  String get oauthRefreshNoAccessToken =>
      'Die AppAuth-Aktualisierung hat kein Zugriffstoken geliefert.';

  @override
  String get accountsSyncFailed =>
      'Synchronisieren fehlgeschlagen. Prüfe das Netzwerk und verbinde dich mit aktuellen Zugangsdaten neu. Gespeicherte Daten bleiben erhalten.';

  @override
  String get accountsDisconnected =>
      'Getrennt. Gespeicherte Daten bleiben auf diesem Gerät. Füge denselben Server und Benutzernamen hinzu, um dich neu zu verbinden.';

  @override
  String get accountsDisconnectFailed =>
      'Das Trennen konnte nicht abgeschlossen werden. Bitte versuche es erneut.';

  @override
  String get accountsConnectNextcloud => 'Nextcloud verbinden';

  @override
  String get accountsConnectImap => 'IMAP verbinden';

  @override
  String get accountsSyncInfo =>
      'Synchronisiert wird, wenn du auf „Aktualisieren“ tippst. Mail lädt die neuesten 100 Nachrichtenköpfe pro Ordner; öffne eine Nachricht, um ihren Inhalt zu speichern. Nextcloud Notes und News benötigen ihre Server-Apps. Der Lesestatus von News bleibt lokal. Microsoft 365 OAuth ist in diesem Build nicht aktiviert; Mandantenregistrierung und Anmeldung auf dem Gerät müssen noch geprüft werden.';

  @override
  String get accountsLoadFailed => 'Die Konten konnten nicht geladen werden.';

  @override
  String get accountsKindLocal => 'lokal';

  @override
  String accountsKindDisconnected(String kind) {
    return '$kind · getrennt';
  }

  @override
  String get accountsPreservedConflicts => 'Gesicherte Sync-Konflikte';

  @override
  String accountsOfflineCopyName(String name) {
    return 'Offline-Kopie · $name';
  }

  @override
  String get accountsRefresh => 'Aktualisieren';

  @override
  String get accountsPendingEdits => 'Offene Änderungen';

  @override
  String get accountsPendingEditsTooltip =>
      'Offene Änderungen und Wiederherstellung';

  @override
  String get accountsDisconnect => 'Trennen, Cache behalten';

  @override
  String get accountsConnectionIncomplete =>
      'Die Verbindung wurde nicht abgeschlossen.';

  @override
  String get accountsConnectFailed =>
      'Verbinden fehlgeschlagen. Prüfe die Einstellungen und versuche es erneut.';

  @override
  String get accountsManualSettings => 'Servereinstellungen manuell eingeben';

  @override
  String get accountsServerUrl => 'HTTPS-Server-URL';

  @override
  String get accountsServerUrlHelper =>
      'Gib ggf. auch den Unterordner der Installation an.';

  @override
  String get accountsImapHost => 'IMAP-Hostname';

  @override
  String get accountsUsername => 'Benutzername';

  @override
  String get accountsEmailLogin => 'E-Mail / Benutzername';

  @override
  String get accountsAppPassword => 'App-Passwort';

  @override
  String get accountsImapPort => 'IMAP-Port';

  @override
  String get accountsImapStartTls => 'IMAP STARTTLS (meist Port 143)';

  @override
  String get accountsSmtpHost => 'SMTP-Hostname (für späteren Versand)';

  @override
  String get accountsSmtpPort => 'SMTP-Port';

  @override
  String get accountsCredentialsNote =>
      'Zugangsdaten liegen im sicheren Speicher des Systems. Diese Seite prüft den Zugriff auf eingehende Mails. Senden und Synchronisieren im Hintergrund sind in der aktuellen Oberfläche nicht verfügbar.';

  @override
  String get accountsConnecting => 'Wird verbunden …';

  @override
  String get accountsConnect => 'Verbinden';

  @override
  String get accountsPendingTitle => 'Offene Änderungen';

  @override
  String get accountsPreserveTitle => 'Diese Änderung offline sichern?';

  @override
  String get accountsPreserveBody =>
      'Der aktuelle lokale Eintrag wird in eine Offline-Sammlung verschoben, auch wenn er lokal gelöscht wurde. Er wird nicht mehr hochgeladen. Der Server bleibt unverändert. Kehre zu „Konten“ zurück und tippe auf „Aktualisieren“, um die Serverversion separat zu laden. Ein Schreibvorgang, dessen Antwort verloren ging, kann dort bereits vorhanden sein.';

  @override
  String get accountsKeepOfflineCopy => 'Offline-Kopie behalten';

  @override
  String get accountsPreserveFailed =>
      'Diese Version konnte nicht gesichert werden. Es wurde nichts verworfen; aktualisiere die Liste und versuche es erneut.';

  @override
  String get accountsPendingReadFailed =>
      'Offene Änderungen konnten nicht gelesen werden.';

  @override
  String get accountsNoPendingEdits =>
      'Keine offenen Änderungen. Kehre zu „Konten“ zurück, um zu aktualisieren.';

  @override
  String get accountsPendingIntro =>
      '„Aktualisieren“ wiederholt offene Vorgänge normalerweise mit ihrer ursprünglichen Server-Vorbedingung. Lassen sie sich nicht abgleichen, sichere den lokalen Eintrag offline, bevor du die Serverdaten neu lädst.';

  @override
  String get accountsRecordNote => 'Notiz';

  @override
  String get accountsRecordTask => 'Aufgabe';

  @override
  String get accountsRecordEvent => 'Termin';

  @override
  String get accountsRecordContact => 'Kontakt';

  @override
  String get accountsRecordOther => 'Eintrag';

  @override
  String get accountsSavedEditTitle => 'Gespeicherte lokale Änderung';

  @override
  String get accountsDeletionIntent =>
      'Löschabsicht; der ursprüngliche Eintrag bleibt erhalten.';

  @override
  String get accountsReviewEdit => 'Lokale Änderung ansehen';

  @override
  String get accountsKeepOfflineReload => 'Offline sichern, Server neu laden';

  @override
  String get accountsModuleCalendar => 'Kalender';

  @override
  String get accountsModuleContacts => 'Kontakte';

  @override
  String get accountsModuleTasks => 'Aufgaben';

  @override
  String get accountsModuleNotes => 'Notizen';

  @override
  String get accountsModuleNews => 'News';

  @override
  String get accountsAddressBook => 'Adressbuch';

  @override
  String get accountsSyncLocal => 'Lokale Daten bleiben auf diesem Gerät.';

  @override
  String accountsSyncMailReport(int folders, int messages) {
    String _temp0 = intl.Intl.pluralLogic(
      folders,
      locale: localeName,
      other: '$folders Ordner',
      one: '1 Ordner',
    );
    String _temp1 = intl.Intl.pluralLogic(
      messages,
      locale: localeName,
      other: '$messages neue Nachrichtenköpfe',
      one: '1 neuer Nachrichtenkopf',
    );
    return '$_temp0 geprüft; $_temp1. Öffne eine Nachricht, um ihren Inhalt zu laden.';
  }

  @override
  String accountsSyncConflict(String label) {
    return '$label: Konflikt; lokale Änderungen bleiben erhalten';
  }

  @override
  String accountsSyncUploadFailed(String label) {
    return '$label: Hochladen nicht möglich; Änderungen bleiben erhalten';
  }

  @override
  String accountsSyncPulled(String label, int pulled, int pushed) {
    String _temp0 = intl.Intl.pluralLogic(
      pulled,
      locale: localeName,
      other: '$pulled Einträge gelesen',
      one: '1 Eintrag gelesen',
    );
    String _temp1 = intl.Intl.pluralLogic(
      pushed,
      locale: localeName,
      other: '$pushed Änderungen gesendet',
      one: '1 Änderung gesendet',
    );
    return '$label: $_temp0, $_temp1';
  }

  @override
  String accountsSyncPullFailed(String label, String detail) {
    return '$label: $detail; gespeicherte Daten bleiben erhalten';
  }

  @override
  String get accountsSyncCouldNotRefresh => 'Aktualisieren nicht möglich';

  @override
  String accountsSyncBackendFailed(String label) {
    return '$label: Aktualisieren nicht möglich; gespeicherte Daten bleiben erhalten. Prüfe die Verbindung und die Berechtigungen der Server-App.';
  }

  @override
  String get onboardingCredentialsRequired =>
      'Benutzername und App-Passwort sind erforderlich.';

  @override
  String get onboardingNoPrincipal =>
      'Es wurde kein angemeldeter DAV-Principal gefunden.';

  @override
  String onboardingNextcloudFailed(String kind) {
    return 'Nextcloud-Verbindung fehlgeschlagen ($kind).';
  }

  @override
  String get onboardingBadUrl =>
      'Ungültige URL – füge die Basis-URL deiner Nextcloud ein.';

  @override
  String get onboardingSaveFailed =>
      'Das Konto konnte nicht gespeichert werden. Prüfe den sicheren Speicher und versuche es erneut.';

  @override
  String onboardingNoAutoconfig(String domain) {
    return 'Keine automatische Konfiguration für $domain gefunden.';
  }

  @override
  String get onboardingAddManually =>
      'Füge den Server manuell unter Einstellungen → Konten hinzu.';

  @override
  String get onboardingEmailPasswordRequired =>
      'E-Mail und Passwort sind erforderlich.';

  @override
  String get onboardingUnencrypted =>
      'Unverschlüsselte Mail-Verbindungen werden nicht unterstützt.';

  @override
  String get onboardingInvalidServer => 'Ungültiger Mailserver oder Port.';

  @override
  String get onboardingSeparateSmtpUser =>
      'Eigene SMTP-Benutzernamen werden noch nicht unterstützt.';

  @override
  String get onboardingMailFailed =>
      'Mail-Verbindung fehlgeschlagen. Prüfe die Servereinstellungen und das App-Passwort.';

  @override
  String get onboardingM365Failed =>
      'Anmeldung bei Microsoft 365 fehlgeschlagen. Gespeicherte Konten bleiben unverändert.';

  @override
  String get netHttpsRequired =>
      'Verwende eine HTTPS-URL ohne eingebettete Zugangsdaten und ohne Fragment.';

  @override
  String get netBaseUrlQuery =>
      'Die Basis-URL des Servers darf keine Abfrage enthalten.';

  @override
  String get netDifferentOrigin =>
      'Der Server hat einen anderen Ursprung geliefert.';

  @override
  String get netDtdUnsupported =>
      'DTD- und Entity-Deklarationen werden nicht unterstützt.';

  @override
  String get netErrorOffline => 'offline';

  @override
  String get netErrorUnauthorized => 'nicht angemeldet';

  @override
  String get netErrorForbidden => 'Zugriff verweigert';

  @override
  String get netErrorNotFound => 'nicht gefunden';

  @override
  String get netErrorPrecondition => 'ETag stimmt nicht überein';

  @override
  String get netErrorConflict => 'Konflikt';

  @override
  String get netErrorThrottled => 'gedrosselt';

  @override
  String get netErrorServer => 'Serverfehler';

  @override
  String netErrorParse(String detail) {
    return 'Antwort nicht lesbar: $detail';
  }

  @override
  String get netErrorUnknown => 'unbekannter Netzwerkfehler';

  @override
  String get notesNew => 'Neue Notiz';

  @override
  String get notesEdit => 'Notiz bearbeiten';

  @override
  String get notesUnlockRequired =>
      'Zum Öffnen dieser Notiz musst du entsperren.';

  @override
  String get notesNoCollection =>
      'Lege zuerst unter Konten eine Notizsammlung an.';

  @override
  String get notesChooseNotebook => 'Notizbuch wählen';

  @override
  String get notesOpenFailed =>
      'Die Notiz konnte nicht geöffnet werden. Bitte versuche es erneut.';

  @override
  String get notesLoadFailed => 'Notizen konnten nicht geladen werden.';

  @override
  String get notesEmpty => 'Noch keine Notizen.';

  @override
  String get notesLockedPreview => '(gesperrt)';

  @override
  String get notesChecklistBadge => 'Checkliste';

  @override
  String get notesDiscardTitle => 'Ungespeicherte Änderungen verwerfen?';

  @override
  String get notesDiscardBody => 'Deine gespeicherte Notiz bleibt unverändert.';

  @override
  String get notesKeepEditing => 'Weiterschreiben';

  @override
  String get notesDiscard => 'Verwerfen';

  @override
  String get notesUndo => 'Rückgängig';

  @override
  String get notesRedo => 'Wiederholen';

  @override
  String get notesFavorite => 'Favorit';

  @override
  String get notesLock => 'Sperren';

  @override
  String get notesLockUnavailable => 'Richte zuerst eine App-Sperre ein';

  @override
  String get notesKindText => 'Text';

  @override
  String get notesKindChecklist => 'Checkliste';

  @override
  String get notesTitleLabel => 'Titel';

  @override
  String get notesContentLabel => 'Inhalt';

  @override
  String get notesContentHint =>
      'Schreib los – der Checklistenmodus nutzt Markdown-Aufgabenlisten.';

  @override
  String get notesSaveFailed =>
      'Die Notiz konnte nicht gespeichert werden. Dein Entwurf bleibt erhalten; versuche es erneut.';

  @override
  String get notesSaving => 'Speichern …';

  @override
  String notesHistoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Änderungen im Verlauf',
      one: '1 Änderung im Verlauf',
    );
    return '$_temp0';
  }

  @override
  String get feedsAdd => 'Feed hinzufügen';

  @override
  String get feedsAddTooltip => 'HTTPS-Feed hinzufügen';

  @override
  String get feedsRefresh => 'Aktualisieren';

  @override
  String get feedsRefreshTooltip => 'Lokale Feeds aktualisieren';

  @override
  String get feedsRefreshing => 'Wird aktualisiert …';

  @override
  String get feedsAddFailed =>
      'Der Feed konnte nicht hinzugefügt werden. Verwende eine HTTPS-URL für RSS oder Atom.';

  @override
  String get feedsRefreshPartial =>
      'Einige Feeds konnten nicht aktualisiert werden. Gespeicherte Artikel bleiben erhalten.';

  @override
  String feedsRefreshDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Artikel geprüft. Nextcloud News wird über Konten aktualisiert.',
      one: '1 Artikel geprüft. Nextcloud News wird über Konten aktualisiert.',
    );
    return '$_temp0';
  }

  @override
  String get feedsRefreshFailed =>
      'Die Feeds konnten nicht aktualisiert werden. Gespeicherte Artikel bleiben erhalten.';

  @override
  String get feedsSubscriptionsLoadFailed =>
      'Abonnements konnten nicht geladen werden.';

  @override
  String get feedsSubscriptionsEmpty => 'Noch keine Abonnements.';

  @override
  String get feedsNoArticleContent => 'Kein gespeicherter Artikelinhalt.';

  @override
  String get feedsArticleOpenFailed =>
      'Dieser Artikel konnte nicht geöffnet werden. Bitte versuche es erneut.';

  @override
  String get feedsRemoveTitle => 'Diesen lokalen Feed entfernen?';

  @override
  String get feedsRemoveBody =>
      'Das Abonnement und seine gespeicherten Artikel werden von diesem Gerät entfernt. Die Website des Feeds bleibt unverändert.';

  @override
  String get feedsRemove => 'Entfernen';

  @override
  String get feedsRemoveFailed =>
      'Der Feed konnte nicht entfernt werden. Bitte versuche es erneut.';

  @override
  String get feedsRemoveTooltip => 'Lokalen Feed entfernen';

  @override
  String get feedsArticlesLoadFailed =>
      'Gespeicherte Artikel konnten nicht geladen werden.';

  @override
  String get feedsItemsEmpty => 'Keine Artikel in diesem Feed.';

  @override
  String get feedsAddTitle => 'Feed hinzufügen';

  @override
  String get feedsUrlLabel => 'HTTPS-URL (RSS oder Atom)';

  @override
  String get feedsAddConfirm => 'Hinzufügen';

  @override
  String syncConflictTitle(String table) {
    return 'Sync-Konflikt – $table';
  }

  @override
  String get syncConflictBody =>
      'Der Server hat eine neuere Version als die lokale Kopie.';

  @override
  String get syncConflictLocal => 'Lokal';

  @override
  String get syncConflictServer => 'Server';

  @override
  String get syncConflictKeepServer => 'Server behalten';

  @override
  String get syncConflictKeepBoth => 'Beide behalten';

  @override
  String get syncConflictKeepLocal => 'Lokal behalten';

  @override
  String whatsNewTitle(String version) {
    return 'Neu in $version';
  }

  @override
  String get whatsNewGotIt => 'Verstanden';

  @override
  String get modulePlaceholderNote =>
      'In M0 bewusst leer. Das Modul wird in seinem Meilenstein angebunden.';

  @override
  String get appLockTitle => 'courrier entsperren';

  @override
  String get appLockReason => 'courrier entsperren';

  @override
  String get appLockLoading => 'Sicherheitseinstellungen werden geladen …';

  @override
  String get appLockSettingsFailed =>
      'Die Einstellungen der App-Sperre konnten nicht gelesen werden. Versuche es erneut, um fortzufahren.';

  @override
  String get appLockAuthFailed =>
      'Die Authentifizierung wurde abgebrochen oder ist nicht verfügbar. Bitte versuche es erneut.';

  @override
  String get appLockAuthenticating => 'Authentifizierung …';

  @override
  String get appLockUnlock => 'Entsperren';

  @override
  String get calendarAgenda => 'Agenda';

  @override
  String get calendarMonth => 'Monat';

  @override
  String get calendarNoTitle => '(ohne Titel)';

  @override
  String get calendarNoEvents => 'Keine Termine in diesem Zeitraum.';

  @override
  String get calendarDeleteRecurringTitle => 'Serientermin löschen';

  @override
  String get calendarDeleteThisOccurrence => 'Nur diesen Termin';

  @override
  String get calendarDeleteThisAndFollowing => 'Ab diesem Termin';

  @override
  String get calendarDeleteAllOccurrences => 'Alle Termine der Serie';

  @override
  String get calendarEventTitle => 'Titel';

  @override
  String get calendarEventStarts => 'Beginn';

  @override
  String get calendarEventEnds => 'Ende';

  @override
  String get calendarEventAllDay => 'Ganztägig';

  @override
  String get calendarEventLocation => 'Ort';

  @override
  String get calendarEventDescription => 'Beschreibung';

  @override
  String get calendarEventRecurrence => 'Wiederholung (RRULE)';

  @override
  String get calendarEventOrganizer => 'Organisator';

  @override
  String get calendarEventAttendees => 'Teilnehmer (einer pro Zeile)';

  @override
  String get calendarEventReminders => 'Erinnerungen';

  @override
  String get calendarAddReminder => 'Hinzufügen';

  @override
  String get calendarAddReminderTooltip => 'Erinnerung hinzufügen';

  @override
  String calendarReminderMinutesBefore(int minutes) {
    return '$minutes Min. vorher';
  }

  @override
  String get calendarReminderAtTime => 'Zu einem bestimmten Zeitpunkt';

  @override
  String get calendarRemoveReminder => 'Erinnerung entfernen';

  @override
  String get contactsBackToList => 'Zurück zur Kontaktliste';

  @override
  String get contactsNoName => '(ohne Namen)';

  @override
  String get contactsEmail => 'E-Mail';

  @override
  String get contactsPhone => 'Telefon';

  @override
  String get contactsAddress => 'Adresse';

  @override
  String get contactsDisplayName => 'Anzeigename';

  @override
  String get contactsGivenName => 'Vorname';

  @override
  String get contactsFamilyName => 'Nachname';

  @override
  String get contactsOrganisation => 'Organisation';

  @override
  String get contactsEmails => 'E-Mail-Adressen (eine pro Zeile)';

  @override
  String get contactsPhones => 'Telefonnummern (eine pro Zeile)';

  @override
  String get contactsNote => 'Notiz';

  @override
  String get contactsGroups => 'Gruppen';

  @override
  String get contactsEmpty => 'Noch keine Kontakte.';

  @override
  String get tasksLoadFailedRetry => 'Laden fehlgeschlagen. Erneut versuchen';

  @override
  String get tasksCompleteFailed =>
      'Die Aufgabe konnte nicht als erledigt markiert werden. Deine gespeicherte Aufgabe bleibt erhalten.';

  @override
  String get tasksNoSummary => '(ohne Titel)';

  @override
  String get tasksEmpty => 'Noch keine Aufgaben.';

  @override
  String get remindersUpcoming => 'Anstehende Erinnerungen';

  @override
  String get remindersReload => 'Neu laden';

  @override
  String remindersScheduleLimit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Benachrichtigungen decken die nächsten $count Erinnerungen ab. Öffne courrier regelmäßig, damit auch spätere eingeplant werden.',
      one:
          'Benachrichtigungen decken die nächste Erinnerung ab. Öffne courrier regelmäßig, damit auch spätere eingeplant werden.',
    );
    return '$_temp0';
  }

  @override
  String get remindersNothingScheduled => 'Nichts geplant.';

  @override
  String get remindersPermissionTitle =>
      'Berechtigung für Benachrichtigungen nötig';

  @override
  String get remindersPermissionBody =>
      'courrier braucht deine Erlaubnis, um Erinnerungen für Termine und Aufgaben zu senden.';

  @override
  String get remindersAllowNotifications => 'Benachrichtigungen erlauben';

  @override
  String get remindersUnavailableTitle =>
      'Benachrichtigungen für Erinnerungen nicht verfügbar';

  @override
  String get remindersWeekly => 'wöchentlich';

  @override
  String get remindersLoadFailed =>
      'Erinnerungen konnten nicht geladen werden. Versuche es mit „Neu laden“.';

  @override
  String get remindersEnableFailed =>
      'Erinnerungen konnten nicht aktiviert werden. Prüfe die Berechtigung für Benachrichtigungen.';

  @override
  String get remindersReloadFailed =>
      'Neu laden fehlgeschlagen. Vorhandene Erinnerungen bleiben nach Möglichkeit erhalten.';

  @override
  String get remindersRefreshFailed =>
      'Erinnerungen konnten nicht aktualisiert werden. Öffne „Erinnerungen“ und wähle „Neu laden“.';

  @override
  String get remindersNotificationFallback => 'Erinnerung';

  @override
  String get remindersTaskDueTitle => 'Aufgabe fällig';

  @override
  String get remindersTaskDueBody => 'Die Aufgabe ist jetzt fällig.';

  @override
  String get remindersChannelName => 'Erinnerungen';

  @override
  String get remindersChannelDescription =>
      'Terminerinnerungen und fällige Aufgaben aus courrier.';

  @override
  String get intervalMinutes => 'Min';

  @override
  String get intervalHours => 'Std';

  @override
  String get intervalDays => 'Tag';

  @override
  String get intervalMinutesTooltip => 'Minuten';

  @override
  String get intervalHoursTooltip => 'Stunden';

  @override
  String get intervalDaysTooltip => 'Tage';

  @override
  String get searchNoSubject => '(kein Betreff)';

  @override
  String get searchLocked => '(gesperrt)';

  @override
  String get rruleCustom => 'Benutzerdefinierte Wiederholung';

  @override
  String rruleDaily(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Tage',
      one: 'Täglich',
    );
    return '$_temp0';
  }

  @override
  String rruleWeekly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Wochen',
      one: 'Wöchentlich',
    );
    return '$_temp0';
  }

  @override
  String rruleMonthly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Monate',
      one: 'Monatlich',
    );
    return '$_temp0';
  }

  @override
  String rruleYearly(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Alle $count Jahre',
      one: 'Jährlich',
    );
    return '$_temp0';
  }

  @override
  String rruleOnWeekdays(String days) {
    return 'am $days';
  }

  @override
  String rruleOnMonthDays(String days) {
    return 'am $days';
  }

  @override
  String rruleInMonths(String months) {
    return 'im $months';
  }

  @override
  String rruleOnMonthDaysInMonths(String days, String months) {
    return 'am $days $months';
  }

  @override
  String rruleWithCount(String rule, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-mal',
      one: 'einmal',
    );
    return '$rule, $_temp0';
  }

  @override
  String rruleWithUntil(String rule, String date) {
    return '$rule, bis $date';
  }

  @override
  String rruleOrdinal(int n, String category) {
    return '$n.';
  }

  @override
  String rruleOrdinalFromLast(String ordinal, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$ordinal-letzten Tag',
      two: 'vorletzten Tag',
      one: 'letzten Tag',
    );
    return '$_temp0';
  }

  @override
  String rruleWeekdayNth(String ordinal, String day) {
    return '$ordinal $day';
  }

  @override
  String rruleWeekdayLast(String day) {
    return 'letzten $day';
  }

  @override
  String rruleWeekdayNthFromLast(String ordinal, int n, String day) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$ordinal-letzten $day',
      two: 'vorletzten $day',
    );
    return '$_temp0';
  }

  @override
  String rruleListPair(String first, String second) {
    return '$first und $second';
  }

  @override
  String rruleListSeries(String head, String last) {
    return '$head und $last';
  }

  @override
  String rruleDayFallback(int day) {
    return 'Tag $day';
  }
}
