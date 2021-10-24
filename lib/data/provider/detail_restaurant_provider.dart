import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';

class DetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailRestaurantProvider({required this.apiService});

  late DetailRestaurant _detailRestaurant;
  DetailRestaurant get detailRestaurant => _detailRestaurant;

  late ResultState _state;
  ResultState get state => _state;

  String _message = '';
  String get message => _message;

  void setState(ResultState newState) {
    _state = newState;
    notifyListeners();
  }

  Future<dynamic> fetchDetailRestaurant(String id) async {
    try {
      _state = ResultState.Loading;
      final restaurantDetail = await apiService.detailRestaurant(id: id);
      if (restaurantDetail.restaurant.id!.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _detailRestaurant = restaurantDetail;
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
