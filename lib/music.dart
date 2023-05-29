import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


class MusicPage extends StatelessWidget {
  const MusicPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercise Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
    'https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e6',
    'https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e4',
    'https://thegrowingdeveloper.org/files/audios/quiet-time.mp3?b4869097e7',
  ];
  List<String> songNames = [
    'Song 1',
    'Song 2',
    'Song 3',
  ];
  Map<String, bool> isPlayingMap = {};
  Map<String, bool> isPausedMap = {};

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        currentTrack = '';
        isPlayingMap.clear();
        isPausedMap.clear();
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playMusic(String trackUrl) async {
    if (currentTrack.isNotEmpty) {
      await audioPlayer.stop();
    }

    setState(() {
      currentTrack = trackUrl;
      isPlayingMap[trackUrl] = true;
      isPausedMap[trackUrl] = false;
    });

    await audioPlayer.play(trackUrl, isLocal: true);
  }

  void pauseMusic(String trackUrl) async {
    await audioPlayer.pause();
    setState(() {
      isPausedMap[trackUrl] = true;
    });
  }

  void resumeMusic(String trackUrl) async {
    await audioPlayer.resume();
    setState(() {
      isPausedMap[trackUrl] = false;
    });
  }

  void stopMusic(String trackUrl) async {
    await audioPlayer.stop();
    setState(() {
      currentTrack = '';
      isPlayingMap[trackUrl] = false;
      isPausedMap[trackUrl] = false;
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
              currentTrack.isNotEmpty ? songNames[musicList.indexOf(currentTrack)] : '',
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
                  final isPlaying = isPlayingMap[trackUrl] ?? false;
                  final isPaused = isPausedMap[trackUrl] ?? false;
                  return Card(
                    elevation: 3.0,
                    child: ListTile(
                      title: Text(
                        songNames[index],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: () {
                              if (isPlaying) {
                                if (isPaused) {
                                  resumeMusic(trackUrl);
                                }
                              } else {
                                playMusic(trackUrl);
                              }
                            },
                            color: isPlaying && !isPaused ? Colors.green : Colors.blue,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                          IconButton(
                            icon: Icon(Icons.pause),
                            onPressed: () {
                              if (isPlaying && !isPaused) {
                                pauseMusic(trackUrl);
                              }
                            },
                            color: Colors.orange,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                          IconButton(
                            icon: Icon(Icons.stop),
                            onPressed: () {
                              if (isPlaying || isPaused) {
                                stopMusic(trackUrl);
                              }
                            },
                            color: Colors.red,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                        ],
                      ),
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





















