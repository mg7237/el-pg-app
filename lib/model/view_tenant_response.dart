// To parse this JSON data, do
//
//     final viewTenantResponse = viewTenantResponseFromJson(jsonString);

import 'dart:convert';

ViewTenantResponse viewTenantResponseFromJson(String str) => ViewTenantResponse.fromMap(json.decode(str));

String viewTenantResponseToJson(ViewTenantResponse data) => json.encode(data.toMap());

class ViewTenantResponse {
  bool status;
  String message;
  Data data;
  String errors;

  ViewTenantResponse({
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  factory ViewTenantResponse.fromMap(Map<String, dynamic> json) => ViewTenantResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromMap(json["data"]),
    errors: json["errors"] == null ? null : json["errors"],
  );

  Map<String, dynamic> toMap() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : data.toMap(),
    "errors": errors == null ? null : errors,
  };
}

class Data {
  String id;
  String profileImage;
  String name;
  String email;
  String mobile;
  DateTime joinDate;
  DateTime exitDate;
  String addressLine1;
  String addressLine2;
  String city;
  String state;
  String pincode;
  String documentType1;
  String idDocument1;
  String documentType2;
  String idDocument2;
  String roomName;
  String rent;
  String maintenance;
  String deposit;
  String emergencyContactName;
  String emergencyContactNumber;
  String emergencyContactEmail;
  String employerName;
  String employeeIdProof;

  Data({
    this.id,
    this.profileImage,
    this.name,
    this.email,
    this.mobile,
    this.joinDate,
    this.exitDate,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.pincode,
    this.documentType1,
    this.idDocument1,
    this.documentType2,
    this.idDocument2,
    this.roomName,
    this.rent,
    this.maintenance,
    this.deposit,
    this.emergencyContactName,
    this.emergencyContactNumber,
    this.emergencyContactEmail,
    this.employerName,
    this.employeeIdProof,
  });

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    profileImage: json["profile_image"] == null ? null : json["profile_image"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    mobile: json["mobile"] == null ? null : json["mobile"],
    joinDate: json["join_date"] == null ? null : DateTime.parse(json["join_date"]),
    exitDate: json["exit_date"] == null ? null : DateTime.parse(json["exit_date"]),
    addressLine1: json["address_line_1"] == null ? null : json["address_line_1"],
    addressLine2: json["address_line_2"] == null ? null : json["address_line_2"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    pincode: json["pincode"] == null ? null : json["pincode"],
    documentType1: json["document_type_1"],
    idDocument1: json["id_document_1"],
    documentType2: json["document_type_2"],
    idDocument2: json["id_document_2"],
    roomName: json["room_name"],
    rent: json["rent"] == null ? null : json["rent"],
    maintenance: json["maintenance"] == null ? null : json["maintenance"],
    deposit: json["deposit"] == null ? null : json["deposit"],
    emergencyContactName: json["emergency_contact_name"] == null ? null : json["emergency_contact_name"],
    emergencyContactNumber: json["emergency_contact_number"] == null ? null : json["emergency_contact_number"],
    emergencyContactEmail: json["emergency_contact_email"] == null ? null : json["emergency_contact_email"],
    employerName: json["employer_name"] == null ? null : json["employer_name"],
    employeeIdProof: json["employee_id_proof"] == null ? null : json["employee_id_proof"],
  );

  Map<String, dynamic> toMap() => {
    "id": id == null ? null : id,
    "profile_image": profileImage == null ? null : profileImage,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "mobile": mobile == null ? null : mobile,
    "join_date": joinDate == null ? null : "${joinDate.year.toString().padLeft(4, '0')}-${joinDate.month.toString().padLeft(2, '0')}-${joinDate.day.toString().padLeft(2, '0')}",
    "exit_date": exitDate == null ? null : "${exitDate.year.toString().padLeft(4, '0')}-${exitDate.month.toString().padLeft(2, '0')}-${exitDate.day.toString().padLeft(2, '0')}",
    "address_line_1": addressLine1 == null ? null : addressLine1,
    "address_line_2": addressLine2 == null ? null : addressLine2,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "pincode": pincode == null ? null : pincode,
    "document_type_1": documentType1,
    "id_document_1": idDocument1,
    "document_type_2": documentType2,
    "id_document_2": idDocument2,
    "room_name": roomName,
    "rent": rent == null ? null : rent,
    "maintenance": maintenance == null ? null : maintenance,
    "deposit": deposit == null ? null : deposit,
    "emergency_contact_name": emergencyContactName == null ? null : emergencyContactName,
    "emergency_contact_number": emergencyContactNumber == null ? null : emergencyContactNumber,
    "emergency_contact_email": emergencyContactEmail == null ? null : emergencyContactEmail,
    "employer_name": employerName == null ? null : employerName,
    "employee_id_proof": employeeIdProof == null ? null : employeeIdProof,
  };
}
