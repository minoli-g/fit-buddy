import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fit_buddy/db.dart';
import 'package:fit_buddy/log.dart';
import 'dart:async';
import 'dart:io';

enum ExerciseType { walking, running, cycling }

class ExerciseGoal {
  int id;
  ExerciseType type;
  int duration;
  int repetitions;

  ExerciseGoal({
    required this.id,
    required this.type,
    required this.duration,
    required this.repetitions,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.toString(),
      'duration': duration,
      'repetitions': repetitions,
    };
  }

  factory ExerciseGoal.fromMap(Map<String, dynamic> map) {
    return ExerciseGoal(
      id: map['id'],
      type: ExerciseType.values.firstWhere((type) => type.toString() == map['type']),
      duration: map['duration'],
      repetitions: map['repetitions'],
    );
  }
}

class DatabaseHelper {
  static Database? _database;
  static final String _tableName = 'exercise_goals';
  static final String _columnId = 'id';
  static final String _columnType = 'type';
  static final String _columnDuration = 'duration';
  static final String _columnRepetitions = 'repetitions';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/exercise_goals.db';

    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnType TEXT,
        $_columnDuration INTEGER,
        $_columnRepetitions INTEGER
      )
    ''');
  }

  Future<int> insertGoal(ExerciseGoal goal) async {
    Database db = await database;
    return db.insert(_tableName, goal.toMap());
  }

  Future<List<ExerciseGoal>> getGoals() async {
    Database db = await database;
    List<Map<String, dynamic>> goals = await db.query(_tableName);
    return goals.map((map) => ExerciseGoal.fromMap(map)).toList();
  }

  Future<int> deleteGoal(int id) async {
    Database db = await database;
    return db.delete(_tableName, where: '$_columnId = ?', whereArgs: [id]);
  }
}

class GoalsPage extends StatefulWidget {

  const GoalsPage({super.key, required this.title});
  final String title;
  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<ExerciseGoal> exerciseGoals = [];
  ExerciseType selectedType = ExerciseType.walking;
  TextEditingController durationController = TextEditingController();
  TextEditingController repetitionsController = TextEditingController();

  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    loadExerciseGoals();
  }

  void loadExerciseGoals() async {
    List<ExerciseGoal> goals = await databaseHelper.getGoals();
    setState(() {
      exerciseGoals = goals;
    });
  }

  void addExerciseGoal() async {
    int duration = int.parse(durationController.text);
    int repetitions = int.parse(repetitionsController.text);

    ExerciseGoal newGoal = ExerciseGoal(
      id: DateTime.now().millisecondsSinceEpoch,
      type: selectedType,
      duration: duration,
      repetitions: repetitions,
    );
    await databaseHelper.insertGoal(newGoal);

    setState(() {
      exerciseGoals.add(newGoal);
    });

    durationController.clear();
    repetitionsController.clear();
  }

  void removeExerciseGoal(int index) async {
    ExerciseGoal goal = exerciseGoals[index];
    await databaseHelper.deleteGoal(goal.id);

    setState(() {
      exerciseGoals.removeAt(index);
    });
  }

  bool checkAccomplished(ExerciseGoal goal) {
    Log dailyRecord = DatabaseAdapter.getCurrentDailyActivity();

    switch (goal.type){
      case ExerciseType.walking:
        if (dailyRecord.walkTime >= goal.duration * goal.repetitions){
          return true;
        }
        break;
      case ExerciseType.running:
        if (dailyRecord.runTime >= goal.duration * goal.repetitions){
          return true;
        }
        break;
      case ExerciseType.cycling:
        if (dailyRecord.bicycleTime >= goal.duration * goal.repetitions){
          return true;
        }
        break;
    }
    return false;
  }

  Padding checkAccomplishedText(ExerciseGoal goal){
    String str;
    Color color;
    if (checkAccomplished(goal)){
      str = "Goal fulfilled! Congratulations.";
      color = Colors.green;
    }
    else{
      str = "Not done yet! Keep going.";
      color = Colors.red;
    }
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
            str,
            style: DefaultTextStyle.of(context).style.apply(color: color)
        )
    );
  }

  Icon checkAccomplishedIcon(ExerciseGoal goal){
    if (checkAccomplished(goal)){
      return const Icon( Icons.sentiment_satisfied_alt );
    }
    return const Icon( Icons.sentiment_very_dissatisfied );
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add Exercise Goal',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          DropdownButtonFormField<ExerciseType>(
            value: selectedType,
            onChanged: (value) {
              setState(() {
                selectedType = value!;
              });
            },
            items: ExerciseType.values.map((type) {
              return DropdownMenuItem<ExerciseType>(
                value: type,
                child: Text(type.toString().split('.').last),
              );
            }).toList(),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: durationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Duration (minutes)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: repetitionsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Repetitions',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16.0),
          // ElevatedButton(
          //   onPressed: addExerciseGoal,
          //   child: const Text('Add Goal'),
          // ),
          ElevatedButton(
            onPressed: addExerciseGoal,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.yellow; // Change to yellow when pressed
                  }
                  return Colors.blue; // Default color
                },
              ),
            ),
            child: const Text('Add Goal'),
          ),
          const SizedBox(height: 16.0),
          Row(
              children:[
                const Text(
                  'Exercise Goals:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                    icon: const Icon(Icons.sync),
                    onPressed: () => setState(() {
                      // DatabaseAdapter.putFakeDaily(); // debug to check reload
                      // The daily records are reloaded automatically with the build
                    })
                ),
              ]
          ),
          const SizedBox(height: 8.0),

          Expanded(
            child: Container(
              color: Colors.grey[300],
              //color: Colors.lightGreen.withOpacity(0.8),
              child: ListView.builder(
                itemCount: exerciseGoals.length,
                itemBuilder: (BuildContext context, int index) {
                  ExerciseGoal goal = exerciseGoals[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(goal.type.toString().split('.').last),
                        subtitle: Text('Duration: ${goal.duration} minutes, Repetitions: ${goal.repetitions}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => removeExerciseGoal(index),
                        ),
                      ),
                      Row(
                          children:[
                            checkAccomplishedText(goal),
                            checkAccomplishedIcon(goal),
                          ]
                      )
                    ],
                  );
                },
              ),
            ),
          ),

          // Expanded(
          //   child: SingleChildScrollView(
          //     child: Column(
          //       children: List.generate(exerciseGoals.length, (index) {
          //         ExerciseGoal goal = exerciseGoals[index];
          //         return Column(
          //           children: [
          //             ListTile(
          //               title: Text(goal.type.toString().split('.').last),
          //               subtitle: Text('Duration: ${goal.duration} minutes, Repetitions: ${goal.repetitions}'),
          //               trailing: IconButton(
          //                 icon: const Icon(Icons.delete),
          //                 onPressed: () => removeExerciseGoal(index),
          //               ),
          //             ),
          //
          //             Row(
          //               children:[
          //                 checkAccomplishedText(goal),
          //                 checkAccomplishedIcon(goal),
          //               ]
          //             )
          //           ],
          //         );
          //       }),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}


