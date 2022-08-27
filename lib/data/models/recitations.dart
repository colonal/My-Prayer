class Recitations {
  final int id;
  final String reciterName;
  final String? style;
  final String nameAr;
  Recitations({
    required this.id,
    required this.reciterName,
    required this.style,
    required this.nameAr,
  });

  factory Recitations.fromJson(dynamic json) {
    return Recitations(
      id: json["id"],
      reciterName: json["reciter_name"],
      style: json["style"],
      nameAr: json["translated_name"]["name"],
    );
  }
}
