// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
//
//
// class MusicPage extends StatelessWidget {
//   const MusicPage({super.key, required this.title});
//
//   final String title;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Exercise Music',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: ExerciseMusicScreen(),
//     );
//   }
// }
//
// class ExerciseMusicScreen extends StatefulWidget {
//   @override
//   _ExerciseMusicScreenState createState() => _ExerciseMusicScreenState();
// }
//
// class _ExerciseMusicScreenState extends State<ExerciseMusicScreen> {
//   AudioPlayer audioPlayer = AudioPlayer();
//   String currentTrack = '';
//   List<String> musicList = [
//     'assets/hip-hop-rock-beats-118000.mp3',
//     'assets/passion-127011.mp3',
//     'assets/order-99518.mp3',
//   ];
//   List<String> songNames = [
//     'Song 1',
//     'Song 2',
//     'Song 3',
//   ];
//   Map<String, bool> isPlayingMap = {};
//   Map<String, bool> isPausedMap = {};
//
//   @override
//   void initState() {
//     super.initState();
//     audioPlayer.onPlayerCompletion.listen((event) {
//       setState(() {
//         currentTrack = '';
//         isPlayingMap.clear();
//         isPausedMap.clear();
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }
//
//   void playMusic(String trackUrl) async {
//     if (currentTrack.isNotEmpty) {
//       await audioPlayer.stop();
//     }
//
//     setState(() {
//       currentTrack = trackUrl;
//       isPlayingMap[trackUrl] = true;
//       isPausedMap[trackUrl] = false;
//     });
//
//     await audioPlayer.play(trackUrl, isLocal: true);
//   }
//
//   void pauseMusic(String trackUrl) async {
//     await audioPlayer.pause();
//     setState(() {
//       isPausedMap[trackUrl] = true;
//     });
//   }
//
//   void resumeMusic(String trackUrl) async {
//     await audioPlayer.resume();
//     setState(() {
//       isPausedMap[trackUrl] = false;
//     });
//   }
//
//   void stopMusic(String trackUrl) async {
//     await audioPlayer.stop();
//     setState(() {
//       currentTrack = '';
//       isPlayingMap[trackUrl] = false;
//       isPausedMap[trackUrl] = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Exercise Music')),
//       body: Container(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               'Current Track:',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8.0),
//             Text(
//               currentTrack.isNotEmpty ? songNames[musicList.indexOf(currentTrack)] : '',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 20.0),
//             Text(
//               'Choose Exercise Music',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20.0),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: musicList.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final trackUrl = musicList[index];
//                   final isPlaying = isPlayingMap[trackUrl] ?? false;
//                   final isPaused = isPausedMap[trackUrl] ?? false;
//                   return Card(
//                     elevation: 3.0,
//                     child: ListTile(
//                       title: Text(
//                         songNames[index],
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           IconButton(
//                             icon: Icon(Icons.play_arrow),
//                             onPressed: () {
//                               if (isPlaying) {
//                                 if (isPaused) {
//                                   resumeMusic(trackUrl);
//                                 }
//                               } else {
//                                 playMusic(trackUrl);
//                               }
//                             },
//                             color: isPlaying && !isPaused ? Colors.green : Colors.blue,
//                             highlightColor: Colors.transparent,
//                             splashColor: Colors.transparent,
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.pause),
//                             onPressed: () {
//                               if (isPlaying && !isPaused) {
//                                 pauseMusic(trackUrl);
//                               }
//                             },
//                             color: Colors.orange,
//                             highlightColor: Colors.transparent,
//                             splashColor: Colors.transparent,
//                           ),
//                           IconButton(
//                             icon: Icon(Icons.stop),
//                             onPressed: () {
//                               if (isPlaying || isPaused) {
//                                 stopMusic(trackUrl);
//                               }
//                             },
//                             color: Colors.red,
//                             highlightColor: Colors.transparent,
//                             splashColor: Colors.transparent,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

Map audioData = {
  'image': 'https://thegrowingdeveloper.org/thumbs/1000x1000r/audios/quiet-time-photo.jpg',
  'url': 'https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e4'
};

class MusicPage extends StatelessWidget {
  const MusicPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Music',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ExerciseMusicScreen(),
    );
  }
}

class ExerciseMusicScreen extends StatefulWidget {
  @override
  _ExerciseMusicScreenState createState() => _ExerciseMusicScreenState();
}

class _ExerciseMusicScreenState extends State<ExerciseMusicScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  String currentTrack = '';
  List<String> musicList = [
    'assets/hip-hop-rock-beats-118000.mp3',
    'assets/passion-127011.mp3',
    'assets/order-99518.mp3',
  ];
  List<String> songNames = [
    'Song 1',
    'Song 2',
    'Song 3',
  ];
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        currentTrack = '';
        currentIndex = -1;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic(String trackUrl, int index) async {
    if (currentTrack.isNotEmpty) {
      await audioPlayer.stop();
    }

    setState(() {
      currentTrack = trackUrl;
      currentIndex = index;
    });

    await audioPlayer.play(trackUrl, isLocal: true);
  }

  Future<void> pauseMusic() async {
    await audioPlayer.pause();
  }

  Future<void> resumeMusic() async {
    await audioPlayer.resume();
  }

  Future<void> stopMusic() async {
    await audioPlayer.stop();
    setState(() {
      currentTrack = '';
      currentIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercise Music')),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Current Track:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              currentTrack.isNotEmpty ? songNames[currentIndex] : '',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20.0),
            Text(
              'Choose Exercise Music',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Expanded(
              child: ListView.builder(
                itemCount: musicList.length,
                itemBuilder: (BuildContext context, int index) {
                  final trackUrl = musicList[index];
                  final isPlaying = currentTrack == trackUrl;
                  return ListTile(
                    title: Text(
                      songNames[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                          onPressed: () {
                            if (isPlaying) {
                              stopMusic();
                            } else {
                              playMusic(trackUrl, index);
                            }
                          },
                          color: isPlaying ? Colors.red : Colors.blue,
                        ),
                        SizedBox(width: 8.0),
                        IconButton(
                          icon: Icon(Icons.pause),
                          onPressed: isPlaying ? pauseMusic : null,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

