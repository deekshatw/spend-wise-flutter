import 'package:flutter/material.dart';

class TransactionHelper {
  static DateTimeRange calculateDateRange(String selectedFilter,
      {DateTimeRange? customDateRange}) {
    DateTime now = DateTime.now();
    DateTime start;
    DateTime end;

    switch (selectedFilter) {
      case 'Today':
        start = DateTime(now.year, now.month, now.day);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case 'Yesterday':
        start = DateTime(now.year, now.month, now.day - 1);
        end = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
        break;
      case 'This Week':
        start = now.subtract(Duration(days: now.weekday - 1));
        end = start
            .add(Duration(days: 6))
            .add(Duration(hours: 23, minutes: 59, seconds: 59));
        break;
      case 'Last Week':
        start = now.subtract(Duration(days: now.weekday + 6));
        end = start
            .add(Duration(days: 6))
            .add(Duration(hours: 23, minutes: 59, seconds: 59));
        break;
      case 'This Month':
        start = DateTime(now.year, now.month, 1);
        end =
            DateTime(now.year, now.month + 1, 1).subtract(Duration(seconds: 1));
        break;
      case 'Last Month':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 1).subtract(Duration(seconds: 1));
        break;
      case 'This Year':
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31, 23, 59, 59);
        break;
      case 'Last Year':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31, 23, 59, 59);
        break;
      case 'Custom Date Selection':
        if (customDateRange != null) {
          start = customDateRange.start;
          end = customDateRange.end;
        } else {
          // Fallback if customDateRange is null
          start = now;
          end = now;
        }
        break;
      default:
        start = now;
        end = now;
    }

    return DateTimeRange(start: start, end: end);
  }
}
