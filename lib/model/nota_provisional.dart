class NotaProvisional {
  double? nota;
  String? descCalificacion;
  String? descPlan;
  String? descCiclo;
  String? descCurso;
  String descAsignatura;
  String? descConvocatoria;
  bool definitiva;
  String? profesorRevision;
  String? fechaRevision;
  String? horarioRevision;
  String? lugarRevision;
  bool _hasRevision;
  // lo de la prueba... se queda pa otro momento
  // String? fechaPrueba;

  factory NotaProvisional.fromJson(dynamic json) {
    String? calificacion = json["valorCalificacion"];
    calificacion ??= "";
    return NotaProvisional(
      double.tryParse(calificacion),
      json["descCalificacion"],
      json["descPlan"],
      json["descCiclo"],
      json["descCurso"],
      json["descAsignatura"],
      json["descConvocatoria"],
      json["esDefinitiva"] == "1",
      json["fedatarios"],
      json["fFinRevision"],
      json["horario"],
      json["lugarRevision"],
      json["verRevision"] == "1",
    );
  }

  NotaProvisional(
    this.nota,
    this.descCalificacion,
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
    this._hasRevision,
  );

  String getNota() {
    if (nota == null) {
      return descCalificacion ?? "Sin calificar";
    }
    return "$descCalificacion(${nota.toString()})";
  }

  get hasRevision {
    return _hasRevision;
  }
}
