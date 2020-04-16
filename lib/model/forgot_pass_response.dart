import 'dart:convert';

ForgotPassResponse forgotPassResponseFromJson(String str) => ForgotPassResponse.fromJson(json.decode(str));

String forgotPassResponseToJson(ForgotPassResponse data) => json.encode(data.toJson());

class ForgotPassResponse {
  bool updateStatus;
  String message;

  ForgotPassResponse({
    this.updateStatus,
    this.message,
  });

  factory ForgotPassResponse.fromJson(Map<String, dynamic> json) => new ForgotPassResponse(
    updateStatus: json["updateStatus"] == null ? null : json["updateStatus"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "updateStatus": updateStatus == null ? null : updateStatus,
    "message": message == null ? null : message,
  };
}