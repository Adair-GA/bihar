import 'package:bihar/controller/timetable_controller.dart';
import 'package:bihar/model/dia.dart';
import 'package:flutter/material.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());
  TextEditingController dateCtl = TextEditingController();
  DateTimeRange? available;
  Future<Dia>? _day;

  @override
  void initState() {
    super.initState();
    dateCtl.text = "${selectedDate.toLocal()}".split(' ')[0];
    TimetableController().getAvailable().then((value) => 
      setState(() {
        available = value;
      })
    );
  }


  @override
  Widget build(BuildContext context) {
    _day = TimetableController().getDay(selectedDate);
    return Column(
      children: [
        _buildDatePicker(),
        const Divider(),
        _buildTable(),
      ],
    );
  }

  Widget _buildTable() {
    return FutureBuilder(
      future: _day,
      builder: (BuildContext context, AsyncSnapshot<Dia> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        if (snapshot.hasData) {
          return _buildDayTable(snapshot.data!);
        }
        return const Text("Error desconocido");
      },
    );
  }

  Widget _buildDayTable(Dia day) {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Text("Hora"),
            Text("Clase"),
          ]
        ),
        for (var clase in day.clases)
          TableRow(
            children: [
              Text(clase.aula),
              Text(clase.nombreAsignatura),
            ]
          )
      ],
    );
  }
  
  Widget _buildDatePicker() {
    return Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: _getOnPressed(selectedDate, true) as void Function()?,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: dateCtl,
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    border: OutlineInputBorder(),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  readOnly: true,
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: available!.start,
                      lastDate: available!.end,
                      // locale: const Locale("es", "ES"),

                    );
                    if (picked != null && picked != selectedDate){
                      setState(() {
                        selectedDate = picked;
                        dateCtl.text = "${picked.toLocal()}".split(' ')[0];
                      }
                      );
                    }
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed:  _getOnPressed(selectedDate, false) as void Function()?,
            ),
          ],
        );
  }
  
  Function? _getOnPressed(DateTime date, bool left) {
    if (available == null) {
      return null;
    }
    switch (left){
      case true:
        if (date.subtract(const Duration(days: 1)).isBefore(available!.start)) {
          return null;
        }
        else {
          return () => setState(() {
            selectedDate = date.subtract(const Duration(days: 1));
            dateCtl.text = "${selectedDate.toLocal()}".split(' ')[0];
          });
        }
      case false:
        if (date.add(const Duration(days: 1)).isAfter(available!.end)) {
          return null;
        }
        else {
          return () => setState(() {
            selectedDate = date.add(const Duration(days: 1));
            dateCtl.text = "${selectedDate.toLocal()}".split(' ')[0];
          });
        }
    }
  }
}
