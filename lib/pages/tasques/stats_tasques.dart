import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:totfet/models/Indicator.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/loading.dart';
import 'package:totfet/shared/some_error_page.dart';

class StatsTasques extends StatelessWidget {
  bool totsSonZero(dataTasques) {
    return dataTasques["creades"] == 0 &&
        dataTasques["fetes"] == 0 &&
        dataTasques["assignades"] == 0;
  }

  Column showParam(String nom, double param) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$nom:",
          style: TextStyle(fontSize: 15),
        ),
        if (param == null)
          Text(
            "No disponible",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${param.floor()}",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Text(
                (param.floor() == 1) ? " tasca" : " tasques",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: DatabaseService().getAllTasques(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomeErrorPage(error: snapshot.error);
        }

        if (snapshot.hasData) {
          final Map<String, double> dataTasques = {
            "creades": 0,
            "fetes": 0,
            "assignades": 0,
          };
          final String uid = AuthService().userId;
          snapshot.data.docs.forEach((element) {
            if (element.data()["idCreador"] == uid) {
              dataTasques["creades"]++;
            }
            if (element.data()["idAssignat"] == uid) {
              dataTasques["assignades"]++;
            }
            if (element.data()["idUsuariFet"] == uid) {
              dataTasques["fetes"]++;
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: Text("Les meves Tasques"),
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
            body: SingleChildScrollView(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  showParam("Has creat", dataTasques["creades"]),
                  showParam("Has fet", dataTasques["fetes"]),
                  showParam("Estàs assignat a", dataTasques["assignades"]),
                  if (!totsSonZero(dataTasques)) PieChartTasques(dataTasques),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Loading(msg: "Carregant estadístiques", esTaronja: false),
        );
      },
    );
  }
}

class PieChartTasques extends StatefulWidget {
  PieChartTasques(this.dataTasques);
  final Map<String, double> dataTasques;
  @override
  State<StatefulWidget> createState() => PieChartTasquesState();
}

class PieChartTasquesState extends State<PieChartTasques> {
  int touchedIndex;
  Map<String, double> data;
  double total;

  @override
  void initState() {
    super.initState();
    data = widget.dataTasques;
    total = data["creades"] + data["fetes"] + data["assignades"];
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Indicator(
                  color: Color(0xff0293ee),
                  text: 'Creades',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'Fetes',
                  isSquare: false,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xff845bef),
                  text: 'Assignades',
                  isSquare: false,
                ),
                SizedBox(
                  height: 18,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  String percent(double part) {
    return "${(part / total * 100).floor()}%";
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(data.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: data["creades"],
            title: percent(data["creades"]),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: data["fetes"],
            title: percent(data["fetes"]),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xff845bef),
            value: data["assignades"],
            title: percent(data["assignades"]),
            radius: radius,
            titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff)),
          );
        default:
          return null;
      }
    });
  }
}
