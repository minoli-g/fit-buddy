import 'dart:async';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter/material.dart';
import 'package:fit_buddy/db.dart';

class ActivityPage extends StatefulWidget{
  const ActivityPage({super.key, required this.title});

  final String title;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>{

  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  /// The time at which the activity last changed (NOT the time of last update from stream)
  DateTime activityUpdateTime = DateTime.now();  

  /// The last recorded activity type (user's current activity)
  ActivityType currentActivityType = ActivityType.UNKNOWN;

  void _onActivityReceive(Activity activity) {
    print('Activity Detected >> ${activity.toJson()}');

    // When the activity type changes
    if (activity.type != currentActivityType){

      // Update the time spent on the old activity, only if > 1 minute has passed.
      if (DateTime.now().isAfter(activityUpdateTime.add(const Duration(seconds: 60)))){
        DatabaseAdapter.addActivityTime(
          currentActivityType, 
          DateTime.now().difference(activityUpdateTime)
        );
      }

      currentActivityType = activity.type;
      activityUpdateTime = DateTime.now();

      //TODO -  Start playing music corresponding to new activity 
    }

    _activityStreamController.sink.add(activity);
  }

  void _handleError(dynamic error) {
    print('Catch Error >> $error');
  }

  @override
  void initState() {
    super.initState();
    DatabaseAdapter.getCurrentDailyActivity();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final activityRecognition = FlutterActivityRecognition.instance;

      // Check if the user has granted permission. If not, request permission.
      PermissionRequestResult reqResult;
      reqResult = await activityRecognition.checkPermission();
      if (reqResult == PermissionRequestResult.PERMANENTLY_DENIED) {
        print('Permission is permanently denied.');
        return;
      } else if (reqResult == PermissionRequestResult.DENIED) {
        reqResult = await activityRecognition.requestPermission();
        if (reqResult != PermissionRequestResult.GRANTED) {
          print('Permission is denied.');
          return;
        }
      }

      // Subscribe to the activity stream.
      _activityStreamSubscription = activityRecognition.activityStream
          .handleError(_handleError)
          .listen(_onActivityReceive);
    });
  }

  @override
  void dispose() {
    _activityStreamController.close();
    _activityStreamSubscription?.cancel();
    super.dispose();
  }

  Widget _buildContentView() {
    return StreamBuilder<Activity>(
      stream: _activityStreamController.stream,
      builder: (context, snapshot) {
        final updatedDateTime = DateTime.now();

        String detectedType = snapshot.data?.type.toString().split('.').last ?? "UNKNOWN";
        String detectedConfidence = snapshot.data?.confidence.toString().split('.').last ?? "LOW";

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Current Activity: "),
            Text(detectedType),
            Text("Confidence Level: $detectedConfidence"),
            Text("Updated at: $updatedDateTime")
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildContentView()
          ],
        );
  }
}