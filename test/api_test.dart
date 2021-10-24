import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/detail_restaurant.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';

void main() {
  group('Network Call Test', () {
    // arrange
    ApiService? apiService;
    setUp(() {
      apiService = ApiService();
    });

    test('should return the true when checking the type of response', () async {
      // act
      var result = await apiService!.restaurant();

      // assert
      await expectLater(result.restaurants, isA<List<RestaurantElement>>());
    });

    test('should return the length of response when called', () async {
      // act
      var result = await apiService!.restaurant();

      // assert
      await expectLater(result.restaurants.length, 20);
    });

    test('should return the true when checking the type of response', () async {
      // act
      var result =
          await apiService!.detailRestaurant(id: 'rqdv5juczeskfw1e867');

      // assert
      await expectLater(result.restaurant, isA<Restaurant>());
    });

    test('should return true when searching by query', () async {
      // arrange
      String query = 'Melting Pot';
      // act
      var result = await apiService!.searchRestaurant(query: query);

      // assert
      expect(result.restaurants[0].name.contains(query), true);
    });
  });
}
