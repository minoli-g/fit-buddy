import 'package:flutter/material.dart';
import 'package:fit_buddy/db.dart';
import 'package:fit_buddy/log.dart';

import 'package:fl_chart/fl_chart.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{

  late List<Log> allRecords;

  @override
  void initState(){
    super.initState();

    // Loads an empty record for the current day if no activity
    DatabaseAdapter.getCurrentDailyActivity();

    // Deletes records older than 2 weeks (14 days)
    DatabaseAdapter.deleteOldRecords();

    // Initializes the record list
    allRecords = DatabaseAdapter.getAllRecords();
  }


  Widget getTrendGraph(){

    List<FlSpot> walkTimes = [];
    List<FlSpot> runTimes = [];
    List<FlSpot> bicycleTimes = [];

    for (int i=0; i<allRecords.length; i++){

      Log l = allRecords[i];

      walkTimes.add(FlSpot( i.toDouble(), l.walkTime.toDouble()));
      runTimes.add(FlSpot( i.toDouble(), l.runTime.toDouble()));
      bicycleTimes.add(FlSpot( i.toDouble(), l.bicycleTime.toDouble()));
    }

    return  Container(
          padding: const EdgeInsets.only(top:15, bottom:15, right:15),
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          height: 280,
          child: LineChart(
            LineChartData(
              borderData: FlBorderData(show: false), 
              gridData: FlGridData( show: false),
              lineBarsData: [
                LineChartBarData(spots: walkTimes, color: Colors.blue),
                LineChartBarData(spots: runTimes, color: Colors.pink),
                LineChartBarData(spots: bicycleTimes, color: Colors.purple),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(axisNameWidget: const Text("Minutes"), sideTitles: SideTitles(showTitles: true, reservedSize:30)),
                bottomTitles: AxisTitles(axisNameWidget: const Text("Day"), sideTitles: SideTitles(showTitles: true, interval: 2)),
                topTitles: AxisTitles( sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
    );
  }

  Widget getHistoryList(){
    return ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: allRecords.length,
              itemBuilder: (BuildContext context, int index) {
                int reverseIndex = allRecords.length - index - 1;
                return Column(
                  children: [
                    Container (
                      height: 20,
                      child: Row (
                        children: [
                          Expanded (
                            child: Text (allRecords[reverseIndex].date.toString().substring(0,10))
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 50,
                      color: Colors.grey.shade200,
                      child: Row(
                        children: [
                          Expanded(
                            child: Row (
                              children: [
                                const Icon (Icons.directions_walk),
                                Text("${allRecords[reverseIndex].walkTime} min", textAlign: TextAlign.center)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row (
                              children: [
                                const Icon (Icons.directions_run),
                                Text("${allRecords[reverseIndex].runTime} min", textAlign: TextAlign.center)
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row (
                              children: [
                                const Icon (Icons.directions_bike),
                                Text("  ${allRecords[reverseIndex].bicycleTime} min", textAlign: TextAlign.center)
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            );
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView (
      child : 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getTrendGraph(),
            Container(
              padding: const EdgeInsets.only(left:10, right:10), height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: Row (
                      children: const [
                        Icon (Icons.directions_walk, color: Colors.blue),
                        Text("  Walking", textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row (
                      children: const [
                        Icon (Icons.directions_run, color: Colors.pink),
                        Text("  Running", textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row (
                      children: const[
                          Icon (Icons.directions_bike, color: Colors.purple),
                        Text("  Bicycling", textAlign: TextAlign.center)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
            getHistoryList()
           ],
        )
    );
  }
}