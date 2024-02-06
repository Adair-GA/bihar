import 'dart:convert';

import 'package:bihar/controller/profile_controller.dart';
import 'package:bihar/controller/login_data.dart';
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
    Response response = await LoginData.client.post(
      Uri.parse("${LoginData.url}$_endpoint/getFechasConsulta"),
      headers: {
        "auth-token": LoginData.authToken!
      },
      body: {
        "_numExpediente": ProfileController().expedienteActivo!.numExpediente
      }
      );
    if (response.statusCode != 200) {
      if (response.statusCode == 401){
        throw TokenExpiredException();  
      }
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
    String numExp = ProfileController().expedienteActivo!.numExpediente;
    String url = "${LoginData.url}$_endpoint/getHorario";
    Response response = await LoginData.client.post(
      Uri.parse(url),
      headers: {
        "auth-token": LoginData.authToken!
      },
      body: {
        "_numExpediente": numExp,
        "_fecha": day.toIso8601String().substring(0, 10),
        "_enMediasHoras": "N"
      });
    if (response.statusCode != 200) {
      if (response.statusCode == 401){
        throw TokenExpiredException();  
      }
      throw Exception("Error al obtener el horario del día $day");
    }
    return Dia.fromJson(jsonDecode(response.body));
  }
}