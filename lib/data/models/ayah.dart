class Ayah {
  final int id;
  final String name;
  final String transliteration;
  final String translation;
  final String type;
  final int totalVerses;
  final List<Verses> verses;

  Ayah({
    required this.id,
    required this.name,
    required this.transliteration,
    required this.translation,
    required this.type,
    required this.totalVerses,
    required this.verses,
  });
  factory Ayah.fromJson(
    Map json,
  ) {
    List<Verses> l = [];
    for (var item in json["verses"]) {
      l.add(Verses.fromJson(item, json["name"]));
    }
    return Ayah(
      id: json["id"],
      name: json["name"],
      transliteration: json["transliteration"],
      translation: json["translation"] ?? "",
      type: json["type"],
      totalVerses: json["total_verses"],
      verses: l,
    );
  }
}

class Verses {
  final int id;
  final String name;
  final String text;
  final String cleanText;
  final String translation;
  bool? favorite = false;

  Verses(
      {required this.name,
      required this.id,
      required this.text,
      required this.cleanText,
      required this.translation,
      this.favorite});
  factory Verses.fromJson(Map json, String name) {
    return Verses(
      name: name,
      id: json["id"],
      text: json["text"],
      cleanText: json["cleanText"],
      translation: json["translation"] ?? "",
    );
  }
}
