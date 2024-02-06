import 'package:bihar/controller/login_data.dart';
import 'package:flutter/material.dart';
import 'package:bihar/login.dart';
import 'package:bihar/homepage.dart';
import 'package:bihar/splashpage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      supportedLocales: {
        const Locale('es', 'ES')
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: const SplashPage(),
      routes: <String, WidgetBuilder>{
        "/splash":(context) => const SplashPage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const Login(),
      }
    );
  }
}