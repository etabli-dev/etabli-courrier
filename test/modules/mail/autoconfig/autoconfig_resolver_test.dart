import 'dart:io';

import 'package:courrier/modules/mail/autoconfig/autoconfig_models.dart';
import 'package:courrier/modules/mail/autoconfig/autoconfig_resolver.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

String _load(String name) =>
    File('test/fixtures/autoconfig/$name').readAsStringSync();

void main() {
  group('AutoconfigResolver — clientConfig parsing', () {
    test('Parses Mozilla example clientConfig XML', () {
      final resolver = AutoconfigResolver();
      final result = resolver.parseClientConfig(
        _load('example_org_clientconfig.xml'),
        source: 'fixture',
      );
      expect(result.incoming.host, 'imap.example.org');
      expect(result.incoming.port, 993);
      expect(result.incoming.socketType, MailSocketType.ssl);
      expect(result.outgoing.host, 'smtp.example.org');
      expect(result.outgoing.port, 587);
      expect(result.outgoing.socketType, MailSocketType.starttls);
      expect(
        result.incoming.resolveUsername('user@example.org'),
        'user@example.org',
      );
    });
  });

  group('AutoconfigResolver — waterfall', () {
    test('ISPDB hit short-circuits the waterfall', () async {
      final hits = <Uri>[];
      final fixture = _load('example_org_clientconfig.xml');
      final mock = MockClient((http.Request req) async {
        hits.add(req.url);
        if (req.url.host.contains('autoconfig.thunderbird.net')) {
          return http.Response(fixture, 200);
        }
        return http.Response('', 404);
      });
      final resolver = AutoconfigResolver(httpClient: mock);
      final result = await resolver.resolve('user@example.org');
      expect(result, isNotNull);
      expect(result!.source, 'ispdb');
      expect(
        hits,
        hasLength(1),
        reason: 'ISPDB hit must short-circuit subsequent steps',
      );
    });

    test('.well-known fallback after ISPDB 404', () async {
      final fixture = _load('example_org_clientconfig.xml');
      final mock = MockClient((http.Request req) async {
        if (req.url.host.contains('autoconfig.thunderbird.net')) {
          return http.Response('', 404);
        }
        if (req.url.host == 'autoconfig.example.org') {
          return http.Response(fixture, 200);
        }
        return http.Response('', 404);
      });
      final resolver = AutoconfigResolver(httpClient: mock);
      final result = await resolver.resolve('user@example.org');
      expect(result, isNotNull);
      expect(result!.source, 'well-known');
    });

    test('DNS SRV fallback when HTTP autoconfig is absent', () async {
      final mock = MockClient((http.Request _) async {
        return http.Response('', 404);
      });
      final resolver = AutoconfigResolver(
        httpClient: mock,
        srvResolver: (name) async {
          if (name.startsWith('_imaps')) {
            return const [
              SrvLookupResult(
                priority: 10,
                weight: 5,
                port: 993,
                target: 'imap.fallback.example',
              ),
            ];
          }
          if (name.startsWith('_submission')) {
            return const [
              SrvLookupResult(
                priority: 10,
                weight: 5,
                port: 465,
                target: 'smtp.fallback.example',
              ),
            ];
          }
          return const <SrvLookupResult>[];
        },
      );
      final result = await resolver.resolve('user@example.org');
      expect(result, isNotNull);
      expect(result!.source, 'srv');
      expect(result.incoming.host, 'imap.fallback.example');
      expect(result.outgoing.port, 465);
      expect(result.outgoing.socketType, MailSocketType.ssl);
    });

    test('Returns null when no source matches', () async {
      final mock = MockClient((http.Request _) async {
        return http.Response('', 404);
      });
      final resolver = AutoconfigResolver(httpClient: mock);
      final result = await resolver.resolve('user@unknown.example');
      expect(result, isNull);
    });
  });
}
