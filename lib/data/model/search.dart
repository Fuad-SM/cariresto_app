import 'dart:convert';
import 'package:restaurant_app/data/model/list_restaurant.dart';

Search searchFromJson(String str) => Search.fromJson(json.decode(str));

class Search {
  Search({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  final bool error;
  final int founded;
  final List<RestaurantElement> restaurants;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<RestaurantElement>.from(
            json["restaurants"].map((x) => RestaurantElement.fromJson(x))),
      );
}
