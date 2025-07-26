import 'package:intl/intl.dart';

class Clase {
  DateTime horaComienzo;
  DateTime horaFin;
  String nombreAsignatura;
  String aula;
  String profesor;
  String tipo;
  String grupo;
  String grupoCorto;
  String edificio;
  bool conflict;

  factory Clase.fromJson(Map<String, dynamic> json) {
    String fecha = json['fecha'];
    String intervalo = json['intervalo'];

    String horaC = "$fecha, ${intervalo.split("-")[0].trim()}";
    String horaF = "$fecha, ${intervalo.split("-")[1].trim()}";
    DateFormat format = DateFormat("d 'de' MMMM 'de' y, HH:mm", 'es_ES');

    return Clase(
      horaComienzo: format.parse(horaC),
      horaFin: format.parse(horaF),
      nombreAsignatura: json['descAsig'],
      aula: json['aula'],
      profesor: json['profesores'],
      tipo: json['descTipoGrupo'],
      grupo: json['grupo'],
      grupoCorto: json['numTipoGrupo'],
      edificio: json['edificio'],
      conflict: json['numAsig'] != '1'
    );
  }

  Clase(
      {required this.horaComienzo,
      required this.horaFin,
      required this.nombreAsignatura,
      required this.aula,
      required this.profesor,
      required this.tipo,
      required this.grupo,
      required this.edificio,
      required this.grupoCorto,
      required this.conflict
      });

  String getDesc() {
    if (grupoCorto == "0") {
      return tipo;
    }
    return "$tipo: G$grupoCorto";
  }
}
