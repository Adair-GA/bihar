

import 'dart:convert';

import 'package:bihar/model/clase.dart';
import 'package:bihar/model/dia.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting();
  Dia x = Dia.fromJson(jsonDecode(
    '''
    [{
      "dia": "Lunes",
      "fecha": "5 de febrero de 2024",
      "intervalo": "09:00 - 11:00",
      "numAsig": "1",
      "descAsig": "Sistemas Web",
      "tipoGrupo": "GL",
      "descTipoGrupo": "P. Laboratorio",
      "numTipoGrupo": "2",
      "horaIniAsig": "09:00",
      "horaFinAsig": "11:00",
      "duracionAsig": "(2h)",
      "curso": "3er curso",
      "grupo": "01 Castellano - Mañana",
      "profesores": "ALVAREZ GUTIERREZ, MARIA LUZ",
      "aula": "P6I10L",
      "edificio": "ESCUELA DE INGENIERIA DE BILBAO-EDIFICIO II",
      "asignado": "1",
      "enMediasHoras": "N"
    },
    {
      "dia": "Lunes",
      "fecha": "5 de febrero de 2024",
      "intervalo": "11:00 - 13:00",
      "numAsig": "1",
      "descAsig": "Administración de Bases de Datos",
      "tipoGrupo": "T",
      "descTipoGrupo": "Teórico",
      "numTipoGrupo": "0",
      "horaIniAsig": "11:00",
      "horaFinAsig": "13:00",
      "duracionAsig": "(2h)",
      "curso": "3er curso",
      "grupo": "01 Castellano - Mañana",
      "profesores": "LOPEZ NOVOA, UNAI",
      "aula": "P4I10A",
      "edificio": "ESCUELA DE INGENIERIA DE BILBAO-EDIFICIO II",
      "asignado": "1",
      "enMediasHoras": "N"
    },
    {
      "dia": "Lunes",
      "fecha": "5 de febrero de 2024",
      "intervalo": "13:00 - 14:00",
      "numAsig": "0",
      "descAsig": "",
      "tipoGrupo": "",
      "descTipoGrupo": "",
      "numTipoGrupo": "",
      "horaIniAsig": "",
      "horaFinAsig": "",
      "duracionAsig": "",
      "curso": "",
      "grupo": "",
      "profesores": "",
      "aula": "",
      "edificio": "",
      "asignado": "0",
      "enMediasHoras": "N"
    },
    {
      "dia": "Lunes",
      "fecha": "5 de febrero de 2024",
      "intervalo": "14:00 - 15:00",
      "numAsig": "0",
      "descAsig": "",
      "tipoGrupo": "",
      "descTipoGrupo": "",
      "numTipoGrupo": "",
      "horaIniAsig": "",
      "horaFinAsig": "",
      "duracionAsig": "",
      "curso": "",
      "grupo": "",
      "profesores": "",
      "aula": "",
      "edificio": "",
      "asignado": "0",
      "enMediasHoras": "N"
    },
    {
      "dia": "Lunes",
      "fecha": "5 de febrero de 2024",
      "intervalo": "15:00 - 16:00",
      "numAsig": "0",
      "descAsig": "",
      "tipoGrupo": "",
      "descTipoGrupo": "",
      "numTipoGrupo": "",
      "horaIniAsig": "",
      "horaFinAsig": "",
      "duracionAsig": "",
      "curso": "",
      "grupo": "",
      "profesores": "",
      "aula": "",
      "edificio": "",
      "asignado": "0",
      "enMediasHoras": "N"
    },
    {
      "dia": "Lunes",
      "fecha": "5 de febrero de 2024",
      "intervalo": "16:00 - 17:00",
      "numAsig": "0",
      "descAsig": "",
      "tipoGrupo": "",
      "descTipoGrupo": "",
      "numTipoGrupo": "",
      "horaIniAsig": "",
      "horaFinAsig": "",
      "duracionAsig": "",
      "curso": "",
      "grupo": "",
      "profesores": "",
      "aula": "",
      "edificio": "",
      "asignado": "0",
      "enMediasHoras": "N"
    },
    {
      "dia": "Lunes",
      "fecha": "5 de febrero de 2024",
      "intervalo": "17:00 - 18:00",
      "numAsig": "1",
      "descAsig": "Investigación Operativa",
      "tipoGrupo": "GA",
      "descTipoGrupo": "P. de Aula",
      "numTipoGrupo": "1",
      "horaIniAsig": "17:00",
      "horaFinAsig": "18:00",
      "duracionAsig": "(1h)",
      "curso": "2º curso",
      "grupo": "16 Castellano - Tarde",
      "profesores": "ALVAREZ URQUIOLA, MIKEL",
      "aula": "P5I9A",
      "edificio": "ESCUELA DE INGENIERIA DE BILBAO-EDIFICIO II",
      "asignado": "1",
      "enMediasHoras": "N"
    }
  ]'''));

  assert(x.clases.length == 3);
}
