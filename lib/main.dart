import 'package:alvapply/Upload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';


AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.high,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBGb2WH5F5C9jYFjboe1__iQxOIq2lHxWM",
  authDomain: "alvapply.firebaseapp.com",
  projectId: "alvapply",
  storageBucket: "alvapply.appspot.com",
  messagingSenderId: "776387391460",
  appId: "1:776387391460:web:79ca047c39247e5d85e1f1",
  measurementId: "G-C1CQY3NWSC"
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const String routeName = 'alvapply';
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final googleSignIn = GoogleSignIn();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tutorial',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UploadImageToFirebase(),
    );
  }
}