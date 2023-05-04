import 'package:flutter/material.dart';
import 'package:fit_buddy/goals.dart';
import 'package:fit_buddy/music.dart';
import 'package:fit_buddy/history.dart';
import 'package:fit_buddy/activity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fit Buddy: Home',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Fit Buddy: Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  late List<Widget> widgetOptions;

  @override
  void initState(){
    super.initState();
    widgetOptions = [
      const ActivityPage(title: "Counter"),
      const HistoryPage(title: "History"),
      const GoalsPage(title: "Goals"),
      const MusicPage(title: "Music")
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: IndexedStack(
        alignment: Alignment.centerRight,
        index: selectedIndex,
        children: widgetOptions
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: 
          const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Goals',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Music',
            ),
          ],

          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: onItemTapped,
      
      )
    );
  }
}
