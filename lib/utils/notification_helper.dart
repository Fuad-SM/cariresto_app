import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/routes/navigation.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:rxdart/rxdart.dart';
// ignore_for_file: avoid_print

final selectNotificationSubject = BehaviorSubject<String>();
final randomNumber = Random().nextInt(20);

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        print('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      ListRestaurant listRestaurant) async {
    var _channelId = '1';
    var _channelName = 'channel_01';
    var _channelDescription = 'restaurant app channel';

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName,
        channelDescription: _channelDescription,
        enableLights: true,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    var titleNotification = 'CariResto bagi promo';
    var titleRestaurant = 'Cek restoran yang sedang promo hari ini';

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpecifics,
        payload: json.encode(listRestaurant.toJson()));
  }

  void configureSelectNotificationsSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      var data = ListRestaurant.fromJson(json.decode(payload));
      var restaurant = data.restaurants[randomNumber];
      print(restaurant);
      Navigation.intentWithData(detailRoute, restaurant);
    });
  }
}
