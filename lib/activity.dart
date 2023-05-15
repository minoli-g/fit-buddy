import 'dart:async';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:flutter/material.dart';

class ActivityPage extends StatefulWidget{
  const ActivityPage({super.key, required this.title});

  final String title;

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>{

  final _activityStreamController = StreamController<Activity>();
  StreamSubscription<Activity>? _activityStreamSubscription;

  void _onActivityReceive(Activity activity) {
    print('Activity Detected >> ${activity.toJson()}');

    // TODO - 
    //Calculate the time elapsed since previous update
    //Increment the DB record for previous activity by that amount 
    _activityStreamController.sink.add(activity);
  }

  void _handleError(dynamic error) {
    print('Catch Error >> $error');
  }

  @override
  void initState() {
    super.initState();
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

        String detectedType = snapshot.data?.toJson()["type"].toString() ?? "ActivityType.UNKNOWN";
        detectedType = detectedType.substring(13); // Remove the "ActivityType." section

        String detectedConfidence = snapshot.data?.toJson()["confidence"].toString() ?? "ActivityConfidence.LOW";
        detectedConfidence = detectedConfidence.substring(19); // Remove the "ActivityConfidence." section

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