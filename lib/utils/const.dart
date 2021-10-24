// ignore_for_file: constant_identifier_names
enum ResultState { Loading, Idle, NoData, HasData, Error }
enum Post { Idle, Loading, Success, Error }

String smallPicture = 'https://restaurant-api.dicoding.dev/images/small/';
String mediumPicture = 'https://restaurant-api.dicoding.dev/images/medium/';
String largePicture = 'https://restaurant-api.dicoding.dev/images/large/';

final List<String> categories = ['Italia', 'Spanyol', 'Bali', 'Jawa', 'Sunda'];

const String getStartedRoute = '/';
const String homeRoute = '/homeRoute';
const String detailRoute = '/detailRoute';
const String searchRoute = '/searchRoute';
const String resultRoute = '/resultRoute';
