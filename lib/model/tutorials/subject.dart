import 'package:bihar/model/tutorials/teacher.dart';

class Subject {
  final String _name;
  final String _yearCode;
  final List<Teacher> _teacherList = [];

  Subject(this._name, this._yearCode);

  String get name {
    return _name;
  }

  String get year {
    return _yearCode;
  }

  void addTeacher(Teacher teacher) {
    _teacherList.add(teacher);
  }

  List<Teacher> get teachers {
    return List.unmodifiable(_teacherList);
  }
}
