class ConnectionSQL {
  static const createDatabase =
      '''
  CREATE TABLE "prayer" (
    `id`	INTEGER PRIMARY KEY AUTOINCREMENT,
    `timings`	TEXT,
    `date`	TEXT,
    `meta`	TEXT
  );
  ''';

  static String selectAllPrayer() {
    return 'select * from prayer;';
  }

  static String insertPrayer(
      {required String timings, required String date, required String meta}) {
    return '''
    insert into prayer (timings, date,meta)
    values ('$timings', '$date','$meta');
    ''';
  }

  static String deletPrayers() {
    return 'delete from prayer;';
  }
}
