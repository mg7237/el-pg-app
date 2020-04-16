// To parse this JSON data, do
//
//     final exitTenantResponse = exitTenantResponseFromJson(jsonString);

import 'dart:convert';

ExitTenantResponse exitTenantResponseFromJson(String str) => ExitTenantResponse.fromJson(json.decode(str));

String exitTenantResponseToJson(ExitTenantResponse data) => json.encode(data.toJson());

class ExitTenantResponse {
  bool status;
  String message;
  List<String> errors;
  List<String> warnings;

  ExitTenantResponse({
    this.status,
    this.message,
    this.errors,
    this.warnings,
  });

  factory ExitTenantResponse.fromJson(Map<String, dynamic> json) => ExitTenantResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    errors: json["errors"] == null ? null : List<String>.from(json["errors"].map((x) => x)),
    warnings: json["warnings"] == null ? null : List<String>.from(json["warnings"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "errors": errors == null ? null : List<dynamic>.from(errors.map((x) => x)),
    "warnings": warnings == null ? null : List<dynamic>.from(warnings.map((x) => x)),
  };
}
