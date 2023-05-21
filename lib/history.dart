import 'package:flutter/material.dart';
import 'package:fit_buddy/db.dart';
import 'package:fit_buddy/log.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{

  // TODO - 
  // On opening the page, delete any records older than 2 weeks
  // Display loaded records in a nice graphical format

  List<Log> allRecords = DatabaseAdapter.getAllRecords();

  @override
  Widget build(BuildContext context) {

    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(8),
              itemCount: allRecords.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 50,
                  color: Colors.grey,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(allRecords[index].walkTime.toString(), textAlign: TextAlign.center)
                      ),
                      Expanded(
                        child: Text(allRecords[index].runTime.toString(), textAlign: TextAlign.center)
                      ),
                      Expanded(
                        child: Text(allRecords[index].bicycleTime.toString(), textAlign: TextAlign.center)
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            )
           ],
        );
  }
}