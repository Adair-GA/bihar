import 'package:bihar/controller/profile_controller.dart';
import 'package:bihar/routes/home.dart';
import 'package:bihar/routes/timetable.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

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
      body: getBody(context),
    bottomNavigationBar: NavigationBar(
      onDestinationSelected: (int index) {
        setState(() {
          this.index = index;
        });
      },
      selectedIndex: index,

      destinations: const [
            NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.table_rows),
            icon: Icon(Icons.table_rows_outlined),
            label: 'Horario',
          )
      ],
    ),
    );
  }

  Future<void> logout(BuildContext context) async {
    ProfileController().logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget getBody(BuildContext context){
    switch(index){
      case 0:
        return Home();
      case 1:
        return TimeTable();
      default:
        return Home();
    }
  }
}

