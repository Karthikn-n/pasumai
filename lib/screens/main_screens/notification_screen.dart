import 'package:app_3/providers/firebase_provider.dart';
import 'package:app_3/widgets/common_widgets.dart/app_bar.dart';
import 'package:app_3/widgets/common_widgets.dart/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'notification/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  
  List<NotificationModel> notifications = [];
  @override
  void initState() {
    super.initState();
    getNotifications();
  }

  Future<void> getNotifications() async {
    final storage = await getExternalStorageDirectory();
    if (!Hive.isBoxOpen('notificationsBox')) {
      Hive.init(storage!.path);// Provide the correct path
    }
    // Hive.registerAdapter(NotificationModelAdapter());
    final box = await Hive.openBox<NotificationModel>('notificationsBox');
    setState(() {
      notifications = box.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(
        title: "Notification"
      ),
      body:  Consumer<FirebaseProvider>(
        builder: (context, provider, child) {
          return notifications.isEmpty && provider.notifications.isEmpty 
          ? const Center(
              child: AppTextWidget(text: "No notificatins", fontWeight: FontWeight.w500, fontSize: 14,),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Dismissible(
                        onDismissed: (direction) async {
                          final storage = await getExternalStorageDirectory();
                          if (!Hive.isBoxOpen('notificationsBox')) {
                            Hive.init(storage!.path);// Provide the correct path
                          }
                          // Hive.registerAdapter(NotificationModelAdapter());
                          final box = await Hive.openBox<NotificationModel>('notificationsBox');
                          await box.deleteAt(index);
                          setState(() {
                            notifications.removeAt(index);
                          });
                        },
                        key: ValueKey(notification.id),
                        child: ListTile(
                          onTap: () {
                            // Do something
                          },
                          title: Text(notification.notificationType),
                          subtitle: Text(notification.notificationData.toString()),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(notification.notificationImage),
                          ),
                          trailing: Text("${DateTime.now().difference(notification.notificationTime).inMinutes.toString()}mins ago"),
                        ),
                      );
                    },
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = provider.notifications[index];
                      return ListTile(
                        onTap: () {
                          // Do something
                        },
                        title: Text(notification.notificationType),
                        subtitle: Text(notification.notificationData.toString()),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(notification.notificationImage),
                        ),
                        trailing: Text("${DateTime.now().difference(notification.notificationTime).inMinutes.toString()}mins ago"),
                      );
                    },
                  ),
                ],
              ),
            );
        }
      )
    );
  }
}