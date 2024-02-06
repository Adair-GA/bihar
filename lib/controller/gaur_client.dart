import 'dart:convert';

import 'package:bihar/controller/login_data.dart';
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

  

  void logout(){
    _authToken = null;
    LoginData.logout();
  }
}