// ignore_for_file: avoid_print

import 'package:dio/dio.dart';

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
      // print("Data: ${response.data["predictions"]}");
      print("statusCode: ${response.statusCode}");

      return response.data["data"];
    } catch (e) {
      // print(e.toString());
    }
    return [];
  }

  Future<Map> getLocation() async {
    print("#" * 50);
    try {
      Response response = await dio.post(ipBaseURL,
          options: Options(
              headers: {"content-Type": "application/x-www-form-urlencoded"}));

      print("statusCode: ${response.statusCode}");
      print("data: ${response.data}");

      return response.data;
    } catch (e) {
      print("getLocation E: $e");
    }
    return {};
  }
}
