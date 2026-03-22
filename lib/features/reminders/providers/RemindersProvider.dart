import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../../../core/services/NotificationService.dart';
import '../models/ReminderModel.dart';

class RemindersProvider extends ChangeNotifier with WidgetsBindingObserver {
  List<ReminderModel> _reminders = [];
  bool _isLoading = true;
  String? _error;

  List<ReminderModel> get reminders => _reminders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  RemindersProvider() {
    WidgetsBinding.instance.addObserver(this);
    _fetchReminders();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _fetchReminders();
      } else {
        _reminders = [];
        notifyListeners();
      }
    });
  }

  void _fetchReminders() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reminders')
        .orderBy('scheduledTime')
        .snapshots()
        .listen((snapshot) {
      _reminders = snapshot.docs
          .map((doc) => ReminderModel.fromMap(doc.data(), doc.id))
          .toList();

      _isLoading = false;
      notifyListeners();
      
      // Також перевіряємо при початковому завантаженні
      _checkAndCleanExpiredReminders();
    }, onError: (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Щоразу як додаток повертається на екран, підчищаємо старі нагадування
      _checkAndCleanExpiredReminders();
    }
  }

  void _checkAndCleanExpiredReminders() {
    final now = DateTime.now();
    bool hasDeleted = false;
    for (var reminder in List.of(_reminders)) {
      if (reminder.scheduledTime.isBefore(now)) {
        deleteReminder(reminder);
        hasDeleted = true;
      }
    }
    if (hasDeleted) {
      _reminders.removeWhere((r) => r.scheduledTime.isBefore(now));
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> addReminder({
    required String listId,
    required String listTitle,
    required String message,
    required DateTime scheduledTime,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    final newReminderRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reminders')
        .doc();

    final reminder = ReminderModel(
      id: newReminderRef.id,
      userId: user.uid,
      listId: listId,
      listTitle: listTitle,
      message: message,
      scheduledTime: scheduledTime,
      notificationId: notificationId,
    );

    await newReminderRef.set(reminder.toMap());

    await NotificationService().scheduleNotification(
      id: notificationId,
      title: 'Нагадування: $listTitle',
      body: message,
      scheduledDate: scheduledTime,
      payload: newReminderRef.id,
    );
  }

  Future<void> deleteReminder(ReminderModel reminder) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('reminders')
        .doc(reminder.id)
        .delete();

    await NotificationService().cancelNotification(reminder.notificationId);
  }
}
