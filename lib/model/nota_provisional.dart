class NotaProvisional{
  double?    nota;
  String? descCalificacion;
  String? descPlan;
  String? descCiclo;
  String? descCurso;
  String? descAsignatura;
  String  descConvocatoria;
  bool    definitiva;
  String? profesorRevision;
  String? fechaRevision;
  String? horarioRevision;
  String? lugarRevision;
  // lo de la prueba... se queda pa otro momento
  // String? fechaPrueba;


  factory NotaProvisional.fromJson(dynamic json){
    return NotaProvisional(
      double.tryParse(
      json["valorCalificacion"]),
      json["descPlan"],
      json["descCiclo"],
      json["descCurso"],
      json["descAsignatura"],
      json["descConvocatoria"],
      json["esDefinitiva"] == "1",
      json["fedatarios"],
      json["fIniRevision"],
      json["horario"],
      json["lugarRevision"],
    );
  }

  NotaProvisional(
    this.nota,
    this.descPlan,
    this.descCiclo,
    this.descCurso,
    this.descAsignatura,
    this.descConvocatoria,
    this.definitiva,
    this.profesorRevision,
    this.fechaRevision,
    this.horarioRevision,
    this.lugarRevision,
  );

  String getNota(){
    if(nota == null){
      return descCalificacion ?? "Sin calificar";
    }
    return nota.toString();
  }
}