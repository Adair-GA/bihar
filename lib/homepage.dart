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
        title: Text("A"),
      ),
      body: Center(
          child: Column(
            children: [
              _profile(context),
              const Text("Home Page"),
              ElevatedButton(onPressed: () async {
                await logout(context);
              }, child: const Text("Logout")),
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
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
        ),
        profile?.foto ?? const Icon(Icons.account_circle, size: 100),
        Column(
          children: [
            Text(profile?.nombre ?? "Nombre"),
            Text(profile?.dni ?? "Apellidos"),
            Text(profile?.facultad ?? "Email"),
            Text(profile?.grado ?? "Teléfono"),
          ],
        )
      ],
    );
  }
}
