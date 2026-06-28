import 'package:flutter/material.dart';

import '../../../../../core/theme/tokens.dart';
import '../m365_backend.dart';
import '../tenant_state.dart';
import 'tenant_error_card.dart';

class ConnectMicrosoftScreen extends StatefulWidget {
  const ConnectMicrosoftScreen({
    required this.backend,
    this.onConnected,
    this.onOpenAdminDocs,
    super.key,
  });

  final M365Backend backend;
  final VoidCallback? onConnected;
  final VoidCallback? onOpenAdminDocs;

  @override
  State<ConnectMicrosoftScreen> createState() => _ConnectMicrosoftScreenState();
}

class _ConnectMicrosoftScreenState extends State<ConnectMicrosoftScreen> {
  TenantState _state = const TenantConnected();
  bool _busy = false;
  bool _attempted = false;

  Future<void> _connect() async {
    if (_busy) {
      return;
    }
    setState(() {
      _busy = true;
      _attempted = true;
    });
    try {
      final next = await widget.backend.signInAndConnect();
      if (!mounted) {
        return;
      }
      setState(() => _state = next);
      if (next is TenantConnected) {
        widget.onConnected?.call();
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(CourrierTokens.space5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Connect Microsoft 365', style: theme.textTheme.titleLarge),
          const SizedBox(height: CourrierTokens.space2),
          Text(
            'courrier signs in via your tenant\'s standard OAuth flow. '
            'Your password is never sent through the app.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: CourrierTokens.space5),
          FilledButton(
            onPressed: _busy ? null : _connect,
            child: Text(_busy ? 'Signing in…' : 'Sign in with Microsoft'),
          ),
          if (_attempted && _state is! TenantConnected) ...[
            const SizedBox(height: CourrierTokens.space5),
            TenantErrorCard(
              state: _state,
              onRetry: _connect,
              onOpenAdminDocs: widget.onOpenAdminDocs,
            ),
          ],
        ],
      ),
    );
  }
}
