import 'package:bihar/controller/tutorials_controller.dart';
import 'package:bihar/model/tutorials/subject.dart';
import 'package:bihar/routes/tutorials/teacher_view.dart';
import 'package:flutter/material.dart';

class Tutorials extends StatefulWidget {
  const Tutorials({Key? key}) : super(key: key);

  @override
  State<Tutorials> createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  Future<List<Subject>>? _subjectList;
  List<bool> _isOpen = [];

  @override
  void initState() {
    _subjectList = TutorialsController().getSubjectList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Center(
                child: Text("Tutorías", style: TextStyle(fontSize: 24))),
            const Divider(),
            _subjects()
          ],
        ),
      ),
    );
  }

  Widget _subjects() {
    return FutureBuilder(
        future: _subjectList,
        builder: (BuildContext context, AsyncSnapshot<List<Subject>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.hasData) {
            return _buildList(snapshot.data!);
          }
          return const Text("Error desconocido");
        });
  }

  Widget _buildList(List<Subject> data) {
    if (_isOpen.isEmpty || _isOpen.length != data.length) {
      _isOpen = List.filled(data.length, false);
    }
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isOpen = List.filled(_isOpen.length, false);
          _isOpen[index] = isExpanded;
        });
      },
      materialGapSize: 8,
      children: List.generate(data.length, (i) {
        var subject = data[i];
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(title: Text(subject.name));
          },
          canTapOnHeader: true,
          body: Column(
            children: [
              for (var teacher in subject.teachers)
                ListTile(
                  title: Text(teacher.name),
                  trailing: const Icon(Icons.arrow_circle_right_outlined),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherView(
                                year: subject.year, teacher: teacher)));
                  },
                )
            ],
          ),
          isExpanded: _isOpen[i],
        );
      }),
    );
  }
}
