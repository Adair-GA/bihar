import 'dart:async';
import 'dart:convert';
import 'package:bihar/model/expediente.dart';
import 'package:bihar/model/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum GaurResponse{
  ok,
  connectionError,
  userNotFound,
  wrongPassword,
  noStoredCredentials
}

class GaurController {
  static final GaurController _instance = GaurController._internal(); 
  static const String _url = "https://aa4ee609-656b-4a43-bb77-cd47683986d8.mock.pstmn.io/gaurMovilRS/rest";
  final http.Client _client = http.Client();
  static const _storage = FlutterSecureStorage();
  String? _authToken;
  String? _ldap;
  String? _pass;
  UserProfile? profile;
  Expediente? expedienteActivo;


  factory GaurController() => _instance;

  GaurController._internal();

  Future<void> init() async {
    _ldap = await _getLdap();
    _pass = await _getPass();
  }

  Future<String?> _getLdap() async{
    return await _storage.read(key: 'ldap');
  }

  Future<String?> _getPass() async{
    return await _storage.read(key: 'password');
  }

  void logout() {
    unawaited(_storage.delete(key: 'ldap'));
    unawaited(_storage.delete(key: 'pass'));
    _ldap = null;
    _pass = null;
    _authToken = null;
  }

  Future<GaurResponse> login(String? ldap, String? pass) async{
    http.Response? response;
    if (ldap == null && pass == null) {
      ldap = _ldap;
      pass = _pass;
    }
    if (ldap == null || pass == null) {
      return GaurResponse.noStoredCredentials;
    }
    try {
       response = await _client.post(
        Uri.parse('$_url/login/doLogin'),
        body: {
          '_clave': pass,
          '_recordar': "S",
          '_usuario': ldap,
          '_idioma': 'es',
          '_device_id': "64235997dc003f48"
        },
        );
      } on http.ClientException catch (_) {
        return GaurResponse.connectionError;
      }
    if (response.headers.containsKey("auth-token")) {
      _authToken = response.headers['auth-token']!;
      profile = await _buildProfile(response);
      setExpediente(0);
      _storage.write(key: 'ldap', value: ldap);
      _storage.write(key: 'password', value: pass);
      return GaurResponse.ok;
    } else {
      final body = jsonDecode(response.body);
      if (body["alertaError"] == "Clave incorrecta") {
        return GaurResponse.wrongPassword;
      }
      if (body["alertaError"] == "Usuario incorrecto") {
        return GaurResponse.userNotFound;
      }
    }
    //TODO: Esto debería logearse en algún sitio
    return GaurResponse.connectionError;
  }
  
  Future<UserProfile> _buildProfile(http.Response loginResponse) async {
    var body = jsonDecode(loginResponse.body);
    String dni = body["numDocumento"];
    String nombre = body["compactado"];
    String? foto;
    if (body["foto"] != null) {
      foto = body["foto"];
    }
    http.Response? response = await http.post(
      Uri.parse('$_url/expedientes/getExpedientesByIdp'),
      headers: {
        'auth-token': _authToken!,
        'Accept': '*/*'
      }
    );
    body = jsonDecode(response.body);
    int numExpedientes = body.length;
    List<Expediente> expedientes = [];
    for (int i = 0; i < numExpedientes; i++) {
      expedientes.add(Expediente(
          body[i]["numExpediente"],
          body[i]["descCentro"],
          body[i]["descPlan"],
          body[i]["estadoExpediente"] == "Abierto"
        ));
    }
    return UserProfile(nombre, dni, foto, expedientes);
  }

  void setExpediente(int index) {
    expedienteActivo = profile!.expedientes[index];
  }
}