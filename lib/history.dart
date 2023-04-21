import 'package:flutter/material.dart';
import 'package:fit_buddy/navbar.dart';

class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key, required this.title});

  final String title;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>{

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Your exercise history will appear here',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator.buildBar(
        context, 1
      ),
    );
  }
}