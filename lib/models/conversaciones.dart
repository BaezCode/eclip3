import 'package:eclips_3/models/msg_model.dart';

class Conversaciones {
  Conversaciones({
    required this.de,
    required this.para,
    required this.msg,
    required this.lastMsgUid,
    required this.badge,
    required this.createdAt,
    required this.updatedAt,
    required this.uid,
  });

  String de;
  String para;
  List<MsgModel> msg;
  String lastMsgUid;
  bool badge;
  DateTime createdAt;
  DateTime updatedAt;
  String uid;

  factory Conversaciones.fromJson(Map<String, dynamic> json) => Conversaciones(
        de: json["de"],
        para: json["para"],
        msg: List<MsgModel>.from(json["msg"].map((x) => MsgModel.fromJson(x))),
        lastMsgUid: json["lastMsgUID"],
        badge: json["badge"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "de": de,
        "para": para,
        "msg": List<dynamic>.from(msg.map((x) => x.toJson())),
        "lastMsgUID": lastMsgUid,
        "badge": badge,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "uid": uid,
      };
}
