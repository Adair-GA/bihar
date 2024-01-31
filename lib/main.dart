import 'package:bihar/model/gaur_controller.dart';
import 'package:flutter/material.dart';
import 'package:bihar/login.dart';
import 'package:bihar/homepage.dart';
import 'package:bihar/splashpage.dart';
import 'package:get_it/get_it.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final getIt = GetIt.instance;
  getIt.registerSingleton<GaurController>(GaurController());
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashPage(),
      routes: <String, WidgetBuilder>{
        "/splash":(context) => SplashPage(),
        '/home': (BuildContext context) => HomePage(title: 'Home'),
        '/login': (BuildContext context) => const Login(),
      }
    );
  }
}