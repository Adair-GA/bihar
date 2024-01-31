import 'package:flutter/material.dart';

class UserProfile{
  String nombre;
  String dni;
  String facultad;
  String grado;
  Image? foto;

  UserProfile(this.nombre, this.dni, this.facultad, this.grado, this.foto);
}