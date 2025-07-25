import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginData{
  static String? ldap, pass;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();


  static Future<void> init() async{
    ldap = await _storage.read(key: "ldap");
    pass = await _storage.read(key: "pass");
  }

  static bool hasCredentials(){
    return (ldap != null && pass != null);
  }

  static void logout() {
    _storage.delete(key: "ldap");
    _storage.delete(key: "pass");
  }

  static void setCredentials(String pLdap, String pPass){
    ldap = pLdap;
    pass = pPass;
    _storage.write(key: "ldap", value: pLdap);
    _storage.write(key: "pass", value: pPass);
  }
}