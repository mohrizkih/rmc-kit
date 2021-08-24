import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:rmc_kit/Screens/Dashboard/components/body.dart';
import 'package:rmc_kit/Screens/Dashboard/components/sidebar.dart';
import 'package:rmc_kit/constant/color.dart';
import 'package:swipedetector/swipedetector.dart';

class Dashboard extends StatefulWidget {
  final String myId;

  Dashboard({@required this.myId});
  @override
  _DashboardState createState() => _DashboardState(myId: myId);
}

class _DashboardState extends State<Dashboard> {
  _DashboardState({@required this.myId});

  String myId;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FSBStatus status;

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      Platform.isAndroid ? 'com.example.rmc_kit' : 'com.example.rmc_kit',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    print(message);
//    print(message['body'].toString());
//    print(json.encode(message));

    await flutterLocalNotificationsPlugin.show(
        0, message['title'].toString(), message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));

//    await flutterLocalNotificationsPlugin.show(
//        0, 'plain title', 'plain body', platformChannelSpecifics,
//        payload: 'item x');
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      Platform.isAndroid
          ? showNotification(message['notification'])
          : showNotification(message['aps']['alert']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      FirebaseFirestore.instance
          .collection('Data Pribadi Pengguna')
          .doc(myId)
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  Future<bool> exitConfirm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Keluar Aplikasi"),
            content: Text("Keluar dari aplikasi ini?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              CupertinoDialogAction(
                  child: Text(
                    "Yes",
                    style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    try {
                      FirebaseFirestore.instance
                          .collection('Data Pribadi Pengguna')
                          .doc(myId)
                          .update({'chattingWith': null});
                      SystemNavigator.pop();

                      // return Future.value(false);
                    } catch (error) {
                      print(error.toString());
                    }
                  }),
            ],
          );
        });
    return Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    registerNotification();
    configLocalNotification();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        body: SwipeDetector(
          onSwipeRight: () {
            setState(() {
              status = FSBStatus.FSB_OPEN;
            });
          },
          onSwipeLeft: () {
            setState(() {
              status = FSBStatus.FSB_CLOSE;
            });
          },
          child: FoldableSidebarBuilder(
            status: status,
            drawer: Container(
              width: size.width * 0.6,
              child: Sidebar(closeDrawer: () {
                setState(() {
                  status = FSBStatus.FSB_CLOSE;
                });
              }),
            ),
            screenContents: Body(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: secondColor[300],
            onPressed: () {
              setState(() {
                status = status == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
              });
            },
            child: Image.asset('assets/images/login.png')),
      ),
      onWillPop: exitConfirm,
    );
  }
}
