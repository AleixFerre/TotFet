import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:totfet/models/Prioritat.dart';
import 'package:totfet/models/Report.dart';
import 'package:totfet/models/Tipus_report.dart';
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
    // S'orderna la taula informes pel parametre passat
    // Els mes recents primer
    informes.sort(
      (a, b) {
        return a.dataCreacio.microsecondsSinceEpoch
                .compareTo(b.dataCreacio.microsecondsSinceEpoch) *
            -1;
      },
    );
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
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
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
                        await mostrarInforme(context, informe);
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
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          SizedBox(height: 20),
        ],
      );
    }

    DocumentSnapshot data =
        await DatabaseService(uid: informe.autor).getUserDataFuture();
    Usuari autor = Usuari.fromDB(
      data.id,
      null,
      data.data(),
    );

    return showModalBottomSheet(
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
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Expanded(child: Container()),
              ],
            ),
            Divider(
              height: 20,
            ),
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
          ],
        ),
      ),
    );
  }
}
