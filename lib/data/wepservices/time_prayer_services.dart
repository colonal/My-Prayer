// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:my_prayer/helpers/cache_helper.dart';

import '../../constnats/strings.dart';

class PlacesWebServices {
  late Dio dio;

  PlacesWebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 40 * 1000,
      receiveTimeout: 40 * 1000,
      receiveDataWhenStatusError: true,
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> frtchSuggestion(String city, String country) async {
    try {
      Response response = await dio.get(timePrayerBaseURL, queryParameters: {
        "city": city,
        "country": country,
        "method": 1,
        "month": DateTime.now().month,
      });

      print("statusCode: ${response.statusCode}");
      CacheHelper.saveData(key: "city", value: city);
      CacheHelper.saveData(key: "country", value: country);
      return response.data["data"];
    } catch (_) {}
    return [];
  }

  Future<Map> getLocation() async {
    try {
      Response response = await dio.post(ipBaseURL,
          options: Options(
              headers: {"content-Type": "application/x-www-form-urlencoded"}));

      print("statusCode: ${response.statusCode}");

      return response.data;
    } catch (e) {
      print("getLocation E: $e");
    }
    return {};
  }
}
