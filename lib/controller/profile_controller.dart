import 'dart:async';
import 'package:bihar/controller/gaur_client.dart';
import 'package:bihar/controller/login_data.dart';
import 'package:bihar/model/expediente.dart';
import 'package:bihar/model/profile.dart';
import 'package:http/http.dart';

enum LoginResponse { ok, noCredentials, connectionError, invalidCredentials }

class ProfileController {
  static final ProfileController _instance = ProfileController._internal();
  UserProfile? profile;
  Expediente? expedienteActivo;
  int indexExpedienteActivo = 0;

  factory ProfileController() => _instance;

  ProfileController._internal();

  Future<LoginResponse> login() async {
    final dynamic body;
    if (!LoginData.hasCredentials()) {
      return LoginResponse.noCredentials;
    }
    try {
      body = await GaurClient().login();
    } on ClientException {
      return LoginResponse.connectionError;
    }
    if (body == null) {
      return LoginResponse.invalidCredentials;
    }
    profile = await _buildProfile(body);
    setExpediente(0);
    return LoginResponse.ok;
  }

  Future<UserProfile> _buildProfile(dynamic loginBody) async {
    String dni = loginBody["numDocumento"];
    String nombre = loginBody["compactado"];
    String? foto = loginBody["foto"];

    final body = await GaurClient().getExpedientes();

    int numExpedientes = body.length;
    List<Expediente> expedientes = [];
    for (int i = 0; i < numExpedientes; i++) {
      expedientes.add(Expediente(
          body[i]["numExpediente"],
          body[i]["descCentro"],
          body[i]["descPlan"],
          body[i]["estadoExpediente"] == "Abierto"));
    }
    return UserProfile(nombre, dni, foto, expedientes);
  }

  void setExpediente(int index) {
    expedienteActivo = profile!.expedientes[index];
    indexExpedienteActivo = index;
  }

  void logout() {
    GaurClient().logout();
  }
}
