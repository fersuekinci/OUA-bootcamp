import 'dart:collection';

import 'package:oua_bootcamp/model/appointment.dart';
import 'package:table_calendar/table_calendar.dart';

final kEvents = LinkedHashMap<DateTime, List<AppointmentModel>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource(AppointmentModel()));

_kEventSource(AppointmentModel appointment) {
  return {
    for (var item in List.generate(50, (index) => index))
      DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5):
          List.generate(item % 4 + 1, (index) => AppointmentModel())
  }..addAll({
      kToday: [
        AppointmentModel(),
        AppointmentModel(),
      ],
    });
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
