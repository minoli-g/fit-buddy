import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{

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