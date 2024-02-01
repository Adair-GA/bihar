import 'package:bihar/model/gaur_controller.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    GaurController().login(null, null).then((value) => 
    {
      if (value == GaurResponse.ok) {
        Navigator.of(context).pushReplacementNamed('/home')
      } else {
        Navigator.of(context).pushReplacementNamed('/login')
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator()
        ),
      );
  }
}
