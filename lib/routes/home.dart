import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:bihar/controller/profile_controller.dart';
import 'package:bihar/model/profile.dart';
import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int expediente = 1;
  int cantExpedientes = 0;

  @override
  void initState(){
    expediente = 1 + ProfileController().indexExpedienteActivo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _profile(context),
        Row(
          children: [
            if (cantExpedientes > 1)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: expediente > 1 ? () => setState(() {expediente--; ProfileController().setExpediente(expediente - 1);} ) : null,
              ),
            Expanded(child: Center(child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextScroll(
                "${ProfileController().profile!.expedientes[expediente-1].grado}.",
                intervalSpaces: 20,
                style: const TextStyle(fontSize: 15),
                velocity: const Velocity(pixelsPerSecond: Offset(50, 0),
              )),
            ))),
            if (cantExpedientes > 1)
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: expediente < cantExpedientes ? () => setState(() {expediente++; ProfileController().setExpediente(expediente - 1);})  : null,
              ),
          ],
          ),
        const Divider(),
      ],
    );
  }

  Widget _profile(BuildContext context){
    UserProfile profile = ProfileController().profile!;
    cantExpedientes = profile.expedientes.length;
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: Image.memory(
                  base64Decode(profile.foto!),
                  fit: BoxFit.cover,
                ).image,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(StringUtils.capitalize(profile.nombre, allWords: true), style: const TextStyle(fontSize: 20)),
                      Text(profile.dni, style: const TextStyle(fontSize: 15)),
                      Text(profile.expedientes[expediente-1].facultad, style: const TextStyle(fontSize: 15))
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}