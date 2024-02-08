import 'package:flutter/material.dart';

class Notas extends StatefulWidget {
  const Notas({Key? key}) : super(key: key);

  @override
  State<Notas> createState() => _NotasState();
}


class _NotasState extends State<Notas> {
  @override
  Widget build(BuildContext context) {
  var list = List.generate(25, (i) => i);
    return ListView(
      children: [
        Text("TEtasss")
      ],
    );
  }
}
