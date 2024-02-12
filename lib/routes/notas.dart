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
            return ListView.builder(itemCount: snapshot.data!.length, itemBuilder: 
              (BuildContext context, int index){
                return ListTile(
                  title: Text(snapshot.data![index].descAsignatura!),
                  subtitle: Text(snapshot.data![index].descConvocatoria),
                  trailing: Text(snapshot.data![index].nota.toString()),
                );
              }
            );
          }
        }
        return CircularProgressIndicator();
      }
    );
  }
}
