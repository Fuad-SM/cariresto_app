import 'package:flutter/material.dart';
import 'package:restaurant_app/data/preferences/preferences_helper.dart';
import 'package:restaurant_app/utils/const.dart';

class PreferencesProvider extends ChangeNotifier {
  bool _isDailyRestaurantActive = false;
  bool get isDailyRestaurantActive => _isDailyRestaurantActive;

  String? _isStartedActive = getStartedRoute;
  String? get isStartedActive => _isStartedActive;

  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}) {
    _getDailyRestaurantPreferences();
    _getStartedPreferences();
  }

  void _getDailyRestaurantPreferences() async {
    _isDailyRestaurantActive = await preferencesHelper.isDailyRestaurantActive;
    notifyListeners();
  }

  void enabledDailyNews(bool value) {
    preferencesHelper.setDailyRestaurant(value);
    _getDailyRestaurantPreferences();
  }

  void _getStartedPreferences() async {
    _isStartedActive = await preferencesHelper.markPageStarted;
    notifyListeners();
  }

  void pageStarted(String value) {
    preferencesHelper.setPageStarted(value);
    _getStartedPreferences();
  }
}
