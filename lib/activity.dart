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
    DatabaseAdapter.setupRealisticDB();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [ 
                  Text(
                    "Current Activity: ",
                    style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                  ),
                  Container (
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      border: Border.all(color: Colors.grey), 
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Text(
                      detectedType,
                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
                      ),
                  ),
                  Text("Confidence Level: $detectedConfidence"),
                  Text("Updated at: $updatedDateTime")
                ]
              )
            ),
            Container (
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), 
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: Row(
                  children: const [
                    Icon(Icons.info),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left:10), 
                        child:Text( "We detect six possible types of activities: walking, bicycling, running, travelling in a vehicle, still, and unknown. For fitness purposes, we track only the first three.")
                      )
                    )
                  ],
                )
            ),
            Container (
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey), 
                borderRadius: const BorderRadius.all(Radius.circular(20))
              ),
              child: Row(
                  children: const [
                    Icon(Icons.info),
                    Expanded( 
                      child: Padding(
                        padding: EdgeInsets.only(left:10), 
                        child: Text("When the activity changes, it may take a minute or two for the update to appear")
                      )
                    )
                  ],
                )
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildContentView()
          ],
        );
  }
}