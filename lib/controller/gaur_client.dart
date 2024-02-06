import 'dart:convert';

import 'package:bihar/controller/login_data.dart';
import 'package:bihar/controller/profile_controller.dart';
import 'package:http/http.dart';

class GaurClient{
  // static const String _url = "https://aa4ee609-656b-4a43-bb77-cd47683986d8.mock.pstmn.io/gaurMovilRS/rest";
  static const String _url = "https://gestion-servicios.ehu.es/gaurMovilRS/rest";
  final Client _client = Client();
  String? _authToken;

  static final GaurClient _instance = GaurClient._internal();
  factory GaurClient() => _instance;

  GaurClient._internal();
  
  Future<dynamic> login() async{
    if (LoginData.ldap == null || LoginData.pass == null){
      //TODO: Esto no deberia pasar nunca pero habría que loguearlo
      throw Exception("No hay credenciales");
    }
    Response response = await _client.post(
      Uri.parse("$_url/login/doLogin"),
      body: {
        '_clave': LoginData.pass,
        '_recordar': "S",
        '_usuario': LoginData.ldap,
        '_idioma': 'es',
        '_device_id': "64235997dc003f48"
      }
    );
    final body = jsonDecode(response.body);
    if (!response.headers.containsKey("auth-token")) {
      return null;
    }
    _authToken = response.headers['auth-token'];
    return body;
  }

  Future<dynamic> getExpedientes() async {
    Response response = await _client.post(
      Uri.parse('$_url/expedientes/getExpedientesByIdp'),
      headers: {
        'auth-token': _authToken!,
        'Accept': '*/*'
      }
    );
    return jsonDecode(response.body);
  }

  Future<dynamic> getFechasConsulta() async {
    Response response = await _client.post(
      Uri.parse("$_url/horarios/getFechasConsulta"),
      headers: {
        "auth-token": _authToken!
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
    return jsonDecode(response.body);
  }


  Future<dynamic> getHorario(DateTime day) async {
    String numExp = ProfileController().expedienteActivo!.numExpediente;
    String url = "$_url/horarios/getHorario";
    Response response = await _client.post(
      Uri.parse(url),
      headers: {
        "auth-token": _authToken!
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
    _authToken = response.headers["auth-token"];
    return (jsonDecode(response.body));
  }

  void logout(){
    _authToken = null;
    LoginData.logout();
  }
}