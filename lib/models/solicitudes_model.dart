class Solicitudes {
  String de;
  String para;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  Solicitudes({
    required this.de,
    required this.para,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  factory Solicitudes.fromJson(Map<String, dynamic> json) => Solicitudes(
        de: json["de"],
        para: json["para"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "uid": uid,
      };
}
