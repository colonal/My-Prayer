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
    try {
      Response response = await dio.get("$audioFiles$id", queryParameters: {
        "language": "ar",
      });
      return response.data["audio_files"];
    } catch (_) {
      throw Exception();
    }
  }

  Future<List<dynamic>> getRecitations() async {
    try {
      Response response = await dio.get(recitations, queryParameters: {
        "language": "ar",
      });
      return response.data["recitations"];
    } catch (_) {
      throw Exception();
    }
  }
}
