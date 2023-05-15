import 'package:flutter/material.dart';

class GoalsPage extends StatefulWidget{
  const GoalsPage({super.key, required this.title});

  final String title;

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage>{

  // TODO - 
  // Load today's activity records from DB
  // Load the goals set by user and check if they're completed
  // Display some suitable diagrams / messages

  @override
  Widget build(BuildContext context) {
    
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Goals settings',
            ),
          ],
        );
  }
}