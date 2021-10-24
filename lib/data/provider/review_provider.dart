import 'dart:async';
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/review.dart';

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;

  ReviewProvider({required this.apiService});

  late Review _reviewCustomer;
  Review get reviewCustomer => _reviewCustomer;

  late Post _state = Post.Idle;
  Post get state => _state;

  String _message = '';
  String get message => _message;

  Future<dynamic> fetchReview({
    required String id,
    required String name,
    required String review,
  }) async {
    try {
      _state = Post.Loading;
      notifyListeners();
      final customerReview = await apiService.reviewRestaurant(
        id: id,
        name: name,
        review: review,
      );
      if (customerReview.message == 'success') {
        _state = Post.Success;
        notifyListeners();
        return _message = 'Success';
      }
    } catch (e) {
      rethrow;
    }
  }
}
