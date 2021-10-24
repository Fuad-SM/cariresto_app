import 'package:flutter/material.dart';
import 'package:restaurant_app/common/animation/page_route_builder.dart';
import 'package:restaurant_app/ui/pages/result_screen.dart';
import 'package:restaurant_app/utils/const.dart';
import 'package:restaurant_app/data/model/list_restaurant.dart';
import 'package:restaurant_app/ui/pages/error_screen.dart';
import 'package:restaurant_app/ui/pages/get_started_screen.dart';
import 'package:restaurant_app/ui/pages/search_screen.dart';
import 'package:restaurant_app/ui/widgets/custom_sliverappbar.dart';
import 'package:restaurant_app/ui/widgets/home_bottomnavbar.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case getStartedRoute:
        return ZoomAnimasi(page: const GetStartedScreen());
      case homeRoute:
        return SlideToLeft(page: const HomeBottomNavbar());
      case detailRoute:
        var args = settings.arguments as RestaurantElement;
        return SlideToUp(page: CustomSliverAppBar(restaurantElement: args));
      case searchRoute:
        return SlideToLeft(page: const SearchScreen());
      case resultRoute:
        var query = settings.arguments as String;
        return SlideToLeft(page: ResultScreen(query));
      default:
        return SlideToLeft(page: const ErrorScreen());
    }
  }
}
