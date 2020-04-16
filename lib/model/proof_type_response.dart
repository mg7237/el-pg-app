// To parse this JSON data, do
//
//     final proofTypeResponse = proofTypeResponseFromJson(jsonString);

import 'dart:convert';

ProofTypeResponse proofTypeResponseFromJson(String str) => ProofTypeResponse.fromMap(json.decode(str));

String proofTypeResponseToJson(ProofTypeResponse data) => json.encode(data.toMap());

class ProofTypeResponse {
  List<ProofType> proofTypes;
  bool status;
  String message;

  ProofTypeResponse({
    this.proofTypes,
    this.status,
    this.message,
  });

  factory ProofTypeResponse.fromMap(Map<String, dynamic> json) => ProofTypeResponse(
    proofTypes: json["proofTypes"] == null ? null : List<ProofType>.from(json["proofTypes"].map((x) => ProofType.fromMap(x))),
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toMap() => {
    "proofTypes": proofTypes == null ? null : List<dynamic>.from(proofTypes.map((x) => x.toMap())),
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}

class ProofType {
  String name;
  int id;

  ProofType({
    this.name,
    this.id,
  });

  factory ProofType.fromMap(Map<String, dynamic> json) => ProofType(
    name: json["name"] == null ? null : json["name"],
    id: json["id"] == null ? null : json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name == null ? null : name,
    "id": id == null ? null : id,
  };
}
