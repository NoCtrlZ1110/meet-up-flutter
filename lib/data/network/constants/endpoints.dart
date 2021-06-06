import 'package:wemapgl/wemapgl.dart';

class Endpoints {
  Endpoints._();

  // base url
  static const String baseUrl = "http://jsonplaceholder.typicode.com";
  static const String hereUrl =
      "https://places.ls.hereapi.com/places/v1/discover/here";

  static const String HERE_MAP_TOKEN =
      "kx0ea-6asDqBUDbWsEJ6yuht2wk_GuX9SkI_gmZhIjU";

  // receiveTimeout
  static const int receiveTimeout = 15000;

  // connectTimeout
  static const int connectionTimeout = 30000;

  // booking endpoints
  static const String getPosts = baseUrl + "/posts";
  static String getNearbyPlaces(LatLng position) {
    return hereUrl +
        "?apiKey=$HERE_MAP_TOKEN&at=${position.latitude},${position.longitude}&pretty";
  }
}
