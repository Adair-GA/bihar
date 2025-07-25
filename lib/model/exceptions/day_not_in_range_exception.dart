class DayNotInRangeException implements Exception {
  DateTime? firstAvailableDay;

  DayNotInRangeException({this.firstAvailableDay});
}