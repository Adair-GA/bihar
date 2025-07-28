import 'package:bihar/controller/gaur_client.dart';
import 'package:bihar/controller/tutorials_controller.dart';
import 'package:bihar/model/tutorials/teacher.dart';
import 'package:flutter/material.dart';

import '../../model/tutorials/month.dart';
import '../../model/tutorials/tutorial.dart';

class TeacherView extends StatefulWidget {
  final Teacher teacher;
  final String year;

  const TeacherView({Key? key, required this.year, required this.teacher})
      : super(key: key);

  @override
  State<TeacherView> createState() => _TeacherViewState();
}

class _TeacherViewState extends State<TeacherView> {
  Future<List<Month>>? _monthListFuture;

  Future<List<Tutorial>>? _tutorials;
  Month? _selectedMonth;
  List<bool> _isExpanded = [];

  @override
  void initState() {
    _monthListFuture = TutorialsController().getMonths(
        widget.year, widget.teacher.codDpto, widget.teacher.idpProfesor);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title:
              FittedBox(fit: BoxFit.fitWidth, child: Text(widget.teacher.name)),
        ),
        body: FutureBuilder(
            future: _monthListFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
              if (snapshot.hasData) {
                return _buildDateSelector(snapshot.data!);
              }
              return const Text("Error desconocido");
            }));
  }

  Widget _buildDateSelector(List<Month> monthList) {
    if (monthList.isEmpty) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child: Text(
            "⚠️",
            style: TextStyle(fontSize: 80),
          )),
          Text(
            "No hay tutorías disponibles",
            style: TextStyle(fontSize: 28),
          ),
        ],
      );
    }
    _selectedMonth ??= monthList.first;

    _tutorials ??= GaurClient().getTutorials(
        widget.year,
        widget.teacher.idpProfesor,
        widget.teacher.codDpto,
        _selectedMonth!.code);

    var tutorialBuilder = FutureBuilder(
        future: _tutorials,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.hasData) {
            return _buildTutorialList(snapshot.data!);
          }
          return const Text("Error desconocido");
        });

    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: DropdownButton(
              value: _selectedMonth,
              items: monthList.map<DropdownMenuItem<Month>>((month) {
                return DropdownMenuItem<Month>(
                    value: month, child: Text(month.name));
              }).toList(),
              onChanged: (Month? value) {
                setState(() {
                  _selectedMonth = value!;
                });
              },
            ),
          ),
          const Divider(),
          tutorialBuilder
        ],
      ),
    );
  }

  Widget _buildTutorialList(List<Tutorial> tutorials) {
    Map<String, List<Tutorial>> tutorialDays = {};
    for (var tutorial in tutorials) {
      tutorialDays[tutorial.dateName] ??= [];
      tutorialDays[tutorial.dateName]!.add(tutorial);
    }

    if (_isExpanded.isEmpty || _isExpanded.length != tutorialDays.length) {
      _isExpanded = List.filled(tutorialDays.length, false);
    }

    return ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded[index] = isExpanded;
          });
        },
        materialGapSize: 8,
        children: [
          for (var (i, day) in tutorialDays.values.indexed)
            ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return ListTile(title: Text(day[0].dateName));
                },
                isExpanded: _isExpanded[i],
                canTapOnHeader: true,
                body: Column(
                  children: [
                    for (var time in day)
                      ListTile(
                        title: Text("${time.startDate} - ${time.endDate}"),
                        subtitle: Text("${time.place}\n${time.building}"),
                        isThreeLine: true,
                      )
                  ],
                ))
        ]);
  }
}
