import 'package:dio/dio.dart';
import 'package:my_prayer/constnats/strings.dart';

class AudioFilesServices {
  late Dio dio;

  AudioFilesServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 40 * 1000,
      receiveTimeout: 40 * 1000,
      receiveDataWhenStatusError: true,
    );

    dio = Dio(options);
  }

  Future<List<dynamic>> getAudioFiles(int id) async {
    print("$audioFiles$id");
    Response response = await dio.get("$audioFiles$id", queryParameters: {
      "language": "ar",
    });
    return [];
  }
}
