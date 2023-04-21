import 'package:fit_buddy/goals.dart';
import 'package:fit_buddy/main.dart';
import 'package:fit_buddy/music.dart';
import 'package:flutter/material.dart';
import 'package:fit_buddy/history.dart';

class BottomNavigator {
  BottomNavigator();

  static navigate(BuildContext context, int index){

    var page;
    switch(index){
      case 0:
        page = const MyHomePage(title:'Home');
        break;

      case 1:
        page = const HistoryPage(title:'History');
        break;

      case 2:
        page = const GoalsPage(title:'Goals');
        break;

      case 3:
        page = const MusicPage(title:'Music');
        break;

      default:
        // this won't be called
        break;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    }));
  }

  static Widget buildBar(BuildContext context, int index){

    return BottomNavigationBar(
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

        currentIndex: index,
        selectedItemColor: Colors.amber[800],
        onTap: ( (index) => navigate(context, index)),
     
    );
  }
}