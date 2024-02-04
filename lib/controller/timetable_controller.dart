import 'dart:convert';

import 'package:bihar/controller/gaur_controller.dart';
import 'package:bihar/controller/global_data.dart';
import 'package:bihar/model/dia.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class TimetableController {
  static final TimetableController _instance = TimetableController._internal();
  factory TimetableController() => _instance;
  TimetableController._internal();
  static const _endpoint = "/horarios";
  DateTimeRange? _available;

  Future<DateTimeRange> getAvailable() async {
    Response response = await GlobalData.client.post(
      Uri.parse("${GlobalData.url}$_endpoint/getFechasConsulta"),
      headers: {
        "auth-token": GlobalData.authToken!
      },
      body: {
        "_numExpediente": GaurController().expedienteActivo!.numExpediente
      }
      );
    if (response.statusCode != 200) {
      throw Exception("Error al obtener las fechas disponibles");
    }
    Map<String, dynamic> body = jsonDecode(response.body);
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
    String numExp = GaurController().expedienteActivo!.numExpediente;
    String url = "${GlobalData.url}$_endpoint/getHorario";
    Response response = await GlobalData.client.post(
      Uri.parse(url),
      headers: {
        "auth-token": GlobalData.authToken!
      },
      body: {
        "_numExpediente": numExp,
        "_fecha": day.toIso8601String().substring(0, 10),
        "_enMediasHoras": "N"
      });
    if (response.statusCode != 200) {
      throw Exception("Error al obtener el horario del día $day");
    }
    return Dia.fromJson(jsonDecode(response.body));
  }
}