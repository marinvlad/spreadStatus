import 'package:covid/country.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Grafic extends StatefulWidget {
  final Country country;
  Grafic({this.country});
  @override
  _GraficState createState() => _GraficState();
}

class _GraficState extends State<Grafic> {
  List<FlSpot> recovered = [];
  List<FlSpot> death = [];
  List<FlSpot> confirmed = [];

  void getData(){
    try{
    List<Map<String, dynamic>> data = widget.country.getData();
      for(var day in data){
        setState(() {
          recovered.add(FlSpot(data.indexOf(day).toDouble(),double.parse(day["recovered"].toString())));
          death.add(FlSpot(data.indexOf(day).toDouble(),double.parse(day["deaths"].toString())));
          confirmed.add(FlSpot(data.indexOf(day).toDouble(),double.parse(day["confirmed"].toString())));
        });
      }
    }catch(e){
      print(e.getMessage());
    }
  }
  List<Color> healedColor = [
     Color(0xff11998e),
     Color(0xff38ef7d)
  ];
  List<Color> deadColor = [
     Color(0xff12c2e9),
     Color(0xfff64f59)
  ];
  List<Color> confirmedColor = [
      Color(0xffFF8C00),
      Color(0xffFF0080)
  ];

  bool showAvg = false;
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(18),
            ),
            ),
        child: 
        widget.country.getData().length!=0?
        LineChart(
          mainData(),
        ):Center(child: Text("Insuficient data",style: TextStyle(
          color: Colors.white,fontSize: 30,fontWeight: FontWeight.w100
        ),)),
      ),
    );
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: true,
      ),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: false,
      ),
      borderData:
          FlBorderData(show: false, ),
      minX: 0,
      maxX: widget.country.getData().length-1.toDouble(),
      minY: 0,
      maxY: widget.country.getConfirmed().toDouble(),
      lineBarsData: [
        LineChartBarData(
          spots: recovered,
          isCurved: true,
          colors: healedColor,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
            dotColor: Colors.green
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: healedColor.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
        LineChartBarData(
          spots: confirmed,
          isCurved: true,
          colors: confirmedColor,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
            dotColor: Colors.red
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: confirmedColor.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
        LineChartBarData(
          spots: death,
          isCurved: true,
          colors: deadColor,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: deadColor.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }
}