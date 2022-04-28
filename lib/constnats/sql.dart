import '../data/models/times_prayers.dart';

class ConnectionSQL {
  static const createDatabase = '''
  CREATE TABLE IF NOT EXISTS "prayer" (
    `Fajr`	TEXT,
    `Sunrise`	TEXT,
    `Dhuhr`	TEXT,
    `Asr`	TEXT,
    `Sunset`	TEXT,
    `Maghrib`	TEXT,
    `Isha`	TEXT,
    `Imsak`	TEXT,
    `Midnight`	TEXT,
    `readable`	TEXT,
    `timestamp`	TEXT,
    `date`	TEXT,
    `format`	TEXT,
    `day`	TEXT,
    `month`	INT,
    `timezone`	TEXT,
    `name`	TEXT,
    `school`	TEXT,
    `monthNumber`	TEXT,
    `monthEn`	TEXT,
    `monthAr`	TEXT,
    `weekdayEn`	TEXT,
    `weekdayAr`	TEXT,
    `HijriDay`	TEXT,
    `HijriDate`	TEXT,
    `latitudeAdjustmentMethod`	TEXT
  );
  ''';

  static String selectAllPrayer() {
    return 'select * from prayer;';
  }

  static String insertPrayer({required TimesPrayers timesPrayers}) {
    return '''
    insert into prayer (Fajr, Sunrise,Dhuhr,Asr,Sunset,Maghrib,Isha,Imsak,Midnight,readable,timestamp,date,format,day,month,timezone,name,school,monthNumber,monthEn,monthAr,weekdayEn,weekdayAr,HijriDay,HijriDate,latitudeAdjustmentMethod)
    values ('${timesPrayers.timings.fajr}', '${timesPrayers.timings.sunrise}','${timesPrayers.timings.dhuhr}','${timesPrayers.timings.asr}',
    '${timesPrayers.timings.sunset}','${timesPrayers.timings.maghrib}','${timesPrayers.timings.isha}','${timesPrayers.timings.imsak}','${timesPrayers.timings.midnight}',
    '${timesPrayers.date.readable}','${timesPrayers.date.timestamp}','${timesPrayers.date.gregorian.date}','${timesPrayers.date.gregorian.format}',
    '${timesPrayers.date.gregorian.day}','${timesPrayers.date.gregorian.month}','${timesPrayers.meta.timezone}','${timesPrayers.meta.name}','${timesPrayers.meta.school}',
    '${timesPrayers.hijri.monthNumber.toString()}',
    '${timesPrayers.hijri.monthEn}',
    '${timesPrayers.hijri.monthAr}',
    '${timesPrayers.hijri.weekdayEn.replaceAll("'", "")}',
    '${timesPrayers.hijri.weekdayAr.replaceAll("'", "")}',
    '${timesPrayers.hijri.day}',
    '${timesPrayers.hijri.date}',
    '${timesPrayers.meta.latitudeAdjustmentMethod}');
    ''';
  }

  static String deletPrayers() {
    return 'delete from prayer;';
  }
}
//monthNumber,monthEn,monthAr,weekdayEn,weekdayAr,HijriDay,HijriDate,
// '${timesPrayers.hijri.monthNumber.toString()}',
//     "${timesPrayers.hijri.monthEn}",
//     "${timesPrayers.hijri.monthAr}",
//     "${timesPrayers.hijri.weekdayEn}",
//     "${timesPrayers.hijri.weekdayAr}",
//     "${timesPrayers.hijri.day}",
//     "${timesPrayers.hijri.date}",