import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/data/api/api_service.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'api_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('Fetch restaurant api', () {
    final restaurantsList = [
      RestaurantElement(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Lorem ipsum dolor sit amet.',
          pictureId: '14',
          city: 'medan',
          rating: 4.2),
      RestaurantElement(
          id: 's1knt6za9kkfw1e867',
          name: 'Kafe Kita',
          description: 'Lorem ipsum dolor sit amet.',
          pictureId: '25',
          city: 'Gorontalo',
          rating: 4),
      RestaurantElement(
          id: 'w9pga3s2tubkfw1e867',
          name: 'Bring Your Phone Cafe',
          description: 'Lorem ipsum dolor sit amet.',
          pictureId: '25',
          city: 'Gorontalo',
          rating: 4),
    ];

    final responseExpected = ListRestaurant(
        error: false,
        message: 'success',
        count: 3,
        restaurants: restaurantsList);

    test('should contain list of restaurant when api success', () async {
      //arrange
      final api = ApiService();
      final mockClient = MockClient();

      //act
      var json = jsonEncode(responseExpected.toJson());
      when(
        mockClient.get(
          Uri.parse('https://restaurant-api.dicoding.dev/list'),
        ),
      ).thenAnswer((_) async => http.Response(json, 200));

      //assert
      var restaurantActual = await api.restaurant(mockClient);
      expect(restaurantActual, isA<ListRestaurant>());
    });

    test('should contain list of restaurant when api failed', () {
      //arrange
      final api = ApiService();
      final mockClient = MockClient();

      when(
        mockClient.get(
          Uri.parse('https://restaurant-api.dicoding.dev/list'),
        ),
      ).thenAnswer((_) async =>
          http.Response('Failed to load list of restaurants', 404));

      var restaurantActual = api.restaurant(mockClient);
      expect(restaurantActual, throwsException);
    });

    test('should contain list of restaurant when no internet connection', () {
      //arrange
      final api = ApiService();
      final client = MockClient();

      when(
        client.get(
          Uri.parse('https://restaurant-api.dicoding.dev/list'),
        ),
      ).thenAnswer(
          (_) async => throw const SocketException('No Internet Connection'));

      var restaurantActual = api.restaurant(client);
      expect(restaurantActual, throwsException);
    });
  });
}
