import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Goals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Exercise Goal',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
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
            SizedBox(height: 8.0),
            TextFormField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Duration (minutes)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: repetitionsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Repetitions',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: addExerciseGoal,
              child: Text('Add Goal'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Exercise Goals:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(exerciseGoals.length, (index) {
                    ExerciseGoal goal = exerciseGoals[index];
                    return ListTile(
                      title: Text(goal.type.toString().split('.').last),
                      subtitle: Text('Duration: ${goal.duration} minutes, Repetitions: ${goal.repetitions}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => removeExerciseGoal(index),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


