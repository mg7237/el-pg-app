// To parse this JSON data, do
//
//     final otpResponse = otpResponseFromJson(jsonString);

import 'dart:convert';

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromMap(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toMap());

class OtpResponse {
  String otp;
  String message;
  String userType;
  bool forceChangePassword;
  String xApiKey;
  int userId;
  bool status;
  bool emailStatus;
  bool smsStatus;

  OtpResponse({
    this.otp,
    this.message,
    this.userType,
    this.forceChangePassword,
    this.xApiKey,
    this.userId,
    this.status,
    this.emailStatus,
    this.smsStatus,
  });

  factory OtpResponse.fromMap(Map<String, dynamic> json) => OtpResponse(
    otp: json["OTP"] == null ? null : json["OTP"].toString(),
    message: json["message"] == null ? null : json["message"],
    userType: json["userType"] == null ? null : json["userType"],
    forceChangePassword: json["forceChangePassword"] == null ? null : json["forceChangePassword"],
    xApiKey: json["x-api-key"] == null ? null : json["x-api-key"],
    userId: json["user_id"] == null ? null : json["user_id"],
    status: json["status"] == null ? null : json["status"],
    emailStatus: json["emailStatus"] == null ? null : json["emailStatus"],
    smsStatus: json["smsStatus"] == null ? null : json["smsStatus"],
  );

  Map<String, dynamic> toMap() => {
    "OTP": otp == null ? null : otp,
    "message": message == null ? null : message,
    "userType": userType == null ? null : userType,
    "forceChangePassword": forceChangePassword == null ? null : forceChangePassword,
    "x-api-key": xApiKey == null ? null : xApiKey,
    "user_id": userId == null ? null : userId,
    "status": status == null ? null : status,
    "emailStatus": emailStatus == null ? null : emailStatus,
    "smsStatus": smsStatus == null ? null : smsStatus,
  };
}