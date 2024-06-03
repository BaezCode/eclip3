class Grupo {
  Grupo({
    required this.nombre,
    required this.img,
    required this.integrantes,
    required this.admins,
    required this.leido,
    this.token,
    this.channelName,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  String nombre;
  String img;
  List<String> integrantes;
  List<String> admins;
  List<String> leido;
  String? token;
  String? channelName;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  factory Grupo.fromJson(Map<String, dynamic> json) => Grupo(
        nombre: json["nombre"],
        img: json["img"],
        token: json["token"],
        channelName: json["channelName"],
        integrantes: List<String>.from(json["integrantes"].map((x) => x)),
        admins: List<String>.from(json["admins"].map((x) => x)),
        leido: List<String>.from(json["leido"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "img": img,
        "token": token,
        "channelName": channelName,
        "integrantes": List<dynamic>.from(integrantes.map((x) => x)),
        "admins": List<dynamic>.from(admins.map((x) => x)),
        "leido": List<dynamic>.from(leido.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "uid": uid,
      };
}
