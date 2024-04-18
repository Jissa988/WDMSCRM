import 'package:flutter/foundation.dart';

class NotificationData {
  final Map<String, dynamic> data;

  NotificationData(this.data);
}
class NotificationDataProvider with ChangeNotifier {
  late NotificationData _notificationData;

  NotificationData get notificationData => _notificationData;

  NotificationDataProvider() {
    _notificationData = NotificationData({});
  }

  void setNotificationData(NotificationData data) {
    _notificationData = data;
    notifyListeners();
  }
}
