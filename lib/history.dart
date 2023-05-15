import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{

  // TODO - 
  // On opening the page, delete any records older than 2 weeks
  // Load the remaining records and display in a nice graphical format

  @override
  Widget build(BuildContext context) {
    
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Your exercise history will appear here',
            ),
          ],
        );
  }
}