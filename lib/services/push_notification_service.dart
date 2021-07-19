import 'dart:convert';
import 'dart:io';

import 'package:oho_works_app/event_bus/newMessageReceived.dart';
import 'package:oho_works_app/home/locator.dart';
import 'package:oho_works_app/models/deeplinking_payload.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'navigation_service.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: missing_return


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {


  showSimpleNotification(message);
  print('Handling a background message ${message.messageId}');
}



showSimpleNotification(RemoteMessage message) async {
  var notificationData = message.data;
  // var redirect = notificationData['type'];
  var basicData = message.notification;
  var androidDetails = AndroidNotificationDetails(
      'id', 'channel ', 'description',
      priority: Priority.high, importance: Importance.max);
  var iOSDetails = IOSNotificationDetails();
  var platformDetails =
  new NotificationDetails(android: androidDetails, iOS: iOSDetails);
  print(jsonEncode(notificationData) +
      "-----------------------cliked notification  background");
  var flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin.show(
      0,
      basicData.title!=null?basicData.title.toString():"",
      basicData.body!=null?basicData.body.toString():"",
      platformDetails,
      payload: jsonEncode(notificationData));
}
class PushNotificationService {

  AndroidNotificationChannel channel;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  BuildContext context;
  EventBus eventbus = locator<EventBus>();
  final NavigationService _navigationService = locator<NavigationService>();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();


  Future initialise({
    Null Function() callback,
      Null Function(String) callbackMessenger,
      BuildContext context}) async {
    this.context = context;
    requestPermissions();
    var androidSettings = AndroidInitializationSettings('logo');
    var iOSSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.high,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    var initSetttings = InitializationSettings(android: androidSettings, iOS: iOSSettings);

    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onClickNotification);





    if (Platform.isIOS) {

      _fcm.requestPermission();
    }


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      showSimpleNotification(message);
      callback();
      print('onMessage=============================: ${message.data}');
      callbackMessenger(message.data['type']);


    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      print('onLaunch: ${event.data}');
      callback();
      showSimpleNotification(event);
      callbackMessenger(event.data['type']);
      _serialiseAndNavigate(event);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  }

  // ignore: missing_return
  Future onClickNotification(String payload) {
    try {
      print(payload + "-----------------------cliked notification click ");
      final body = json.decode(payload);
      _handleClick(body['type'],body['id'],body);
    } catch (e) {
      print(e);
    }
  }

  void requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  showSimpleNotification(RemoteMessage message) async {
    var notificationData = message.data;
    // var redirect = notificationData['type'];
    var basicData = message.notification;
    var androidDetails = AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOSDetails = IOSNotificationDetails();
    var platformDetails =
        new NotificationDetails(android: androidDetails, iOS: iOSDetails);
    print(jsonEncode(notificationData) + "-----------------------cliked notification show");
    await flutterLocalNotificationsPlugin.show(
        0,
        basicData.title!=null? basicData.title.toString():"",
        basicData.body!=null?basicData.body.toString():"",
        platformDetails,
        payload: jsonEncode(notificationData));
  }

  // ignore: missing_return
  Future onSelectNotification(String payload) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.postId = int.parse("211");
    _navigationService.navigateTo("/postDetailPage", deepLinkingPayload, null);
  }

  void _serialiseAndNavigate(RemoteMessage message) {
    var notificationData = message.data;

    _handleClick(notificationData['type'],notificationData['id'],notificationData);

  }

  void _handleClick(String type,String id,dynamic body) {
    eventbus.fire(NewMessage());
    if (type != null) {
      if (type != null) {
        switch (type) {
          case "person":
            handleProfilePageDeepLinking(type, id, context);
            break;
          case "institution":
            handleProfilePageDeepLinking(type, id, context);
            break;
          case "post":
            handlePostDeepLink(type, id, context);
            break;
          case "room":
            handleRoom(type, id, context);
            break;
          case "cal":
            handleEvent(type, id, context);
            break;
          case "buddy":
            handleBuddyDeepLink(context,id,body['institution_id'],body['person_id'],body['profile_image']);
            break;
          case "messenger":
            handleMessages(type, id, context);
            break;

          case "birthday":
            handleMessages(type, id, context);
            break;
        }
      }
    }
  }

  void handleProfilePageDeepLinking(
      String type, String id, BuildContext context) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.userId = int.parse(id);
    deepLinkingPayload.userType = type;
    _navigationService.navigateTo("/profile", deepLinkingPayload, context);
  }

  void handlePostDeepLink(String type, String id, BuildContext context) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.postId = int.parse(id);
    deepLinkingPayload.userType = type;

    _navigationService.navigateTo(
        "/postDetailPage", deepLinkingPayload, context);
  }
  void handleBuddyDeepLink(BuildContext context, String id, String institutionId, String personId, String profileImage) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.institutionUserId = int.parse(id);
    deepLinkingPayload.institutionId = int.parse(institutionId);
    deepLinkingPayload.personId = int.parse(personId);
    deepLinkingPayload.profileImage = profileImage;
    _navigationService.navigateTo("/BuddyApproval", deepLinkingPayload,context);
  }
  void handleRoom(
      String type,String id,BuildContext context) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.postId = int.parse(id);
    deepLinkingPayload.userType = type;
    _navigationService.navigateTo("/room_detail", deepLinkingPayload, context);
  }

  void handleEvent(String type, String id, BuildContext context) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.postId = int.parse(id);
    deepLinkingPayload.userType = type;
    _navigationService.navigateTo("/event_detail", deepLinkingPayload, context);
  }



  void handleMessages(String type, String id, BuildContext context) {
    DeepLinkingPayload deepLinkingPayload = DeepLinkingPayload();
    deepLinkingPayload.id = id;
    deepLinkingPayload.type = "notification";
    _navigationService.navigateTo("/ChatHistoryPage", deepLinkingPayload, context);
  }
}
