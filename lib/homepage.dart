import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(title: 'BIHAR'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});


  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
            children: [
              Text("Home Page"),
              ElevatedButton(onPressed: () async {
                final storage = FlutterSecureStorage();
                await storage.delete(key: 'ldap');
                Navigator.of(context).pushReplacementNamed('/login');
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
}
