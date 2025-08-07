import 'package:bihar/controller/gaur_client.dart';
import 'package:bihar/model/nota_provisional.dart';

class NotasController {
  static final NotasController _instance = NotasController._internal();
  factory NotasController() => _instance;
  NotasController._internal();

  //Si el tipo de enseñanza es 5 o 6, mostrar descPlan en vez de descAsignatura
  //La calificacion puede traer solo descCalificacion sin valorCalificacion
  //if (tipoEnse == "1" || tipoEnse == "2" || tipoEnse == "4"), mostrar item.descCiclo,
  //item.descCurso, item.descConvocatoria, nota, definitiva
  //if (tipoEnse == "12") lo mismo pero sin descCiclo
  //si es 5 o 6 mostrar solo calificacion y si es definitiva
  //si no, item.descConvocatoria, nota y definitiva
  //todos estos pueden o no traer info sobre la revisión, según si verRevision==1
  //tambien hay pruebas. pueden traer o no calificaion
  //puede que haya más de una prueba (tal vez? el codigo no es muy claro)

  /* {
    "numActa": "1524852",
    "codAsignatura": "502257",
    "anyo": "20230",
    "descAnyo": "2023/24",
    "descPlan": "Máster Universitario en Comunicación Social",
    "descCiclo": "ciclo",
    "descCurso": "curso",
    "descAsignatura": "Los medios locales y la entrevista. Análisis de modelos",
    "descConvocatoria": "Enero",
    "valorCalificacion": "7.00",
    "descCalificacion": "Notable",
    "esDefinitiva": "0",
    "verRevision": "1",
    "fIniRevision": "07/02/2024",
    "fFinRevision": "13/02/2024",
    "fedatarios": "CAMACHO MARKINA, IDOIA, SANTOS DIEZ, MARIA TERESA",
    "horario": "09:00-10:00 ",
    "lugarRevision": "Enviar por favor email (mariateresa.santos@ehu.eus) para concretar hora. Gracias",
    "hayPruebas": "0",
    "numPrueba": "",
    "fPrueba": "",
    "valorCalifPrueba": "",
    "descCalifPrueba": "",
    "verRevisionPrueba": "",
    "fIniRevisionPru": "",
    "fFinRevisionPru": "",
    "fedatarioPru": "",
    "horarioPru": "",
    "lugarRevisionPru": ""
  } */

  Future<List<NotaProvisional>> getNotasProvisionales() async {
    return await GaurClient().getNotasProvisionales();
  }
}
