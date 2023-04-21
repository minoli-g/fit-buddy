import 'package:flutter/material.dart';
import 'package:fit_buddy/navbar.dart';

class GoalsPage extends StatefulWidget{
  const GoalsPage({super.key, required this.title});

  final String title;

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage>{

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
              'Goals settings',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator.buildBar(
        context, 2
      ),
    );
  }
}