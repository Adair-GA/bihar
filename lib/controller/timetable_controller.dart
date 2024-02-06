import 'package:bihar/controller/gaur_client.dart';
import 'package:bihar/model/dia.dart';
import 'package:flutter/material.dart';

class TimetableController {
  static final TimetableController _instance = TimetableController._internal();
  factory TimetableController() => _instance;
  TimetableController._internal();
  DateTimeRange? _available;

  Future<DateTimeRange> getAvailable() async {
    Map<String, dynamic> body = await GaurClient().getFechasConsulta();
    DateTime start = DateTime.parse(body["minFec"]);
    DateTime end = DateTime.parse(body["maxFec"]);
    var dateTimeRange = DateTimeRange(start: start, end: end);
    _available = dateTimeRange;
    return dateTimeRange;
  }

  Future<Dia> getDay(DateTime day) async{
    _available ??= await getAvailable();
    if (day.isAfter(_available!.end) || day.isBefore(_available!.start)) {
      throw Exception("La fecha $day no está disponible");
    }
    final dia = await GaurClient().getHorario(day);
    return Dia.fromJson(dia);
  }
}