import 'package:bihar/controller/gaur_client.dart';
import 'package:bihar/model/dia.dart';
import 'package:bihar/model/exceptions/day_not_in_range_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TimetableController {
  static final TimetableController _instance = TimetableController._internal();

  factory TimetableController() => _instance;

  TimetableController._internal();

  DateTimeRange? _available;
  final Map<DateTime, Dia> _cache = {};

  Future<DateTimeRange> getAvailable() async {
    Map<String, dynamic> body = await GaurClient().getFechasConsulta();
    DateTime start = DateTime.parse(body["minFec"]);
    DateTime end = DateTime.parse(body["maxFec"]);
    var dateTimeRange = DateTimeRange(start: start, end: end);
    _available = dateTimeRange;
    return dateTimeRange;
  }

  Future<Dia> getDay(DateTime date) async {
    var cachedDay = _cache[date];
    if (cachedDay != null && !kDebugMode) {
      return cachedDay;
    }
    _available ??= await getAvailable();
    if (date.isAfter(_available!.end) || date.isBefore(_available!.start)) {
      throw DayNotInRangeException(firstAvailableDay: _available!.start);
    }
    final diaJSON = await GaurClient().getHorario(date);

    var dia = Dia.fromJson(diaJSON);
    _cache[date] = dia;
    return dia;
  }
}
