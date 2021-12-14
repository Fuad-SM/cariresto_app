import 'package:restaurant_app/utils/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;
  PreferencesHelper({required this.sharedPreferences});

  static String preferencesRestaurant = 'DAILY_RESTAURANT';

  Future<bool> get isDailyRestaurantActive async {
    final prefs = await sharedPreferences;
    return prefs.getBool(preferencesRestaurant) ?? false;
  }

  void setDailyRestaurant(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(preferencesRestaurant, value);
  }

  static String preferencesStarted = 'GET_STARTED';

  Future<String?> get markPageStarted async {
    final prefs = await sharedPreferences;
    return prefs.getString(preferencesStarted) ?? getStartedRoute;
  }

  void setPageStarted(String value) async {
    final prefs = await sharedPreferences;
    prefs.setString(preferencesStarted, value);
  }
}
