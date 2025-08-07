import 'dart:async';
import 'dart:convert';

import 'package:bihar/controller/login_data.dart';
import 'package:bihar/controller/profile_controller.dart';
import 'package:bihar/model/tutorials/month.dart';
import 'package:bihar/model/tutorials/tutorial.dart';
import 'package:http/http.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../model/nota_provisional.dart';

class TokenExpiredException implements Exception {}

class GaurClient {
  // static const String _url = "https://aa4ee609-656b-4a43-bb77-cd47683986d8.mock.pstmn.io/gaurMovilRS/rest";
  static const String _url =
      "https://gestion-servicios.ehu.es/gaurMovilRS/rest";
  final Client _client = SentryHttpClient();
  String? _authToken;

  static final GaurClient _instance = GaurClient._internal();

  factory GaurClient() => _instance;

  GaurClient._internal();

  Future<Response> post(Uri uri,
      {Map<String, String>? body, Map<String, String>? headers}) async {
    int tries = 0;
    while (tries < 4) {
      try {
        Response resp = await _client.post(uri, headers: headers, body: body);
        if (resp.statusCode == 401) {
          throw TokenExpiredException();
        }
        _authToken = resp.headers["auth-token"];
        return resp;
      } on TokenExpiredException {
        await login();
        tries += 1;
      } on ClientException {
        tries += 1;
      }
    }
    final ex = Exception("No se ha podido realizar la conexión al servidor");
    Sentry.captureException(ex);
    throw ex;
  }

  Future<dynamic> login() async {
    if (LoginData.ldap == null || LoginData.pass == null) {
      final ex = Exception("No hay credenciales");
      Sentry.captureException(ex);
      throw ex;
    }
    Response response =
        await _client.post(Uri.parse("$_url/login/doLogin"), body: {
      '_clave': LoginData.pass,
      '_recordar': "S",
      '_usuario': LoginData.ldap,
      '_idioma': 'es',
      '_device_id': "64235997dc003f48"
    });
    final body = jsonDecode(response.body);
    if (!response.headers.containsKey("auth-token")) {
      return null;
    }
    _authToken = response.headers["auth-token"];
    return body;
  }

  Future<dynamic> getExpedientes() async {
    Response response = await _client.post(
        Uri.parse('$_url/expedientes/getExpedientesByIdp'),
        headers: {'auth-token': _authToken!, 'Accept': '*/*'});
    return jsonDecode(response.body);
  }

  Future<dynamic> getFechasConsulta() async {
    Response response =
        await post(Uri.parse("$_url/horarios/getFechasConsulta"), headers: {
      "auth-token": _authToken!
    }, body: {
      "_numExpediente": ProfileController().expedienteActivo!.numExpediente
    });
    return jsonDecode(response.body);
  }

  Future<dynamic> getHorario(DateTime day) async {
    String numExp = ProfileController().expedienteActivo!.numExpediente;
    String url = "$_url/horarios/getHorario";
    Response response = await post(Uri.parse(url), headers: {
      "auth-token": _authToken!
    }, body: {
      "_numExpediente": numExp,
      "_fecha": day.toIso8601String().substring(0, 10),
      "_enMediasHoras": "N"
    });
    return (jsonDecode(response.body));
  }

  void postLogout() {
    String url = "$_url/login/logout";
    unawaited(post(Uri.parse(url), headers: {"auth-token": _authToken!}));
    return;
  }

  void logout() {
    postLogout();
    _authToken = null;
    LoginData.logout();
  }

  Future<List<NotaProvisional>> getNotasProvisionales() async {
    String numExp = ProfileController().expedienteActivo!.numExpediente;
    String url = "$_url/notas/getNotasProvisionales";
    Response response = await post(Uri.parse(url), headers: {
      "auth-token": _authToken!
    }, body: {
      "_numExp": numExp,
      "_idp": LoginData.ldap!,
      "_codPlan": ProfileController().expedienteActivo!.codplan
    });
    List<dynamic> json = jsonDecode(response.body);

    return json.map((e) => NotaProvisional.fromJson(e)).toList();
  }

  Future<dynamic> getSubjectsTutorial() async {
    String numExp = ProfileController().expedienteActivo!.numExpediente;
    String url = "$_url/tutorias/getAsignaturasTutorias";
    Response response = await post(Uri.parse(url), headers: {
      "auth-token": _authToken!
    }, body: {
      "_numExpediente": numExp,
    });

    return jsonDecode(response.body);
  }

  Future<List<Month>> getMonthsTutorials(
      String anyoAcademico, String idpProfesor, String codDpto) async {
    String url = "$_url/tutorias/getMesesTutorias";
    Response response = await post(Uri.parse(url), headers: {
      "auth-token": _authToken!
    }, body: {
      "_anyoAcademico": anyoAcademico,
      "_idpProfesor": idpProfesor,
      "_codDpto": codDpto,
    });

    dynamic decoded = jsonDecode(response.body);

    List<Month> result = [];
    for (var mes in decoded) {
      result.add(Month(mes["mes"], mes["codMes"]));
    }

    return result;
  }

  Future<List<Tutorial>> getTutorials(String anyoAcademico, String idpProfesor,
      String codDpto, String codMes) async {
    String url = "$_url/tutorias/getTutorias";
    Response response = await post(Uri.parse(url), headers: {
      "auth-token": _authToken!
    }, body: {
      "_anyoAcademico": anyoAcademico,
      "_idpProfesor": idpProfesor,
      "_codDpto": codDpto,
      "_codMes": codMes,
    });

    dynamic decoded = jsonDecode(response.body);

    List<Tutorial> result = [];
    for (var tutorial in decoded) {
      DateTime? date;
      try {
        date = DateTime.parse(tutorial["fecTutoria"]);
      } on Exception {
        // It's not really required
      }

      result.add(Tutorial(tutorial["fecha"], tutorial["horaInicio"],
          tutorial["horaFin"], tutorial["lugar"], tutorial["edificio"], date));
    }

    return result;
  }
}
