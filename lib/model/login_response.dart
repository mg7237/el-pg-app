import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  bool authResult;
  String userType;
  bool forceChangePassword;
  String message;
  String x_api_key;
  String userId;

  LoginResponse({
    this.authResult,
    this.userType,
    this.forceChangePassword,
    this.x_api_key,
    this.message,
    this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => new LoginResponse(
        authResult: json["authResult"] == null ? null : json["authResult"],
        userType: json["userType"] == null ? null : json["userType"],
        forceChangePassword: json["forceChangePassword"] == null ? null : json["forceChangePassword"],
        message: json["message"] == null ? null : json["message"],
        userId: json["userId"] == null ? null : json["userId"].toString(),
        x_api_key: json["x-api-key"] == null ? null : json["x-api-key"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "authResult": authResult == null ? null : authResult,
        "userType": userType == null ? null : userType,
        "forceChangePassword": forceChangePassword == null ? null : forceChangePassword,
        "message": message == null ? null : message,
        "userId": userId == null ? null : userId,
      };
}
