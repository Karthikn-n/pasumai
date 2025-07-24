import 'dart:convert';

import 'package:app_3/helper/page_transition_helper.dart';
import 'package:app_3/providers/api_provider.dart';
import 'package:app_3/providers/profile_provider.dart';
import 'package:app_3/screens/main_screens/bottom_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  late final ProfileProvider _profileProvider;
  late final ApiProvider _apiProvider;
  static final NotificationService _notificationService = NotificationService._internal();
  static NotificationService get instance => _notificationService;
  void init({
    required ProfileProvider profileProvider,
    required ApiProvider apiProvider,
  }) {
    _profileProvider = profileProvider;
    _apiProvider = apiProvider;
  }

  Future<void> initialize(BuildContext context) async {
    // This si for android setup
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // This is for Ios 
    const DarwinInitializationSettings iOSSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize the setting 
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iOSSettings,
    );
    _notificationsPlugin
    .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!
    .requestNotificationsPermission();
    // Initialize the notification 
    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        print("Payload: $payload");
        if (payload != null && payload.isNotEmpty) {
          _handleNavigation(context, payload);
        }
      },
    );
  }

  // Show a local notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    bool? alertOnce,
    int? progress,
    bool? showProgress,
    required String payload, // encode data like: "order:123"
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'All Notifications',
      channelDescription: 'Shows download progress',
      showProgress: showProgress ?? false,
      maxProgress: 100,
      progress: progress ?? 100,
      onlyAlertOnce: alertOnce ?? false,
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async => await _notificationsPlugin.cancel(id);

  // Handle navigation from payload
  void _handleNavigation(BuildContext context, String payload) async {
    Map<String, dynamic> data = json.decode(payload);
   
    if (data["type"] == "order" ) {
      _apiProvider.setIndex(4);
      _apiProvider.setQuick(false);
      _profileProvider.changeBody(0);
      Navigator.pushAndRemoveUntil(context, SideTransistionRoute(screen: const BottomBar()), (route) => false,);
    } else if (data["type"] == "subscription") {
        _apiProvider.setIndex(4);
        _apiProvider.setQuick(false);
        _profileProvider.changeBody(1);
      Navigator.pushAndRemoveUntil(context, SideTransistionRoute(screen: const BottomBar()), (route) => false,);
    } else if (payload == 'address_added') {
      Navigator.pushNamed(context, '/addressBook');
    } else if(data["type"] == "download") {
      await OpenFile.open(data["filePath"]);
    }
  }
  
  NotificationService._internal();
  factory NotificationService() => _notificationService;
}
