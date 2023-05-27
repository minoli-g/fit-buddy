import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:fit_buddy/log.dart';

import 'dart:math';

/// Utility class which interfaces with the logBox in Hive DB.
class DatabaseAdapter {

  /// Checks whether an activity log for the current day exists.
  /// If it does not, initializes one. Returns the retrieved/created log.
  static Future<Log> getCurrentDailyActivity() async {

    final box = Hive.box("logBox");
    final currentDateTemp = DateTime.now();
    final currentDay = DateTime (currentDateTemp.year, currentDateTemp.month, currentDateTemp.day);

    var dailyRecord = await box.get(currentDay.millisecondsSinceEpoch.toString(), defaultValue: null);

    // If it does not exist already, initialize with default values and store in DB
    if (dailyRecord == null){
      dailyRecord = Log(
        date: currentDay,
        walkTime: 0,
        runTime: 0,
        bicycleTime: 0
      );
      box.put(currentDay.millisecondsSinceEpoch.toString(), dailyRecord);
    }
    
    return dailyRecord;
  }

  /// Updates the activity log of the current day.
  /// Increments the time log of activity [type] by [duration].
  static void addActivityTime(ActivityType type, Duration duration) async {

    Log currentDailyLog = await getCurrentDailyActivity();
    switch (type){
      case ActivityType.WALKING:
        currentDailyLog.walkTime += duration.inMinutes;
        break;

      case ActivityType.RUNNING:
        currentDailyLog.runTime += duration.inMinutes;
        break;

      case ActivityType.ON_BICYCLE:
        currentDailyLog.bicycleTime += duration.inMinutes;
        break;

      default:
        // Other activity types are not recorded
        break;
    }
    
    final box = Hive.box("logBox");
    final currentDateTemp = DateTime.now();
    final currentDay = DateTime (currentDateTemp.year, currentDateTemp.month, currentDateTemp.day);
    box.put(currentDay.millisecondsSinceEpoch.toString(), currentDailyLog);    
  }

  // TODO - Method to delete data older than 2w

  static List<Log> getAllRecords()  {
    final box = Hive.box("logBox");
    List<Log> allLogs = [];

    for (int i=0; i<box.length; i++){
      allLogs.add(box.getAt(i));
    }
    return allLogs;
  }

  /// Generate random values with which to initialize the DB for testing
  static void setupDB(){

    final box = Hive.box("logBox");
    final currentDateTemp = DateTime.now();
    Random random = Random();

    for (int i=0; i<12; i++){
      var day = DateTime (
        currentDateTemp.year, currentDateTemp.month, currentDateTemp.day-i-1
      );
      Log log = Log(
        date: day,
        walkTime: random.nextInt(10)*10,
        runTime: random.nextInt(10)*10,
        bicycleTime: random.nextInt(10)*10
      );
      box.put(day.millisecondsSinceEpoch.toString(), log);
    }

  }

}