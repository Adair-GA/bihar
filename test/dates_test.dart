

import 'package:bihar/model/clase.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting();
  Clase clase = Clase.fromJson({
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
  });
}
