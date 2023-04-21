import 'package:flutter/material.dart';
import 'package:fit_buddy/navbar.dart';

class MusicPage extends StatefulWidget{
  const MusicPage({super.key, required this.title});

  final String title;

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage>{

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
              'Music settings',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigator.buildBar(
        context, 3
      ),
    );
  }
}