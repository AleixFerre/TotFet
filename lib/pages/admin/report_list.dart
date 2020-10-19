import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totfet/models/Prioritat.dart';
import 'package:totfet/models/Report.dart';
import 'package:totfet/models/Tipus_report.dart';
import 'package:totfet/models/Usuari.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/llista_buida.dart';

class ReportList extends StatefulWidget {
  final List<Report> informes;
  ReportList({this.informes});
  @override
  _ReportListState createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  List<Report> informes;
  bool mostrarOberts = true;

  @override
  void initState() {
    informes = widget.informes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // S'orderna la taula informes pel parametre passat
    // Els mes recents primer

    List<Report> informesMostra = informes.where((report) {
      if (mostrarOberts)
        return report.obert;
      else
        return !report.obert;
    }).toList();

    informesMostra.sort(
      (a, b) {
        return a.dataCreacio.microsecondsSinceEpoch
                .compareTo(b.dataCreacio.microsecondsSinceEpoch) *
            -1;
      },
    );

    return Scaffold(
      appBar: buildAppBar(),
      body: informesMostra.length == 0
          ? LlistaBuida(
              missatge: mostrarOberts
                  ? "No tens informes oberts"
                  : "No tens informes tancats",
              esTaronja: false,
            )
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: informesMostra.length,
              itemBuilder: (context, index) {
                Report informe = informesMostra[index];
                if (mostrarOberts) {
                  return Dismissible(
                    key: GlobalKey(),
                    background: Container(
                      color: Colors.red,
                      child: Center(
                        child: Icon(Icons.close),
                      ),
                    ),
                    onDismissed: (direction) {
                      DatabaseService().tancarInforme(informe.id);
                      setState(() {
                        int index = informes.indexOf(informe);
                        informes[index].obert = false;
                      });
                    },
                    child: mostrarInformeCard(informe),
                  );
                } else {
                  return mostrarInformeCard(informe);
                }
              },
            ),
    );
  }

  String readTimestamp(Timestamp timestamp, bool showHour) {
    if (timestamp == null) return null;

    DateTime date = DateTime.fromMicrosecondsSinceEpoch(
      timestamp.microsecondsSinceEpoch,
    );

    String str = date.day.toString().padLeft(2, "0") +
        "/" +
        date.month.toString().padLeft(2, "0") +
        "/" +
        date.year.toString();

    if (showHour) {
      str += " " +
          date.hour.toString().padLeft(2, "0") +
          ":" +
          date.minute.toString().padLeft(2, "0");
    }

    return str;
  }

  Card mostrarInformeCard(Report informe) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 16.0),
        onTap: () async {
          await mostrarInforme(context, informe);
        },
        title: Text(
          informe.titol,
          overflow: TextOverflow.fade,
          style: TextStyle(fontSize: 20),
        ),
        subtitle: informe.descripcio == "" || informe.descripcio == null
            ? null
            : Text(
                informe.descripcio,
                overflow: TextOverflow.fade,
                style: TextStyle(fontSize: 20),
              ),
        leading: tipusReportIcon(informe.tipus),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () async {
            bool res = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Estas segur de que vols esborrar l'informe?"),
                content: Text("Aquesta acción no es pot desfer! " +
                    "Si l'esborres no el podràs recuperar, però si que podràs crear-ne un de nou exactament igual."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("CANCEL·LAR"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      "ESBORRAR",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            );
            if (res == true) {
              DatabaseService().esborrarInforme(informe.id);
              setState(() {
                informes.remove(informe);
              });
            }
          },
        ),
      ),
    );
  }

  Future mostrarInforme(BuildContext context, Report informe) async {
    String readTimestamp(Timestamp timestamp, bool showHour) {
      if (timestamp == null) return null;

      DateTime date = DateTime.fromMicrosecondsSinceEpoch(
        timestamp.microsecondsSinceEpoch,
      );

      String str = date.day.toString().padLeft(2, "0") +
          "/" +
          date.month.toString().padLeft(2, "0") +
          "/" +
          date.year.toString();

      if (showHour) {
        str += " " +
            date.hour.toString().padLeft(2, "0") +
            ":" +
            date.minute.toString().padLeft(2, "0");
      }

      return str;
    }

    Column showParam(String nom, String param, Widget leading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$nom:",
            style: TextStyle(fontSize: 15),
          ),
          if (param == null || param == "")
            Text(
              "No assignat",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
              ),
            )
          else
            Row(
              children: [
                if (leading != null)
                  Row(
                    children: [
                      leading,
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                Expanded(
                  child: Text(
                    param,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 10),
        ],
      );
    }

    String mostrarNom(String id, String nom) {
      if (id == null) return null;

      if (id == AuthService().userId) {
        return "$nom (Tu)";
      } else {
        return nom;
      }
    }

    DocumentSnapshot data =
        await DatabaseService(uid: informe.autor).getUserDataFuture();
    Usuari autor = Usuari.fromDB(
      data.id,
      null,
      data.data(),
    );

    Usuari tancatPer;

    if (informe.tancatPer != null) {
      data = await DatabaseService(uid: informe.tancatPer).getUserDataFuture();
      tancatPer = Usuari.fromDB(
        data.id,
        null,
        data.data(),
      );
    }

    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                autor.avatar,
                Expanded(child: Container()),
                Text(
                  autor.nom,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container()),
              ],
            ),
            Divider(height: 20),
            showParam("Titol", informe.titol, null),
            showParam("Descripció", informe.descripcio, null),
            showParam(
              "Tipus",
              tipusReportToString(informe.tipus),
              tipusReportIcon(informe.tipus),
            ),
            showParam(
              "Prioritat",
              prioritatToString(informe.prioritat),
              prioritatIcon(informe.prioritat),
            ),
            showParam(
              "Enviat el",
              readTimestamp(informe.dataCreacio, true),
              null,
            ),
            showParam("Obert", informe.obert ? "SI" : "NO", null),
            if (!informe.obert)
              Row(
                children: [
                  showParam(
                    "Tancat Per",
                    mostrarNom(tancatPer.uid, tancatPer.nom),
                    Usuari.getAvatar(
                      tancatPer.nom,
                      tancatPer.uid,
                      false,
                      tancatPer.teFoto,
                    ),
                  ),
                  showParam(
                    "Data de tancament",
                    readTimestamp(informe.dataTancament, true),
                    null,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(mostrarOberts ? "Informes Oberts" : "Informes Tancats"),
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.blue[400],
              Colors.blue[900],
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(mostrarOberts ? Icons.report : Icons.report_off),
          onPressed: () async {
            setState(() {
              mostrarOberts = !mostrarOberts;
            });
          },
        ),
      ],
    );
  }
}
