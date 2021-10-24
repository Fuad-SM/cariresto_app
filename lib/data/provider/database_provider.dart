import 'package:flutter/material.dart';
import 'package:restaurant_app/data/database/database_helper.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavoriteResto();
  }

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  List<RestaurantElement> _favorite = [];
  List<RestaurantElement> get favorite => _favorite;

  void _getFavoriteResto() async {
    _favorite = await databaseHelper.getFavResto();
    if (_favorite.isNotEmpty) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'The favorites list is empty.';
    }
    notifyListeners();
  }

  void addFavoriteResto(RestaurantElement resto) async {
    try {
      await databaseHelper.insertFavResto(resto);
      _getFavoriteResto();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error add: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteResto = await databaseHelper.getFavRestoById(id);
    return favoriteResto.isNotEmpty;
  }

  void removeFavoriteResto(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavoriteResto();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
