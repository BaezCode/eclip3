import 'dart:convert';

ChatResponse chatResponseFromJson(String str) =>
    ChatResponse.fromJson(json.decode(str));

String chatResponseToJson(ChatResponse data) => json.encode(data.toJson());

class ChatResponse {
  ChatResponse({
    this.id,
    this.imgURL,
    required this.msg,
    required this.uid,
    required this.contacto,
    required this.badge,
    required this.lastMsgUID,
  });
  int? id;
  String? imgURL;
  String msg;
  String uid;
  String contacto;
  bool badge;
  String lastMsgUID;

  factory ChatResponse.fromJson(Map<String, dynamic> json) => ChatResponse(
        id: json["id"],
        imgURL: json["imgURL"],
        msg: json["msg"],
        uid: json["uid"],
        contacto: json["contacto"],
        badge: json["badge"],
        lastMsgUID: json["lastMsgUID"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "imgURL": imgURL,
        "msg": msg,
        "uid": uid,
        "contacto": contacto,
        "badge": badge,
        "lastMsgUID": lastMsgUID,
      };
}
