import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bihar/model/profile.dart';
import 'package:flutter/material.dart';
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
  static const String _url = "https://gestion-servicios.ehu.es/gaurMovilRS/rest";
  final http.Client _client = http.Client();
  static const _storage = FlutterSecureStorage();
  String? _authToken;
  String? _ldap;
  String? _pass;
  UserProfile? profile;


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
    Image? foto;
    if (body["foto"] != null) {
      foto = Image.memory(base64Decode(body["foto"]));
    }
    http.Response? response = await http.post(
      Uri.parse('$_url/expedientes/getExpedientesByIdp'),
      headers: {
        'auth-token': _authToken!,
        'Accept': '*/*'
      }
    );
    body = jsonDecode(response.body);
    String facultad = body[0]["descCentro"];
    String carrera = body[0]["descPlan"];

    return UserProfile(nombre, dni, facultad, carrera, foto);
  }
}