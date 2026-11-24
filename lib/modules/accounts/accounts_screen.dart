import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';

import '../../core/auth/oauth_token_store.dart';
import '../../core/config/secrets_store.dart';
import '../../core/db/database.dart';
import '../../core/sync/account_services.dart';
import '../../core/sync/conflict_recovery.dart';
import '../../l10n/l10n.dart';
import '../mail/autoconfig/autoconfig_models.dart';
import '../onboarding/onboarding_controller.dart';
import '../onboarding/onboarding_state.dart';
import 'pending_edits_screen.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({
    required this.db,
    required this.services,
    required this.secrets,
    super.key,
  });
  final CourrierDatabase db;
  final AccountServices services;
  final SecretsStore secrets;
  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  late final _accounts = widget.db.select(widget.db.accounts).watch();
  final _busy = <int>{};
  final _reports = <int, String>{};
  Future<void> _sync(Account account) async {
    setState(() => _busy.add(account.id));
    try {
      final report = await widget.services.sync(account);
      if (mounted) setState(() => _reports[account.id] = report);
    } catch (_) {
      if (mounted) {
        setState(() => _reports[account.id] = context.l10n.accountsSyncFailed);
      }
    } finally {
      if (mounted) setState(() => _busy.remove(account.id));
    }
  }

  Future<void> _configure(String kind) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            _AccountForm(db: widget.db, secrets: widget.secrets, kind: kind),
      ),
    );
  }

  Future<void> _disconnect(Account account) async {
    try {
      await (widget.db.update(widget.db.accounts)
            ..where((t) => t.id.equals(account.id)))
          .write(const AccountsCompanion(enabled: Value(false)));
      await widget.secrets.deleteAccount(account.id);
      if (mounted) {
        setState(
          () => _reports[account.id] = context.l10n.accountsDisconnected,
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _reports[account.id] = context.l10n.accountsDisconnectFailed,
        );
      }
    }
  }

  /// The stored names of app-created local accounts are English lookup keys.
  String _displayName(Account account, AppLocalizations l10n) =>
      account.kind == 'local' &&
          account.displayName == preservedConflictsAccountName
      ? l10n.accountsPreservedConflicts
      : account.displayName;

  String _kindLabel(Account account, AppLocalizations l10n) {
    final kind = account.kind == 'local'
        ? l10n.accountsKindLocal
        : account.kind;
    return account.enabled ? kind : l10n.accountsKindDisconnected(kind);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.shellAccounts)),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            FilledButton.icon(
              onPressed: () => _configure('nextcloud'),
              icon: const Icon(Icons.cloud_outlined),
              label: Text(context.l10n.accountsConnectNextcloud),
            ),
            FilledButton.tonalIcon(
              onPressed: () => _configure('imap'),
              icon: const Icon(Icons.mail_outline),
              label: Text(context.l10n.accountsConnectImap),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(context.l10n.accountsSyncInfo),
        ),
        StreamBuilder<List<Account>>(
          stream: _accounts,
          builder: (context, snapshot) {
            final l10n = context.l10n;
            if (snapshot.hasError) {
              return Text(l10n.accountsLoadFailed);
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                for (final account in snapshot.data!)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayName(account, l10n),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(_kindLabel(account, l10n)),
                          if (_reports[account.id] case final String report)
                            SelectableText(report),
                          if (account.kind != 'local')
                            Wrap(
                              spacing: 8,
                              children: [
                                TextButton.icon(
                                  onPressed:
                                      _busy.contains(account.id) ||
                                          !account.enabled
                                      ? null
                                      : () => _sync(account),
                                  icon: _busy.contains(account.id)
                                      ? const SizedBox.square(
                                          dimension: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.refresh),
                                  label: Text(l10n.accountsRefresh),
                                ),
                                Tooltip(
                                  message: l10n.accountsPendingEditsTooltip,
                                  child: TextButton(
                                    onPressed: _busy.contains(account.id)
                                        ? null
                                        : () => Navigator.of(context).push(
                                            MaterialPageRoute<void>(
                                              builder: (_) =>
                                                  PendingEditsScreen(
                                                    db: widget.db,
                                                    accountId: account.id,
                                                  ),
                                            ),
                                          ),
                                    child: Text(l10n.accountsPendingEdits),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _busy.contains(account.id)
                                      ? null
                                      : () => _disconnect(account),
                                  child: Text(l10n.accountsDisconnect),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    ),
  );
}

class _AccountForm extends StatefulWidget {
  const _AccountForm({
    required this.db,
    required this.secrets,
    required this.kind,
  });
  final CourrierDatabase db;
  final SecretsStore secrets;
  final String kind;
  @override
  State<_AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<_AccountForm> {
  final _server = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _port = TextEditingController(text: '993');
  final _smtp = TextEditingController();
  final _smtpPort = TextEditingController(text: '587');
  bool _manual = false, _busy = false, _startTls = false;
  String? _message;
  late final _controller = OnboardingController(
    db: widget.db,
    secrets: widget.secrets,
    tokenStore: OAuthTokenStore(secrets: widget.secrets),
  );
  @override
  void dispose() {
    for (final c in [_server, _username, _password, _port, _smtp, _smtpPort]) {
      c.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final StepOutcome outcome;
      if (widget.kind == 'nextcloud') {
        outcome = await _controller.connectNextcloud(
          baseUrl: _server.text,
          username: _username.text.trim(),
          appPassword: _password.text,
        );
      } else {
        ResolvedMailConfig? manual;
        if (_manual) {
          manual = ResolvedMailConfig(
            source: 'manual',
            incoming: MailServerConfig(
              protocol: MailServerProtocol.imap,
              host: _server.text.trim(),
              port: int.tryParse(_port.text) ?? 0,
              socketType: _startTls
                  ? MailSocketType.starttls
                  : MailSocketType.ssl,
              usernameTemplate: _username.text.trim(),
              authMechanism: 'password-cleartext',
            ),
            outgoing: MailServerConfig(
              protocol: MailServerProtocol.smtp,
              host: _smtp.text.trim(),
              port: int.tryParse(_smtpPort.text) ?? 0,
              socketType: _smtpPort.text == '465'
                  ? MailSocketType.ssl
                  : MailSocketType.starttls,
              usernameTemplate: _username.text.trim(),
              authMechanism: 'password-cleartext',
            ),
          );
        }
        outcome = await _controller.connectImap(
          emailAddress: _username.text.trim(),
          password: _password.text,
          manualConfig: manual,
        );
      }
      if (!mounted) return;
      if (outcome is StepSucceeded) {
        Navigator.of(context).pop();
        return;
      }
      setState(
        () => _message = outcome is StepFailed
            ? [outcome.message, outcome.detail].whereType<String>().join('\n')
            : context.l10n.accountsConnectionIncomplete,
      );
    } catch (_) {
      if (mounted) {
        setState(() => _message = context.l10n.accountsConnectFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _field(
    TextEditingController c,
    String label, {
    bool secret = false,
    String? helper,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: TextField(
      controller: c,
      enabled: !_busy,
      obscureText: secret,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: label,
        helperText: helper,
        helperMaxLines: 2,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.kind == 'nextcloud'
                ? l10n.accountsConnectNextcloud
                : l10n.accountsConnectImap,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (widget.kind == 'imap')
              SwitchListTile(
                title: Text(l10n.accountsManualSettings),
                value: _manual,
                onChanged: _busy ? null : (v) => setState(() => _manual = v),
              ),
            if (widget.kind == 'nextcloud' || _manual)
              _field(
                _server,
                widget.kind == 'nextcloud'
                    ? l10n.accountsServerUrl
                    : l10n.accountsImapHost,
                helper: widget.kind == 'nextcloud'
                    ? l10n.accountsServerUrlHelper
                    : null,
              ),
            _field(
              _username,
              widget.kind == 'nextcloud'
                  ? l10n.accountsUsername
                  : l10n.accountsEmailLogin,
            ),
            _field(_password, l10n.accountsAppPassword, secret: true),
            if (_manual && widget.kind == 'imap') ...[
              _field(_port, l10n.accountsImapPort),
              SwitchListTile(
                title: Text(l10n.accountsImapStartTls),
                value: _startTls,
                onChanged: _busy
                    ? null
                    : (v) => setState(() {
                        _startTls = v;
                        _port.text = v ? '143' : '993';
                      }),
              ),
              _field(_smtp, l10n.accountsSmtpHost),
              _field(_smtpPort, l10n.accountsSmtpPort),
            ],
            Text(l10n.accountsCredentialsNote),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(_message!),
              ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _connect,
              child: Text(
                _busy ? l10n.accountsConnecting : l10n.accountsConnect,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
