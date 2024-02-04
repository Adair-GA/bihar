import 'package:http/http.dart';

class GlobalData{
  // static const String url = "https://aa4ee609-656b-4a43-bb77-cd47683986d8.mock.pstmn.io/gaurMovilRS/rest";
  static const String url = "https://gestion-servicios.ehu.es/gaurMovilRS/rest";
  static final Client client = Client();
  static String? authToken;
}