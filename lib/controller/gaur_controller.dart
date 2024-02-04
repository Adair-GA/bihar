import 'dart:async';
import 'dart:convert';
import 'package:bihar/controller/global_data.dart';
import 'package:bihar/model/expediente.dart';
import 'package:bihar/model/profile.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

enum GaurLoginResponse{
  ok,
  connectionError,
  userNotFound,
  wrongPassword,
  noStoredCredentials
}

class GaurController {
  static final GaurController _instance = GaurController._internal(); 
  static const _storage = FlutterSecureStorage();
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
    GlobalData.authToken = null;
  }

  Future<GaurLoginResponse> login(String? ldap, String? pass) async{
    http.Response? response;
    if (ldap == null && pass == null) {
      ldap = _ldap;
      pass = _pass;
    }
    if (ldap == null || pass == null) {
      return GaurLoginResponse.noStoredCredentials;
    }
    try{
      response = await GlobalData.client.post(
        Uri.parse('${GlobalData.url}/login/doLogin'),
        body: {
          '_clave': pass,
          '_recordar': "S",
          '_usuario': ldap,
          '_idioma': 'es',
          '_device_id': "64235997dc003f48"
        },
        );
        if (!response.headers.containsKey("auth-token")) {
          final body = jsonDecode(response.body);
          if (body["alertaError"] == "Clave incorrecta") {
            return GaurLoginResponse.wrongPassword;
          }
          if (body["alertaError"] == "Usuario incorrecto") {
            return GaurLoginResponse.userNotFound;
          }
        }
      GlobalData.authToken = response.headers['auth-token']!;
      profile = await _buildProfile(response);
      } on http.ClientException catch (_) {
        return GaurLoginResponse.connectionError;
      }
      setExpediente(0);

      _storage.write(key: 'ldap', value: ldap);
      _storage.write(key: 'password', value: pass);
      return GaurLoginResponse.ok;
    }
  
  Future<UserProfile> _buildProfile(http.Response loginResponse) async {
    var body = jsonDecode(loginResponse.body);
    String dni = body["numDocumento"];
    String nombre = body["compactado"];
    String? foto;
    if (body["foto"] != null) {
      foto = body["foto"];
    }
    http.Response response = await GlobalData.client.post(
      Uri.parse('${GlobalData.url}/expedientes/getExpedientesByIdp'),
      headers: {
        'auth-token': GlobalData.authToken!,
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