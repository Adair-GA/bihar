import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() async{
    final ldap = await _getLdap();
    final pass = await _getPass();
    if (ldap == null || pass == null) {
      Navigator.of(context).pushReplacementNamed('/login');
    } 
    final response = await http.post(
      Uri.parse('https://gestion-servicios.ehu.es/gaurMovilRS/rest/login/doLogin'),
      body: {
        '_clave': pass,
        '_recordar': "S",
        '_usuario': ldap,
        '_idioma': 'es',
        //TODO: Change this to the actual device id
        '_device_id': "64235997dc003f48"
      }
    );
    if (response.statusCode == 200) {
      auth_header = response.headers['auth-token']!;

      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }

  Future<String?> _getLdap() async{
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'ldap');
  }

  Future<String?> _getPass() async{
    final storage = FlutterSecureStorage();
    return await storage.read(key: 'password');
  }

}
