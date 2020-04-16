import 'dart:convert';

PgListResponse pgListResponseFromJson(String str) => PgListResponse.fromMap(json.decode(str));

String pgListResponseToJson(PgListResponse data) => json.encode(data.toMap());

class PgListResponse {
  bool status;
  String message;
  List<Data> data;
  String errors;

  PgListResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory PgListResponse.fromMap(Map<String, dynamic> json) => PgListResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Data>.from(json["data"].map((x) => Data.fromMap(x))),
    errors: json["errors"] == null ? null : json["errors"],
  );

  Map<String, dynamic> toMap() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toMap())),
    "errors": errors == null ? null : errors,
  };
}

class Data {
  String id;
  String name;

  Data({
    this.id,
    this.name,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}
