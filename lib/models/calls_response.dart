// To parse this JSON data, do
//
//     final callsResponse = callsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:eclips_3/models/calls_model.dart';

CallsResponse callsResponseFromJson(String str) =>
    CallsResponse.fromJson(json.decode(str));

String callsResponseToJson(CallsResponse data) => json.encode(data.toJson());

class CallsResponse {
  List<Call> calls;

  CallsResponse({
    required this.calls,
  });

  factory CallsResponse.fromJson(Map<String, dynamic> json) => CallsResponse(
        calls: List<Call>.from(json["calls"].map((x) => Call.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "calls": List<dynamic>.from(calls.map((x) => x.toJson())),
      };
}
