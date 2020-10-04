import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totfet/models/Prioritat.dart';
import 'package:totfet/models/Report.dart';
import 'package:totfet/models/TipusReport.dart';
import 'package:totfet/models/Usuari.dart';
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
  @override
  void initState() {
    informes = widget.informes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Informes"),
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
      ),
      body: informes.length == 0
          ? LlistaBuida(esTaronja: false)
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: informes.length,
              itemBuilder: (context, index) {
                Report informe = informes[index];
                return Dismissible(
                  key: GlobalKey(),
                  background: Container(
                    color: Colors.red,
                    child: Center(
                      child: Icon(Icons.delete),
                    ),
                  ),
                  onDismissed: (direction) {
                    DatabaseService().esborrarInforme(informe.id);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    elevation: 3,
                    child: ListTile(
                      onTap: () async {
                        DocumentSnapshot data =
                            await DatabaseService(uid: informe.autor)
                                .getUserDataFuture();
                        Usuari autor = Usuari.fromDB(
                          data.id,
                          null,
                          data.data(),
                        );
                        showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0),
                            ),
                          ),
                          context: context,
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
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(child: Container()),
                                  ],
                                ),
                                Divider(
                                  height: 20,
                                ),
                                Text(
                                  "Titol",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  informe.titol,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "Descripció",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  informe.descripcio,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "Tipus",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    tipusReportIcon(informe.tipus),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      tipusReportToString(informe.tipus),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Text(
                                  "Prioritat",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    prioritatIcon(informe.prioritat),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      prioritatToString(informe.prioritat),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                                Text(
                                  "Enviat el",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                informe.dataCreacio == null
                                    ? Text(
                                        "No assignat",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      )
                                    : Text(
                                        readTimestamp(
                                            informe.dataCreacio, true),
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                      title: Text(
                        informe.titol,
                        overflow: TextOverflow.fade,
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle:
                          informe.descripcio == "" || informe.descripcio == null
                              ? null
                              : Text(
                                  informe.descripcio,
                                  overflow: TextOverflow.fade,
                                  style: TextStyle(fontSize: 20),
                                ),
                      leading: tipusReportIcon(informe.tipus),
                      trailing: prioritatIcon(informe.prioritat),
                    ),
                  ),
                );
              }),
    );
  }
}
