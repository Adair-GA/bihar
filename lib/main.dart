import 'package:bihar/controller/login_data.dart';
import 'package:flutter/material.dart';
import 'package:bihar/login.dart';
import 'package:bihar/homepage.dart';
import 'package:bihar/splashpage.dart';
import 'package:intl/date_symbol_data_local.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  await LoginData.init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('es', 'ES'),
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        "/splash":(context) => SplashPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => const Login(),
      }
    );
  }
}