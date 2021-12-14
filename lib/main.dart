import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/routes/navigation.dart';
import 'package:restaurant_app/common/routes/route_generator.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/database/database_helper.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';
import 'package:restaurant_app/data/provider/database_provider.dart';
import 'package:restaurant_app/data/provider/detail_restaurant_provider.dart';
import 'package:restaurant_app/data/provider/preferences_provider.dart';
import 'package:restaurant_app/data/provider/list_restaurant_provider.dart';
import 'package:restaurant_app/data/provider/review_provider.dart';
import 'package:restaurant_app/data/provider/scheduling_provider.dart';
import 'package:restaurant_app/data/provider/search_provider.dart';
import 'package:restaurant_app/utils/background_service.dart';
import 'package:restaurant_app/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListRestaurantProvider>.value(
            value: ListRestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider<DetailRestaurantProvider>.value(
            value: DetailRestaurantProvider(apiService: ApiService())),
        ChangeNotifierProvider<ReviewProvider>.value(
            value: ReviewProvider(apiService: ApiService())),
        ChangeNotifierProvider<SearchProvider>.value(
            value: SearchProvider(apiService: ApiService())),
        ChangeNotifierProvider<DatabaseProvider>.value(
            value: DatabaseProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider<PreferencesProvider>.value(
          value: PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider<SchedulingProvider>.value(
            value: SchedulingProvider())
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, preferences, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Restaurant App',
            theme: ThemeData(primarySwatch: Colors.amber),
            onGenerateRoute: RouteGenerator.generateRoute,
            initialRoute: preferences.isStartedActive,
          );
        },
      ),
    );
  }
}
