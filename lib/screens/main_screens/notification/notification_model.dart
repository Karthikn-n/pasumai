

import 'package:hive/hive.dart';
part 'notification_model.g.dart';

@HiveType(typeId: 0)
class NotificationModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String notificationType;

  @HiveField(2)
  final Map<String, dynamic> notificationData;

  @HiveField(3)
  final DateTime notificationTime;

  @HiveField(4)
  final String notificationImage;

  NotificationModel({
    required this.id,
    required this.notificationType,
    required this.notificationData,
    required this.notificationTime,
    required this.notificationImage,
  });
  

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'notificationType': notificationType});
    result.addAll({'notificationData': notificationData});
    result.addAll({'notificationTime': notificationTime.millisecondsSinceEpoch});
    result.addAll({'notificationImage': notificationImage});
  
    return result;
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toInt() ?? 0,
      notificationType: map['notificationType'] ?? '',
      notificationData: Map<String, dynamic>.from(map['notificationData']),
      notificationTime: DateTime.fromMillisecondsSinceEpoch(map['notificationTime']),
      notificationImage: map['notificationImage'] ?? '',
    );
  }

}
