class Azkar {
  final int id;
  final String category;
  String count;
  final String description;
  final String reference;
  final String zekr;
  final String repetition;
  bool favorite;
  String number = "0";

  Azkar({
    required this.category,
    required this.count,
    required this.description,
    required this.reference,
    required this.zekr,
    required this.id,
    required this.repetition,
    required this.number,
    this.favorite = false,
  });

  factory Azkar.fromJson(Map json, number) {
    return Azkar(
      id: number,
      category: json["category"],
      count: json["count"],
      number: json["count"],
      description: json["description"],
      reference: json["reference"],
      zekr: json["zekr"],
      repetition: json["count"],
    );
  }
}
