// To parse this JSON data, do
//
//     final pgTenantListResponse = pgTenantListResponseFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

PgTenantListResponse pgTenantListResponseFromJson(String str) =>
    PgTenantListResponse.fromMap(json.decode(str));

String pgTenantListResponseToJson(PgTenantListResponse data) =>
    json.encode(data.toMap());

class PgTenantListResponse {
  bool status;
  String message;
  List<Datum> data;
  String errors;

  PgTenantListResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory PgTenantListResponse.fromMap(Map<String, dynamic> json) =>
      PgTenantListResponse(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
        errors: json["errors"] == null ? null : json["errors"],
      );

  Map<String, dynamic> toMap() => {
        "status": status == null ? null : status,
        "message": message == null ? null : message,
        "data": data == null
            ? null
            : List<dynamic>.from(data.map((x) => x.toMap())),
        "errors": errors == null ? null : errors,
      };
}

class Datum {
  String id;
  String name;
  String phone;
  String email;
  String rent;
  String maintenance;
  String deposit;
  DateTime memberSince;
  DateTime exitDate;
  String roomNo;
  String totalDue;
  DateTime dueDate;
  bool overdue;

  Datum({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.rent,
    this.maintenance,
    this.deposit,
    this.memberSince,
    this.exitDate,
    this.roomNo,
    this.totalDue,
    this.dueDate,
    this.overdue,
  });

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
        rent: json["rent"] == null ? null : json["rent"],
        maintenance: json["maintenance"] == null ? null : json["maintenance"],
        deposit: json["deposit"] == null ? null : json["deposit"],
        totalDue: json["total_due"] == null ? null : json["total_due"],
        overdue: json["overdue"] == null ? null : json["overdue"],
        memberSince: json["member_since"] == null
            ? null
            : DateTime.parse(json["member_since"]),
        exitDate: json["exit_date"] == null
            ? null
            : DateTime.parse(json["exit_date"]),
        roomNo: json["room_no"] == null ? null : json["room_no"],
        dueDate: json["due_date"] == null || json["due_date"] == '' ? null : DateFormat('dd-MM-yyyy').parse(json["due_date"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
        "rent": rent == null ? null : rent,
        "maintenance": maintenance == null ? null : maintenance,
        "deposit": deposit == null ? null : deposit,
        "total_due": totalDue == null ? null : totalDue,
        "overdue": overdue == null ? null : overdue,
        "member_since": memberSince == null
            ? null
            : "${memberSince.year.toString().padLeft(4, '0')}-${memberSince.month.toString().padLeft(2, '0')}-${memberSince.day.toString().padLeft(2, '0')}",
        "exit_date": exitDate == null
            ? null
            : "${exitDate.year.toString().padLeft(4, '0')}-${exitDate.month.toString().padLeft(2, '0')}-${exitDate.day.toString().padLeft(2, '0')}",
        "room_no": roomNo == null ? null : roomNo,
        "due_date": dueDate == null ? null : dueDate,
      };
}