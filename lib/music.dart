import 'package:flutter/material.dart';

class MusicPage extends StatefulWidget{
  const MusicPage({super.key, required this.title});

  final String title;

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>{

  @override
  Widget build(BuildContext context) {
    
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Music settings',
            ),
          ],
        );
  }
}