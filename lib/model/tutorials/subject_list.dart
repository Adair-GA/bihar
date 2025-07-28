import 'package:bihar/model/tutorials/subject.dart';
import 'package:bihar/model/tutorials/teacher.dart';

class SubjectList {
  List<Subject> _subjectList;

  factory SubjectList.fromJson(dynamic json) {
    Map<String, Subject> subjectMap = {};
    if (json.isNotEmpty) {
      for (var subjectJSON in json) {
        String teacherName = subjectJSON["nomProfesor"];
        String subjectName = subjectJSON["descAsignatura"];
        String subjectCode = subjectJSON["codAsignatura"];

        var subject = subjectMap[subjectCode];
        subject ??= Subject(subjectName, subjectJSON["anyAcademico"]);
        subject.addTeacher(Teacher(
            teacherName, subjectJSON["codDpto"], subjectJSON["idpProfesor"]));
        subjectMap[subjectCode] = subject;
      }
    }
    return SubjectList(List.from(subjectMap.values));
  }

  SubjectList(this._subjectList);

  List<Subject> get subjectList {
    return List.unmodifiable(_subjectList);
  }
}
