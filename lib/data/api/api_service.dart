import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/data/model/review.dart';
import 'package:restaurant_app/data/model/search.dart';

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String _listRestaurant = '/list';
  static const String _detailRestaurant = '/detail/';
  static const String _review = '/review';
  static const String _search = '/search?q=';

  Future<ListRestaurant> restaurant() async {
    final response = await http.get(Uri.parse(_baseUrl + _listRestaurant));

    if (response.statusCode == 200) {
      return ListRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load List Restaurant');
    }
  }

  Future<DetailRestaurant> detailRestaurant({required String id}) async {
    final response =
        await http.get(Uri.parse(_baseUrl + _detailRestaurant + id));
    if (response.statusCode == 200) {
      return DetailRestaurant.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Detail Restaurant');
    }
  }

  Future<Search> searchRestaurant({required String query}) async {
    final response = await http.get(Uri.parse(_baseUrl + _search + query));
    if (response.statusCode == 200) {
      return Search.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Search Restaurant');
    }
  }

  Future<Review> reviewRestaurant(
      {required String id,
      required String name,
      required String review}) async {
    final body = CustomerReview(id: id, name: name, review: review);

    final response = await http.post(
      Uri.parse(_baseUrl + _review),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': '12345',
      },
      body: reviewToJson(body),
    );

    if (response.statusCode == 200) {
      return Review.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to Post Review Restaurant');
    }
  }
}
