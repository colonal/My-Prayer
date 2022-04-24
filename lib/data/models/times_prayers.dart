// ignore_for_file: avoid_print

class TimesPrayers {
  late Timings timings;
  late Date date;
  late Map timingsJson;
  late Meta meta;
  late Hijri hijri;

  TimesPrayers({required this.timings, required this.date, required this.meta});
  TimesPrayers.fromJson(Map<String, dynamic> json) {
    try {
      timings = Timings.fromJson(json["timings"]);
    } catch (e) {
      print("timings E: $e");
    }
    try {
      date = Date.fromJson(json["date"]);
    } catch (e) {
      print("date E: $e");
    }
    try {
      timingsJson = TimingsJson.toMap(json["timings"]);
    } catch (e) {
      print("TimingsJson E: $e");
    }
    try {
      meta = Meta.fromJson(json["meta"]);
    } catch (e) {
      print("meta E: $e");
    }
    try {
      hijri = Hijri.fromJson(json["date"]["hijri"]);
    } catch (e) {
      print("hijri E: $e");
    }
  }
}

class Timings {
  late String fajr;
  late String sunrise;
  late String dhuhr;
  late String asr;
  late String sunset;
  late String maghrib;
  late String isha;
  late String imsak;
  late String midnight;

  Timings(
      {required this.fajr,
      required this.sunrise,
      required this.dhuhr,
      required this.asr,
      required this.sunset,
      required this.maghrib,
      required this.isha,
      required this.imsak,
      required this.midnight});

  Timings.fromJson(Map<String, dynamic> json) {
    fajr = json["Fajr"].toString().split(" ")[0];
    sunrise = json["Sunrise"].toString().split(" ")[0];
    dhuhr = json["Dhuhr"].toString().split(" ")[0];
    asr = json["Asr"].toString().split(" ")[0];
    sunset = json["Sunset"].toString().split(" ")[0];
    maghrib = json["Maghrib"].toString().split(" ")[0];
    isha = json["Isha"].toString().split(" ")[0];
    imsak = json["Imsak"].toString().split(" ")[0];
    midnight = json["Midnight"].toString().split(" ")[0];
  }
}

class Date {
  late String readable;
  late String timestamp;
  late Gregorian gregorian;

  Date(
      {required this.readable,
      required this.timestamp,
      required this.gregorian});

  Date.fromJson(Map<String, dynamic> json) {
    readable = json['readable'];
    timestamp = json['timestamp'];
    gregorian = Gregorian.fromJson(json["gregorian"]);
  }
}

class Gregorian {
  late String date;
  late String format;
  late String day;
  late int month;

  Gregorian(
      {required this.date,
      required this.format,
      required this.day,
      required this.month});

  Gregorian.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    format = json["format"];
    day = json["day"];
    month = json["month"]["number"];
  }
}

class TimingsJson {
  static Map toMap(Map data) {
    return {
      "Fajr": data["Fajr"].toString().split(" ")[0],
      "Sunrise": data["Sunrise"].toString().split(" ")[0],
      "Dhuhr": data["Dhuhr"].toString().split(" ")[0],
      "Asr": data["Asr"].toString().split(" ")[0],
      "Sunset": data["Sunset"].toString().split(" ")[0],
      "Maghrib": data["Maghrib"].toString().split(" ")[0],
      "Isha": data["Isha"].toString().split(" ")[0],
      "Imsak": data["Imsak"].toString().split(" ")[0],
      "Midnight": data["Midnight"].toString().split(" ")[0],
    };
  }
}

class Meta {
  late String timezone;
  late String name;
  late String school;
  late String latitudeAdjustmentMethod;

  Meta({
    required this.name,
    required this.school,
    required this.timezone,
    required this.latitudeAdjustmentMethod,
  });

  Meta.fromJson(Map<String, dynamic> json) {
    timezone = json["timezone"];
    school = json["school"];
    latitudeAdjustmentMethod = json["latitudeAdjustmentMethod"];
    name = json["method"]["name"];
  }
}

class Hijri {
  late String day;
  late String date;
  late String weekdayEn;
  late String weekdayAr;
  late String monthAr;
  late String monthEn;
  late int monthNumber;
  Hijri({
    required this.day,
    required this.date,
    required this.weekdayEn,
    required this.weekdayAr,
    required this.monthAr,
    required this.monthEn,
    required this.monthNumber,
  });
  Hijri.fromJson(Map<String, dynamic> json) {
    day = json["day"];
    date = json["date"];
    weekdayEn = json["weekday"]["en"];
    weekdayAr = json["weekday"]["ar"];
    monthAr = json["month"]["ar"];
    monthEn = json["month"]["en"];
    monthNumber = json["month"]["number"];
  }
}
