import 'package:flutter/material.dart';
import 'package:bihar/login.dart';
import 'package:bihar/homepage.dart';
import 'package:bihar/splashpage.dart';

void main() async{
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
        '/home': (BuildContext context) => const HomePage(title: 'Home'),
        '/login': (BuildContext context) => const Login(),
      }
    );
  }
}