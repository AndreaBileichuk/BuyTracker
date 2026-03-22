import 'package:cloud_firestore/cloud_firestore.dart';

class ReminderModel {
  final String id;
  final String userId;
  final String listId;
  final String listTitle;
  final String message;
  final DateTime scheduledTime;
  final int notificationId;

  ReminderModel({
    required this.id,
    required this.userId,
    required this.listId,
    required this.listTitle,
    required this.message,
    required this.scheduledTime,
    required this.notificationId,
  });

  factory ReminderModel.fromMap(Map<String, dynamic> data, String documentId) {
    return ReminderModel(
      id: documentId,
      userId: data['userId'] ?? '',
      listId: data['listId'] ?? '',
      listTitle: data['listTitle'] ?? '',
      message: data['message'] ?? '',
      scheduledTime: (data['scheduledTime'] as Timestamp).toDate(),
      notificationId: data['notificationId'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'listId': listId,
      'listTitle': listTitle,
      'message': message,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'notificationId': notificationId,
    };
  }
}
