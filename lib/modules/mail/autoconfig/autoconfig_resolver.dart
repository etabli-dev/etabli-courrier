import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../../../core/net/net_error.dart';
import 'autoconfig_models.dart';

// Resolver that follows the Mozilla autoconfig waterfall:
//
//   1. ISPDB                — https://autoconfig.thunderbird.net/v1.1/{domain}
//   2. .well-known/autoconfig — https://autoconfig.{domain}/mail/config-v1.1.xml
//                            and https://{domain}/.well-known/autoconfig/mail/config-v1.1.xml
//   3. DNS SRV               — _imaps._tcp.{domain} + _submission._tcp.{domain}
//
// Each step returns null when it doesn't find a match (or surface a NetError
// for hard failures); the next step runs. Tests inject a fake HTTP client
// and a fake SRV resolver via the constructor.

typedef SrvResolver = Future<List<SrvLookupResult>> Function(String name);

class AutoconfigResolver {
  AutoconfigResolver({http.Client? httpClient, SrvResolver? srvResolver})
    : _http = httpClient ?? http.Client(),
      _srv = srvResolver ?? _emptySrv;

  final http.Client _http;
  final SrvResolver _srv;

  Future<ResolvedMailConfig?> resolve(String emailAddress) async {
    final domain = emailAddress.split('@').last.toLowerCase().trim();
    if (domain.isEmpty) {
      throw const ParseFailureError('email is missing the domain');
    }

    final ispdb = await _tryIspdb(domain);
    if (ispdb != null) {
      return ispdb;
    }
    final wellKnown = await _tryWellKnown(domain);
    if (wellKnown != null) {
      return wellKnown;
    }
    return _trySrv(domain);
  }

  Future<ResolvedMailConfig?> _tryIspdb(String domain) async {
    final url = Uri.parse('https://autoconfig.thunderbird.net/v1.1/$domain');
    return _attemptXml(url, source: 'ispdb');
  }

  Future<ResolvedMailConfig?> _tryWellKnown(String domain) async {
    final candidates = [
      Uri.parse('https://autoconfig.$domain/mail/config-v1.1.xml'),
      Uri.parse('https://$domain/.well-known/autoconfig/mail/config-v1.1.xml'),
    ];
    for (final url in candidates) {
      final result = await _attemptXml(url, source: 'well-known');
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  Future<ResolvedMailConfig?> _trySrv(String domain) async {
    final imaps = await _srv('_imaps._tcp.$domain');
    final submission = await _srv('_submission._tcp.$domain');
    if (imaps.isEmpty || submission.isEmpty) {
      return null;
    }
    final sortedImaps = List<SrvLookupResult>.of(imaps)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    final sortedSubmissions = List<SrvLookupResult>.of(submission)
      ..sort((a, b) => a.priority.compareTo(b.priority));
    final imap = sortedImaps.first;
    final smtp = sortedSubmissions.first;
    return ResolvedMailConfig(
      source: 'srv',
      incoming: MailServerConfig(
        protocol: MailServerProtocol.imap,
        host: imap.target,
        port: imap.port,
        socketType: imap.port == 993
            ? MailSocketType.ssl
            : MailSocketType.starttls,
        usernameTemplate: '%EMAILADDRESS%',
        authMechanism: 'password-cleartext',
      ),
      outgoing: MailServerConfig(
        protocol: MailServerProtocol.smtp,
        host: smtp.target,
        port: smtp.port,
        socketType: smtp.port == 465
            ? MailSocketType.ssl
            : MailSocketType.starttls,
        usernameTemplate: '%EMAILADDRESS%',
        authMechanism: 'password-cleartext',
      ),
    );
  }

  Future<ResolvedMailConfig?> _attemptXml(
    Uri url, {
    required String source,
  }) async {
    try {
      final response = await _http.get(url);
      if (response.statusCode != 200) {
        return null;
      }
      return _parseClientConfig(response.body, source: source);
    } on Exception {
      return null;
    }
  }

  /// Parse Mozilla `clientConfig` XML. Visible for tests.
  ResolvedMailConfig parseClientConfig(String xml, {required String source}) {
    final parsed = _parseClientConfig(xml, source: source);
    if (parsed == null) {
      throw const ParseFailureError('clientConfig missing incoming/outgoing');
    }
    return parsed;
  }

  ResolvedMailConfig? _parseClientConfig(String xml, {required String source}) {
    final XmlDocument document;
    try {
      document = XmlDocument.parse(xml);
    } on XmlException {
      return null;
    }
    final clientConfig = document.findAllElements('emailProvider').firstOrNull;
    if (clientConfig == null) {
      return null;
    }
    final incoming = _firstSupported(
      clientConfig.findElements('incomingServer'),
      protocols: const {'imap'},
    );
    final outgoing = _firstSupported(
      clientConfig.findElements('outgoingServer'),
      protocols: const {'smtp'},
    );
    if (incoming == null || outgoing == null) {
      return null;
    }
    return ResolvedMailConfig(
      source: source,
      incoming: _toServerConfig(incoming, MailServerProtocol.imap),
      outgoing: _toServerConfig(outgoing, MailServerProtocol.smtp),
    );
  }

  XmlElement? _firstSupported(
    Iterable<XmlElement> candidates, {
    required Set<String> protocols,
  }) {
    for (final element in candidates) {
      final type = element.getAttribute('type');
      if (type != null && protocols.contains(type.toLowerCase())) {
        return element;
      }
    }
    return null;
  }

  MailServerConfig _toServerConfig(
    XmlElement element,
    MailServerProtocol protocol,
  ) {
    final hostname =
        element.findElements('hostname').firstOrNull?.innerText ?? '';
    final port =
        int.tryParse(
          element.findElements('port').firstOrNull?.innerText ?? '',
        ) ??
        0;
    final socketType =
        element.findElements('socketType').firstOrNull?.innerText ?? 'SSL';
    final username =
        element.findElements('username').firstOrNull?.innerText ??
        '%EMAILADDRESS%';
    final authentication =
        element.findElements('authentication').firstOrNull?.innerText ??
        'password-cleartext';
    return MailServerConfig(
      protocol: protocol,
      host: hostname,
      port: port,
      socketType: _socketTypeFromString(socketType),
      usernameTemplate: username,
      authMechanism: authentication,
    );
  }

  MailSocketType _socketTypeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'ssl':
        return MailSocketType.ssl;
      case 'starttls':
        return MailSocketType.starttls;
      case 'plain':
        return MailSocketType.plain;
      default:
        return MailSocketType.ssl;
    }
  }
}

Future<List<SrvLookupResult>> _emptySrv(String _) async =>
    const <SrvLookupResult>[];
