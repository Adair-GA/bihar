import 'package:bihar/model/clase.dart';

class Dia{
  List<Clase> clases;

  factory Dia.fromJson(List<dynamic> json) {
    List<Clase> cls = [];
    if(json.isNotEmpty){
      for(var clase in json){
        if (clase['numAsig'] == "0") continue; // No hay clase
        cls.add(Clase.fromJson(clase));
      }
    }
    return Dia(cls);
  }

  Dia(this.clases);

  bool empty(){
    return clases.isEmpty;
  }


}