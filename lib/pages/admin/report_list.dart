import 'package:flutter/material.dart';
import 'package:totfet/models/Prioritat/Prioritat.dart';
import 'package:totfet/models/Report.dart';
import 'package:totfet/models/TipusReport.dart';
import 'package:totfet/services/database.dart';

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
      body: ListView.builder(
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
