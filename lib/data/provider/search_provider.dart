import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/search.dart';

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchProvider({required this.apiService});

  void setState(ResultState newState) {
    _state = newState;
    notifyListeners();
  }

  late Search _searchResto;
  Search get search => _searchResto;

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> fetchSearch({required String query}) async {
    try {
      _state = ResultState.Loading;
      final searchRestaurant = await apiService.searchRestaurant(query: query);
      if (query.isEmpty) {
        _state = ResultState.Idle;
        notifyListeners();
        return _message = 'Find something';
      } else if (searchRestaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Not found';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _searchResto = searchRestaurant;
      }
    } on TimeoutException catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Timeout: $e';
    } on SocketException catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'No Connection: $e';
    } on Error catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error: $e';
    }
  }
}
