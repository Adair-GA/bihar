import 'package:flutter/material.dart';

class TimeTable extends StatefulWidget {
  const TimeTable({Key? key}) : super(key: key);
  
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  DateTime selectedDate = DateUtils.dateOnly(DateTime.now());
  TextEditingController dateCtl = TextEditingController();


  @override
  Widget build(BuildContext context) {
    dateCtl.text = "${selectedDate.toLocal()}".split(' ')[0];
    return Column(
      children: [
        Row(
          children: [
            const IconButton(
              icon: Icon(Icons.arrow_back_ios),
              // onPressed: expediente > 1 ? () => setState(() {expediente--; GaurController().setExpediente(expediente - 1);} ) : null,
              onPressed: null,
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
                      firstDate: DateTime(2015, 8),
                      lastDate: DateTime(2101),
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
            const IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              // onPressed: expediente < cantExpedientes ? () => setState(() {expediente++; GaurController().setExpediente(expediente - 1);})  : null,
              onPressed: null,
            ),
          ],
          ),
        const Divider(),
        _buildTable(),
      ],
    );
  }

  Widget _buildTable() {
    return Table(
      border: TableBorder.all(),
      children: [
        TableRow(
          children: [
            Text("Hora"),
            Text("Clase"),
          ]
        )
      ],
    );
  }
}
