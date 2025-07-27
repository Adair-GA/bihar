import 'package:bihar/controller/gaur_client.dart';
import 'package:bihar/model/tutorials/subject.dart';
import 'package:bihar/model/tutorials/subject_list.dart';

class TutorialsController {
  static final TutorialsController _instance = TutorialsController._internal();
  SubjectList? _subjectList;

  factory TutorialsController() => _instance;

  TutorialsController._internal();

  Future<List<Subject>> getSubjectList() async {
    _subjectList =
        SubjectList.fromJson(await GaurClient().getSubjectsTutorial());
    // if (_subjectList == null || _subjectList!.subjectList.isEmpty){
    // }
    return _subjectList!.subjectList;
  }
}
