import 'dart:convert';

import 'package:bihar/model/gaur_controller.dart';
import 'package:bihar/model/profile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserProfile? profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("BIHAR"),
        actions: [
          IconButton(
            onPressed: () async{
              await logout(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
          child: Column(
            children: [
              _profile(context),
            ],
          ),
        ),
    bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          print(index);
        },
      destinations: const [
            NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          )
      ],
    ),
    );
  }

  Future<void> logout(BuildContext context) async {
    GaurController().logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget _profile(BuildContext context){
    UserProfile? profile = GaurController().profile;
    Image? pfp;
    if (profile!.foto != null) {
      pfp = Image.memory(
        base64Decode(profile.foto!),
        width: 100,
        height: 100,
        );
    }
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [Row(
            children: [
              ClipRRect(
                child: pfp ?? const Icon(Icons.person),
                borderRadius: BorderRadius.circular(50),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(profile.nombre),
                  Text(profile.facultad),
                ],
              ),
            ],
          ),
          Divider(),
          Container(child: Text(profile.grado, style: TextStyle(fontSize: 10))),
        ],
      ),
    );
  }
}
