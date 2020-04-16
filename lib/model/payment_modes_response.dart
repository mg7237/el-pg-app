// To parse this JSON data, do
//
//     final paymentModesListResponse = paymentModesListResponseFromJson(jsonString);

import 'dart:convert';

PaymentModesListResponse paymentModesListResponseFromJson(String str) => PaymentModesListResponse.fromJson(json.decode(str));

String paymentModesListResponseToJson(PaymentModesListResponse data) => json.encode(data.toJson());

class PaymentModesListResponse {
  List<Mode> modes;
  bool status;
  String message;

  PaymentModesListResponse({
    this.modes,
    this.status,
    this.message,
  });

  factory PaymentModesListResponse.fromJson(Map<String, dynamic> json) => PaymentModesListResponse(
    modes: List<Mode>.from(json["modes"].map((x) => Mode.fromJson(x))),
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "modes": List<dynamic>.from(modes.map((x) => x.toJson())),
    "status": status,
    "message": message,
  };
}

class Mode {
  String name;
  int id;

  Mode({
    this.name,
    this.id,
  });

  factory Mode.fromJson(Map<String, dynamic> json) => Mode(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}
