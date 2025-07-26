import 'package:bihar/controller/timetable_controller.dart';
import 'package:bihar/model/clase.dart';
import 'package:bihar/model/dia.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());
  TextEditingController dateCtl = TextEditingController();
  DateTimeRange? available;
  Future<Dia>? _day;
  final DateFormat _fmt = DateFormat.yMEd();

  @override
  void initState() {
    super.initState();
    TimetableController().getAvailable().then((value) =>
      setState(() {
        available = value;
        if(selectedDate.isBefore(available!.start)){
          selectedDate = available!.start;
        }
      })
    );
  }


  @override
  Widget build(BuildContext context) {
    dateCtl.text = _fmt.format(selectedDate);
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
    if (day.clases.isEmpty){
      return empty();
    }
    return Column(
      children: [
        for (var clase in day.clases)
          getItem(clase),
      ],
    );
  }

  String _getHora(DateTime time){
    DateFormat fm = DateFormat("kk:mm");
    return fm.format(time);
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
                      // locale: const Locale("eu", "ES"),
                    );
                    if (picked != null && picked != selectedDate){
                      setState(() {
                        selectedDate = picked;
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
          });
        }
      case false:
        if (date.add(const Duration(days: 1)).isAfter(available!.end)) {
          return null;
        }
        else {
          return () => setState(() {
            selectedDate = date.add(const Duration(days: 1));
          });
        }
    }
  }

  Widget getItem(Clase clase){
    return InkWell(
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light ? Colors.blue[200] : const Color.fromARGB(255, 48, 144, 168)
        ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Text(_getHora(clase.horaComienzo)),
                    clase.conflict ? const Text(" ⚠️ ") : const Text(" | "),
                    Text(_getHora(clase.horaFin)),
                  ],
                ),
              ),
              Flexible(
                flex: 16,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(clase.nombreAsignatura, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
                      Text(clase.getDesc(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),)
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(clase.aula),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      onTap: () {
        showDialog(context: context, builder:
          (BuildContext context) => AlertDialog(
            title: FittedBox(fit: BoxFit.fitWidth,child: Text(clase.nombreAsignatura)),
            content: Builder(
              builder: (context) {
                var width = MediaQuery.of(context).size.width;

                return SizedBox(
                  width: width + 100,
                  child: Table(
                   columnWidths: const {
                     0: IntrinsicColumnWidth(),
                     1: FixedColumnWidth(16),
                     2: FlexColumnWidth()
                   },
                   border: const TableBorder(verticalInside: BorderSide(color: Color(0x000000FF), width: 3)),
                   children: [
                     TableRow(children: [
                       const Text("Tipo"),
                       const Text(" "),
                       Text(clase.tipo, style: const TextStyle(height: 1.75),)
                     ]),
                     TableRow(children: [
                       const Text("Grupo"),
                       const Text(" "),
                       Text(clase.grupo, style: const TextStyle(height: 1.75),)
                     ]),
                     TableRow(children: [
                       const Text("Profesor"),
                       const Text(" "),
                       Text(clase.profesor, style: const TextStyle(height: 1.75))
                     ]),
                     TableRow(children: [
                       const Text("Lugar"),
                       const Text(" "),
                       Text('${clase.edificio} - ${clase.aula}', style: const TextStyle(height: 1.75))
                     ])
                   ],
                  ),
                 );
            },
            ),
          )
        );
      },
    );
  }

  Widget empty() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text("No tienes clase este dia!", style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 20
            ),),
          ),
          Image.asset("assets/img/day_off.png"),
        ],
      )
    );
  }
}
