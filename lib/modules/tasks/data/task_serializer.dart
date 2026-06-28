import '../../../core/ical/ical_component.dart';
import '../../../core/ical/ical_property.dart';
import '../../../core/ical/ical_writer.dart';
import 'task_draft.dart';

class TaskSerializer {
  const TaskSerializer({this.prodId = '-//Etabli//courrier 0.1.0//EN'});

  final String prodId;

  static const IcalWriter _writer = IcalWriter();

  String render(TaskDraft draft, {required String uid}) {
    final vcal = IcalComponent('VCALENDAR')
      ..properties.addAll([
        IcalProperty(name: 'VERSION', value: '2.0'),
        IcalProperty(name: 'PRODID', value: prodId),
      ]);

    final vtodo = IcalComponent('VTODO')
      ..properties.addAll([
        IcalProperty(name: 'UID', value: uid),
        IcalProperty(
          name: 'DTSTAMP',
          value: _formatUtc(DateTime.now().toUtc()),
        ),
        IcalProperty(name: 'SUMMARY', value: draft.summary),
        if (draft.description != null)
          IcalProperty(name: 'DESCRIPTION', value: draft.description!),
        if (draft.due != null)
          IcalProperty(name: 'DUE', value: _formatUtc(draft.due!.toUtc())),
        if (draft.priority != null)
          IcalProperty(name: 'PRIORITY', value: '${draft.priority}'),
        if (draft.percentComplete != null)
          IcalProperty(
            name: 'PERCENT-COMPLETE',
            value: '${draft.percentComplete}',
          ),
        if (draft.rrule != null)
          IcalProperty(name: 'RRULE', value: draft.rrule!),
        if (draft.repeatAfterCompletion)
          IcalProperty(name: 'X-TASKS-ORG-REPEAT-COMPLETED', value: 'true'),
        if (draft.parentUid != null)
          IcalProperty(
            name: 'RELATED-TO',
            parameters: const {
              'RELTYPE': ['PARENT'],
            },
            value: draft.parentUid!,
          ),
      ]);

    vcal.children.add(vtodo);
    return _writer.render(vcal);
  }

  String _formatUtc(DateTime dt) {
    final yyyy = dt.year.toString().padLeft(4, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    final ss = dt.second.toString().padLeft(2, '0');
    return '$yyyy$mm${dd}T$hh$mi${ss}Z';
  }
}
