class Qoran {
  final String name;
  final String nameE;
  final int number;
  final int numberVerses;
  final int numberWords;
  final int numberLetters;
  final String descent;
  final String surah;
  Qoran({
    required this.name,
    required this.nameE,
    required this.number,
    required this.numberVerses,
    required this.numberWords,
    required this.numberLetters,
    required this.descent,
    required this.surah,
  });

  factory Qoran.fromJson(Map<String, dynamic> json) {
    return Qoran(
        name: json["Name"],
        nameE: json["English_Name"],
        number: json["Number"],
        numberVerses: json["Number_Verses"],
        numberWords: json["Number_Words"],
        numberLetters: json["Number_Letters"],
        descent: json["Descent"],
        surah: json["Surah"]);
  }
}
