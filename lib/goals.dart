import 'package:flutter/material.dart';

class GoalsPage extends StatefulWidget{
  const GoalsPage({super.key, required this.title});

  final String title;

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage>{

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