import 'package:bihar/controller/notas_controller.dart';
import 'package:bihar/controller/profile_controller.dart';
import 'package:bihar/model/nota_provisional.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Marks extends StatefulWidget {
  const Marks({Key? key}) : super(key: key);

  @override
  State<Marks> createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  bool _hasSeenAlert = false;
  Future<List<NotaProvisional>> future =
      NotasController().getNotasProvisionales();
  final String _seenAlertKey =
      "seenAlert${ProfileController().expedienteActivo!.numExpediente}";
  List<bool> _isExpanded = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((instance) {
      setState(() {
        _hasSeenAlert = instance.getBool(_seenAlertKey) ?? false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (BuildContext context,
            AsyncSnapshot<List<NotaProvisional>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}. \n${snapshot.stackTrace}");
            }
            if (snapshot.hasData) {
              if (ProfileController().expedienteActivo?.tipoEnsenanza != 12 &&
                  !_hasSeenAlert) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text("Tipo de grado no soportado"),
                            content: const Text(
                                "Las notas de este tipo de grado todavía no están soportadas por esta aplicación. Aún así, puedes verlas, pero es probable que se muestren con errores."),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    SharedPreferences.getInstance()
                                        .then((instance) {
                                      instance.setBool(_seenAlertKey, true);
                                    });
                                    _hasSeenAlert = true;
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Aceptar"))
                            ],
                          ));
                });
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text("Notas provisionales",
                        style: TextStyle(fontSize: 24)),
                    const Divider(),
                    buildList(snapshot.data!),
                  ],
                ),
              );
            }
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget buildList(List<NotaProvisional> data) {
    if (data.isEmpty) {
      return Center(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "No tienes notas provisionales",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 20),
            ),
          ),
          // Image.asset("assets/img/no_marks.png"),
        ],
      ));
    }

    if (_isExpanded.isEmpty || _isExpanded.length != data.length) {
      _isExpanded = List.filled(data.length, false);
    }

    List<ExpansionPanel> expPanels = [];
    for (var (index, mark) in data.indexed) {
      Widget body;

      if (!mark.hasRevision) {
        body = const ListTile(
          title: Text("La revisión no está disponible"),
        );
      } else {
        body = ListTile(
          title: Text("${mark.fechaRevision} - ${mark.horarioRevision}"),
          subtitle: Text("${mark.profesorRevision}\n${mark.lugarRevision}"),
        );
      }

      expPanels.add(ExpansionPanel(
          isExpanded: _isExpanded[index],
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mark.descAsignatura),
                        Text(
                          mark.definitiva ? "Definitiva" : "Provisional",
                          style: const TextStyle(fontSize: 11),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(mark.getNota())
                ],
              ),
            );
          },
          body: body));
    }

    return SingleChildScrollView(
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = List.filled(_isExpanded.length, false);
            _isExpanded[index] = isExpanded;
          });
        },
        children: expPanels,
      ),
    );
  }
}
