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

      value = {
        "timings": {
          "Fajr": value["Fajr"],
          "Sunrise": value["Sunrise"],
          "Dhuhr": value["Dhuhr"],
          "Asr": value["Asr"],
          "Sunset": value["Sunset"],
          "Maghrib": value["Maghrib"],
          "Isha": value["Isha"],
          "Imsak": value["Imsak"],
          "Midnight": value["Midnight"]
        },
        "date": {
          "readable": value["readable"],
          "timestamp": value["timestamp"],
          "gregorian": {
            "date": value["date"],
            "format": value["format"],
            "day": value["day"],
            "month": {
              "number": value["month"],
            },
          },
          "hijri": {
            "date": value["HijriDate"],
            "day": value["HijriDay"],
            "month": {
              "number": int.tryParse(value["monthNumber"]) ?? -1,
              "en": value["monthEn"],
              "ar": value["monthAr"],
            },
            "weekday": {
              "en": value["weekdayEn"],
              "ar": value["weekdayAr"],
            },
          }
        },
        "meta": {
          "timezone": value["timezone"],
          "school": value["school"],
          "latitudeAdjustmentMethod": value["latitudeAdjustmentMethod"],
          "method": {
            "name": value["name"],
          },
        },
      };
      return TimesPrayers.fromJson(value as Map<String, dynamic>);
    }).toList();
  }
}
