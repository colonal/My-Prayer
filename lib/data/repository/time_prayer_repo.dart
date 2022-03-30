import 'dart:convert';

import '../models/times_prayers.dart';
import '../wepservices/time_prayer_services.dart';

class TimeRepository {
  final PlacesWebServices placesWebServices;

  TimeRepository(this.placesWebServices);

  Future<List<TimesPrayers>> getTimesPrayers(List times,
      {bool isQuery = false}) async {
    return times.map((value) {
      if (!isQuery) {
        return TimesPrayers.fromJson(value);
      }

      Map<String, dynamic> timings = jsonDecode(value["timings"]);

      Map<String, dynamic> date = jsonDecode(value["date"]);

      Map<String, dynamic> meta = jsonDecode(value["meta"]);
      value = {
        "timings": timings,
        "date": date,
        "meta": meta,
      };
      print("\ndate: ${value["date"]}");
      return TimesPrayers.fromJson(value as Map<String, dynamic>);
    }).toList();
  }
}
