import 'package:bihar/controller/profile_controller.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    ProfileController().login().then((value) => 
    {
      if (value == LoginResponse.ok) {
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
