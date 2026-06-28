import 'dart:io';

import 'package:courrier/core/bootstrap/sample_content_installer.dart';
import 'package:courrier/core/db/database.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory AssetBundle that serves the bundled ICS asset from the repo's
/// `assets/sample/` directory so the test runs without a Flutter binding.
class _RepoAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final file = File(key);
    if (!file.existsSync()) {
      throw FlutterError('Asset $key not found in repo');
    }
    final bytes = await file.readAsBytes();
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}

CourrierDatabase _db() => CourrierDatabase.forTesting(NativeDatabase.memory());

void main() {
  group('SampleContentInstaller', () {
    test('seeds local account + holidays + welcome notes + sample feed on '
        'a fresh database', () async {
      final db = _db();
      addTearDown(db.close);
      final installer = SampleContentInstaller(bundle: _RepoAssetBundle());

      final didInstall = await installer.installIfMissing(db);
      expect(didInstall, isTrue);

      final accounts = await db.select(db.accounts).get();
      expect(accounts, hasLength(1));
      expect(accounts.single.kind, 'local');

      final collections = await db.select(db.collections).get();
      expect(
        collections.map((c) => c.kind).toSet(),
        containsAll(['calendar', 'notes']),
      );

      final events = await db.select(db.calendarEvents).get();
      expect(
        events,
        hasLength(5),
        reason: 'bundled holidays_2026.ics carries 5 events',
      );
      expect(events.map((e) => e.summary), contains("New Year's Day"));
      expect(events.map((e) => e.summary), contains('Winter solstice'));
      for (final event in events) {
        expect(event.allDay, isTrue);
      }

      final notes = await db.select(db.noteItems).get();
      expect(notes, hasLength(2));
      expect(notes.map((n) => n.title), contains('Getting started'));
      expect(notes.map((n) => n.title), contains('Checklist demo'));

      final feeds = await db.select(db.feedSubscriptions).get();
      expect(feeds, hasLength(1));
      expect(feeds.single.title, 'courrier release notes');
    });

    test(
      'installIfMissing is a no-op when any account already exists',
      () async {
        final db = _db();
        addTearDown(db.close);
        // Seed a real-looking account so the installer should refuse.
        await db
            .into(db.accounts)
            .insert(
              AccountsCompanion.insert(kind: 'nextcloud', displayName: 'real'),
            );
        final installer = SampleContentInstaller(bundle: _RepoAssetBundle());

        final didInstall = await installer.installIfMissing(db);
        expect(didInstall, isFalse);

        final accounts = await db.select(db.accounts).get();
        expect(
          accounts,
          hasLength(1),
          reason: 'no additional sample account inserted',
        );
        final events = await db.select(db.calendarEvents).get();
        expect(
          events,
          isEmpty,
          reason: 'no holidays imported when an account is already present',
        );
      },
    );
  });
}
