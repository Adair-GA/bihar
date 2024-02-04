import 'dart:convert';
import 'package:bihar/model/gaur_controller.dart';
import 'package:bihar/model/profile.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;
  int expediente = 1;
  int cantExpedientes = 0;

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
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home2',
          )
      ],
    ),
    );
  }

  Future<void> logout(BuildContext context) async {
    GaurController().logout();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Widget getBody(BuildContext context){
    switch(index){
      case 0:
        return _home(context);
      case 1:
        return _timetable(context);
      default:
        return _home(context);
    }
  }

  Widget _timetable(BuildContext context){
    return const Center(
      child: Text("Timetable"),
    );
  }

  Widget _home(BuildContext context){
    return Column(
      children: [
        _profile(context),
        Row(
          children: [
            if (cantExpedientes > 1)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: expediente > 1 ? () => setState(() => expediente--) : null,
              ),
            Expanded(child: Center(child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextScroll(
                "${GaurController().profile!.expedientes[expediente-1].grado}.",
                intervalSpaces: 20,
                style: const TextStyle(fontSize: 15),
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0),
              )),
            ))),
            if (cantExpedientes > 1)
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: expediente < cantExpedientes ? () => setState(() => expediente++) : null,
              ),
          ],
          ),
        const Divider(),
      ],
    );
  }

  Widget _profile(BuildContext context){
    UserProfile profile = GaurController().profile!;
    cantExpedientes = profile.expedientes.length;
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: Image.memory(
                  base64Decode(profile.foto!),
                  fit: BoxFit.cover,
                ).image,
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(StringUtils.capitalize(profile.nombre, allWords: true), style: const TextStyle(fontSize: 20)),
                  Text(profile.dni, style: const TextStyle(fontSize: 15)),
                ],
              ),
            ],
          ),
          const Divider(),
          // Text(profile.grado, style: const TextStyle(fontSize: 10), overflow: TextOverflow.ellipsis)
        ],
      ),
    );
  }
}

