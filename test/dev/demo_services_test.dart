import 'package:courrier/dev/demo_services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'DemoServices.bootInMemory wires every module without exceptions',
    () async {
      final services = await DemoServices.bootInMemory();
      addTearDown(services.db.close);

      expect(
        await services.calendar.eventsBetween(
          from: DateTime.now().subtract(const Duration(days: 30)),
          to: DateTime.now().add(const Duration(days: 30)),
        ),
        isNotEmpty,
      );
      expect(await services.contacts.listContacts(), isNotEmpty);
      expect(await services.tasks.listTasks(), isNotEmpty);
      expect(await services.notes.listNotes(), isNotEmpty);
      expect(await services.mail.threadsIn('INBOX'), isNotEmpty);
      expect(await services.feeds.listSubscriptions(), isNotEmpty);
    },
  );
}
