// import 'package:app_3/main.dart';
// import 'package:app_3/providers/profile_provider.dart';
// import 'package:app_3/widgets/profile_screen_widgets/order_detail_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// class NotificationProvider{
//   ProfileProvider provider = ProfileProvider();
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();
  
//   // Initialize the notification for the Flutter
//   Future<void> initiNotification(BuildContext context) async {

//     // Android notification initialization
//     AndroidInitializationSettings androidInitializationSettings =
//       const AndroidInitializationSettings(
//         "logo"
//       );

//     // IOS notification initialization
//     var initializationIOSSetting = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//       onDidReceiveLocalNotification: (id, title, body, payload) async {
        
//       },
//     );

//     // initialize the local notification for both 
//     var initializeNotification = InitializationSettings(
//       android: androidInitializationSettings,
//       iOS: initializationIOSSetting
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializeNotification,
//       onDidReceiveNotificationResponse: (details) async {
//         String? payLoad = details.payload;
//         print("Payload : $payLoad, Order Id: ${details.id}");
//         if (payLoad != null && payLoad.isNotEmpty) {
//           await provider.orderDetail(details.id!).then((value) async{
//             navigatorKey.currentState?.push(MaterialPageRoute(
//               builder: (_) => const OrderDetailWidget(),
//               settings: RouteSettings(
//                 arguments: {"orderDetail": provider.orderInfoData.firstWhere((element) => element.orderId == details.id,)}
//               )
//             ));
//           },);
//         }
//       },
//     );
//   }

//   // Notification Detail
//   notificationDetail() {
//     return const NotificationDetails(
//       android: AndroidNotificationDetails(
//         "channelId", "channelName", 
//         importance: Importance.max,
//       ),
//       iOS: DarwinNotificationDetails(
//         presentSound: true
//       )
//     );
//   }

//   // Display the notification
//   Future<void> showNotification({
//     int? id = 0,
//     String? title,
//     String? body,
//     String? payload
//   }) async {
    
//     return flutterLocalNotificationsPlugin.show(
//       id!, 
//       title, 
//       body, await notificationDetail(),
//       payload: payload
//     );
    
//   }
// }