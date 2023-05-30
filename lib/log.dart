import 'package:hive/hive.dart';
part 'log.g.dart';

@HiveType(typeId: 1)
class Log {
  @HiveField(0)
  final DateTime date;

  // Store the daily times of walking, running and bicycling in minutes
  // The vehicle, still and unknown activity types will not be recorded.

  @HiveField(1)
  int walkTime;

  @HiveField(2)
  int runTime;

  @HiveField(3)
  int bicycleTime;

  Log({
    required this.date,
    required this.walkTime,
    required this.runTime,
    required this.bicycleTime
  });
}