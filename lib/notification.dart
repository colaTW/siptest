import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification {

  final FlutterLocalNotificationsPlugin np = FlutterLocalNotificationsPlugin();

  /// 是否初始化了
  var isInit = false;

  /// 初始化
  void init() {
    if (isInit) return;
    isInit = true;

    var android = const AndroidInitializationSettings('background');
    var ios = const DarwinInitializationSettings();

    np.initialize(InitializationSettings(android: android, iOS: ios));
  }

  void send(String title, String body) {
    // 初始化
    init();

    // 构建描述
    var androidDetails = const AndroidNotificationDetails(
        '10',
        'name',
        importance: Importance.max,
        priority: Priority.high
    );
    var iosDetails = const DarwinNotificationDetails();
    var details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails
    );

    // 显示通知, 第一个参数是id,id如果一致则会覆盖之前的通知
    np.show(DateTime.now().millisecondsSinceEpoch >> 19, title, body, details);
  }

}
var notification = Notification();
