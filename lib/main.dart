import 'package:bihar/controller/login_data.dart';
import 'package:bihar/homepage.dart';
import 'package:bihar/login.dart';
import 'package:bihar/splashPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting();
  Intl.defaultLocale = 'es_ES';
  await LoginData.init();
  if (kReleaseMode) {
    SentryFlutter.init(
        (options) => options
          ..dsn =
              'https://f0e2a7201752411c8bc97ecfa4cfa34c@biharlogs.duckdns.org/1' // if hard coding GlitchTip DSN
          ..tracesSampleRate = 0.01 // Performance trace 1% of events
          ..enableAutoSessionTracking = false,
        appRunner: () => runApp(const MyApp()));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: const Locale('es', 'ES'),
        supportedLocales: {const Locale('es', 'ES'), const Locale("eu", "ES")},
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        home: const SplashPage(),
        routes: <String, WidgetBuilder>{
          "/splash": (context) => const SplashPage(),
          '/home': (context) => const HomePage(),
          '/login': (context) => const Login(),
        });
  }
}
