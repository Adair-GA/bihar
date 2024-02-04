import 'package:bihar/model/expediente.dart';

class UserProfile{
  String nombre;
  String dni;
  String? foto;
  List<Expediente> expedientes;

  UserProfile(this.nombre, this.dni, this.foto, this.expedientes);
}