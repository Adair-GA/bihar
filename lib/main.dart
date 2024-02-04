import 'package:bihar/model/gaur_controller.dart';
import 'package:flutter/material.dart';
import 'package:bihar/login.dart';
import 'package:bihar/homepage.dart';
import 'package:bihar/splashpage.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GaurController().init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        "/splash":(context) => SplashPage(),
        '/home': (context) => HomePage(),
        '/login': (context) => Login(),
      }
    );
  }
}