// To parse this JSON data, do
//
//     final addTenantResponse = addTenantResponseFromJson(jsonString);

import 'dart:convert';

AddTenantResponse addTenantResponseFromJson(String str) =>
    AddTenantResponse.fromMap(json.decode(str));

String addTenantResponseToJson(AddTenantResponse data) =>
    json.encode(data.toMap());

class AddTenantResponse {
  bool status;
  String message;
  List<String> errors;

  AddTenantResponse({
    this.status,
    this.message,
    this.errors,
  });

  factory AddTenantResponse.fromMap(Map<String, dynamic> json) =>
      AddTenantResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        errors: json["status"]
            ? null
            : json["errors"] == null ? null : List<String>.from(json["errors"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
    "errors": errors == null ? null : List<dynamic>.from(errors.map((x) => x)),
      };
}
