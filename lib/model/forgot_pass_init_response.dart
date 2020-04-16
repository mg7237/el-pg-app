import 'dart:convert';

ForgotPassInitResponse forgotPassInitResponseFromJson(String str) => ForgotPassInitResponse.fromJson(json.decode(str));

String forgotPassInitResponseToJson(ForgotPassInitResponse data) => json.encode(data.toJson());

class ForgotPassInitResponse {
  bool initStatus;
  String message;

  ForgotPassInitResponse({
    this.initStatus,
    this.message,
  });

  factory ForgotPassInitResponse.fromJson(Map<String, dynamic> json) => new ForgotPassInitResponse(
    initStatus: json["initStatus"] == null ? null : json["initStatus"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "initStatus": initStatus == null ? null : initStatus,
    "message": message == null ? null : message,
  };
}
