import 'package:breeze/config.dart';
import 'package:flutter/material.dart';

bool isSameDate(DateTime d1, DateTime d2) {
  return d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;
}

String padDate(int datePart) => datePart.toString().padLeft(2, '0');

String formatDate(DateTime dt) =>
    '${padDate(dt.year)}-${padDate(dt.month)}-${padDate(dt.day)}';

String humanizeDate({int? offset, DateTime? dt}) {
  if (offset == null && dt == null) {
    throw ArgumentError.notNull('Must pass in one of offset or dt!');
  }
  if (dt != null) {
    offset = dt.difference(DateTime.now()).inDays;
  }
  switch (offset) {
    case -1:
      return 'Yesterday';
    case 0:
      return 'Today';
    case 1:
      return 'Tomorrow';
    default:
      final datetime = DateTime.now().add(Duration(days: offset!));
      return 0 < offset && offset < 7
          ? Config.weekdayNames[datetime.weekday]!
          : formatDate(datetime);
  }
}

bool isDateBeforeToday(DateTime dt) {
  final now = DateTime.now();
  final date = DateTime(dt.year, dt.month, dt.day);
  return date.isBefore(DateTime(now.year, now.month, now.day));
}

Future<DateTime?> popDatePicker(context) async => await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
