import 'package:bihar/controller/notas_controller.dart';
import 'package:bihar/model/nota_provisional.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class Notas extends StatefulWidget {
  const Notas({Key? key}) : super(key: key);

  @override
  State<Notas> createState() => _NotasState();
}

class _NotasState extends State<Notas> {
  Future<List<NotaProvisional>> future =
      NotasController().getNotasProvisionales();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context,
            AsyncSnapshot<List<NotaProvisional>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            if (snapshot.hasData) {
              return buildList(snapshot.data!);
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget buildList(List<NotaProvisional> data) {
    if (data.isEmpty) {
      return Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "No tienes notas provisionales",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
            ),
          ),
          // Image.asset("assets/img/no_marks.png"),
        ],
      ));
    }
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              ExpandablePanel(
                  theme: ExpandableThemeData(
                    iconColor: Theme.of(context).colorScheme.onSurface,
                  ),
                  header: ListTile(
                    title: Text(data[index].descAsignatura!),
                    subtitle: Text(data[index].descConvocatoria),
                  ),
                  collapsed: ListTile(
                    trailing: Text(
                        "F. Revisión: ${data[index].fechaRevision ?? ""} ${data[index].horarioRevision ?? ""}"),
                    title: Text("Nota: ${data[index].nota ?? "No disponible"}"),
                  ),
                  expanded: ListTile(
                    isThreeLine: true,
                    title: Text("Nota: ${data[index].nota ?? "No disponible"}"),
                    subtitle: Text("Lugar: ${data[index].lugarRevision ?? ""}"),
                  )),
              const Divider(),
            ],
          );
        });
  }

// Widget getExpandableForType(NotaProvisional nota){
//   return ExpandablePanel(
//     theme: ExpandableThemeData(
//       iconColor: Theme.of(context).colorScheme.onSurface,
//     ),
//     header: ListTile(
//       title: Text(data[index].descAsignatura!),
//       subtitle: Text(data[index].descConvocatoria),
//     ),
//     collapsed: ListTile(
//       trailing: Text("F. Revisión: ${data[index].fechaRevision?? ""} ${data[index].horarioRevision?? ""}"),
//       title: Text("Nota: ${data[index].nota?? "No disponible"}"),
//     ),
//     expanded: ListTile(
//       isThreeLine: true,
//       title: Text("Nota: ${data[index].nota?? "No disponible"}"),
//       subtitle: Text("Lugar: ${data[index].lugarRevision ?? ""}"),
//     )
//   );
// }
}
