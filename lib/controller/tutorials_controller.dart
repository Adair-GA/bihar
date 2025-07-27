import 'package:bihar/controller/gaur_client.dart';
import 'package:bihar/model/tutorials/subject.dart';
import 'package:bihar/model/tutorials/subject_list.dart';

class TutorialsController {
  static final TutorialsController _instance = TutorialsController._internal();
  SubjectList? _subjectList;

  factory TutorialsController() => _instance;

  TutorialsController._internal();

  Future<List<Subject>> getSubjectList() async {
    if (_subjectList == null || _subjectList!.subjectList.isEmpty) {
      _subjectList =
          SubjectList.fromJson(await GaurClient().getSubjectsTutorial());
    }
    return _subjectList!.subjectList;
  }
}
