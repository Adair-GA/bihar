import 'package:bihar/controller/notas_controller.dart';
import 'package:bihar/model/nota_provisional.dart';
import 'package:flutter/material.dart';

class Notas extends StatefulWidget {
  const Notas({Key? key}) : super(key: key);

  @override
  State<Notas> createState() => _NotasState();
}


class _NotasState extends State<Notas> {

  Future<List<NotaProvisional>> future = NotasController().getNotasProvisionales();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: future, builder: 
      (BuildContext context, AsyncSnapshot<List<NotaProvisional>> snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          if (snapshot.hasError){
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.hasData){
            return buildList(snapshot.data!);
          }
        }
        return const CircularProgressIndicator();
      }
    );
  }

  Widget buildList(List<NotaProvisional> data) {
    if (data.isEmpty){
      return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text("No tienes notas provisionales", style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontSize: 20
            ),),
          ),
          Image.asset("assets/img/no_marks.png"),
        ],
      )
    );
    }
    return ListView.builder(itemCount: data.length, itemBuilder: 
            (BuildContext context, int index){
              return ListTile(
                title: Text(data[index].descAsignatura!),
                subtitle: Text(data[index].descConvocatoria),
                trailing: Text(data[index].nota.toString()),
              );
            }
          );
  }


}
