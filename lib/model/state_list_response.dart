// To parse this JSON data, do
//
//     final stateListResponse = stateListResponseFromJson(jsonString);

import 'dart:convert';

StateListResponse stateListResponseFromJson(String str) => StateListResponse.fromJson(json.decode(str));

String stateListResponseToJson(StateListResponse data) => json.encode(data.toJson());

class StateListResponse {
  bool status;
  List<States> states;
  String message;

  StateListResponse({
    this.status,
    this.states,
    this.message,
  });

  factory StateListResponse.fromJson(Map<String, dynamic> json) => new StateListResponse(
    status: json["status"],
    states: new List<States>.from(json["states"].map((x) => States.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "states": new List<dynamic>.from(states.map((x) => x.toJson())),
    "message":message,
  };
}

class States {
  String name;
  String code;

  States({
    this.name,
    this.code,
  });

  factory States.fromJson(Map<String, dynamic> json) => new States(
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
  };
}
