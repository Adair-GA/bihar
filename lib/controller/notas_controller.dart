class NotasController{
  static final NotasController _instance = NotasController._internal(); 
  factory NotasController() => _instance;
  NotasController._internal();

  //Si el tipo de enseñanza es 5 o 6, mostrar descPlan en vez de descAsignatura
  //La calificacion puede traer solo descCalificacion sin valorCalificacion
  //if (tipoEnse == "1" || tipoEnse == "2" || tipoEnse == "4"), mostrar item.descCiclo, item.descCurso, item.descConvocatoria, nota, definitiva
  //if (tipoEnse == "12") lo mismo pero sin descCiclo
  //si es 5 o 6 mostrar solo calificacion y si es definitiva
  //si no, item.descConvocatoria, nota y definitiva
  //todos estos pueden o no traer info sobre la revisión, según si verRevision==1
  //tambien hay pruebas. pueden traer o no calificaion
  //puede que haya más de una prueba (tal vez? el codigo no es muy claro) 
}