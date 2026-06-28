import 'package:meta/meta.dart';

// Resolved mail server configuration. Surfaced by AutoconfigResolver after
// trying Mozilla ISPDB → ISP-hosted .well-known → DNS SRV.

enum MailServerProtocol { imap, smtp }

enum MailSocketType { ssl, starttls, plain }

@immutable
class MailServerConfig {
  const MailServerConfig({
    required this.protocol,
    required this.host,
    required this.port,
    required this.socketType,
    required this.usernameTemplate,
    required this.authMechanism,
  });

  final MailServerProtocol protocol;
  final String host;
  final int port;
  final MailSocketType socketType;

  /// `%EMAILADDRESS%` or `%EMAILLOCALPART%` — the values Mozilla ISPDB uses.
  final String usernameTemplate;

  /// `password-cleartext` | `password-encrypted` | `OAuth2` | `XOAUTH2` etc.
  final String authMechanism;

  String resolveUsername(String emailAddress) {
    final localPart = emailAddress.split('@').first;
    return usernameTemplate
        .replaceAll('%EMAILADDRESS%', emailAddress)
        .replaceAll('%EMAILLOCALPART%', localPart);
  }
}

@immutable
class ResolvedMailConfig {
  const ResolvedMailConfig({
    required this.source,
    required this.incoming,
    required this.outgoing,
  });

  /// 'ispdb' | 'well-known' | 'srv'
  final String source;
  final MailServerConfig incoming;
  final MailServerConfig outgoing;
}

@immutable
class SrvLookupResult {
  const SrvLookupResult({
    required this.priority,
    required this.weight,
    required this.port,
    required this.target,
  });
  final int priority;
  final int weight;
  final int port;
  final String target;
}
