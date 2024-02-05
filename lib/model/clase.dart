import 'package:intl/intl.dart';

class Clase{
  DateTime horaComienzo;
  DateTime horaFin;
  String nombreAsignatura;
  String aula;
  String profesor;
  String tipo;
  String grupo;
  
  factory Clase.fromJson(Map<String, dynamic> json) {
    String fecha = json['fecha'];
    String intervalo = json['intervalo'];

    String horaC = fecha + ", " + intervalo.split("-")[0].trim();
    String horaF = fecha + ", " + intervalo.split("-")[1].trim();
    DateFormat format = DateFormat("d 'de' MMMM 'de' y, HH:mm", 'es_ES');

    return Clase(
      horaComienzo: format.parse(horaC),
      horaFin: format.parse(horaF),
      nombreAsignatura: json['descAsig'],
      aula: json['aula'],
      profesor: json['profesores'],
      tipo: json['descTipoGrupo'],
      grupo: json['numTipoGrupo'],
    );
  }

  Clase({required this.horaComienzo, required this.horaFin, required this.nombreAsignatura, required this.aula, required this.profesor, required this.tipo, required this.grupo});

  String getDesc(){
    if (grupo == "0"){
      return tipo;
    }
    return "$tipo: G$grupo";
  }
}