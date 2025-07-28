import 'package:bihar/controller/gaur_client.dart';
import 'package:bihar/model/tutorials/month.dart';
import 'package:bihar/model/tutorials/subject.dart';
import 'package:bihar/model/tutorials/subject_list.dart';
import 'package:bihar/model/tutorials/tutorial.dart';
import 'package:flutter/foundation.dart';

class TutorialsController {
  static final TutorialsController _instance = TutorialsController._internal();
  SubjectList? _subjectList;
  final Map<String, List<Month>> _months = {};
  final Map<String, List<Tutorial>> _tutorials = {};

  factory TutorialsController() => _instance;

  TutorialsController._internal();

  Future<List<Subject>> getSubjectList() async {
    if (_subjectList == null || _subjectList!.subjectList.isEmpty) {
      _subjectList =
          SubjectList.fromJson(await GaurClient().getSubjectsTutorial());
    }
    return _subjectList!.subjectList;
  }

  Future<List<Month>> getMonths(
      String year, String dptID, String teacherID) async {
    String cacheKey = year + dptID + teacherID;
    var cachedMonthList = _months[cacheKey];

    if (cachedMonthList != null && !kDebugMode) {
      return cachedMonthList;
    }

    var monthList =
        await GaurClient().getMonthsTutorials(year, teacherID, dptID);
    _months[cacheKey] = monthList;
    return monthList;
  }

  Future<List<Tutorial>> getTutorials(
      String year, String dptID, String teacherID, String monthCode) async {
    String cacheKey = year + dptID + teacherID + monthCode;

    var cachedTutorials = _tutorials[cacheKey];

    if (cachedTutorials != null && !kDebugMode) {
      return cachedTutorials;
    }

    var tutorials =
        await GaurClient().getTutorials(year, teacherID, dptID, monthCode);
    _tutorials[cacheKey] = tutorials;

    return tutorials;
  }
}
