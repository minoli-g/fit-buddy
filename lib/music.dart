import 'package:flutter/material.dart';

class MusicPage extends StatefulWidget{
  const MusicPage({super.key, required this.title});

  final String title;

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>{

  // TODO - 
  // Load and display the playlists (just song names) for each activity type
  // Input to allow user to add/remove songs 
  // Will need to include some tunes as defaults

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