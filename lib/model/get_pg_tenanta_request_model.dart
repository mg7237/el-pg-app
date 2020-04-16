class GetPGTenantRequestModel {
  String pgId = '';
  String term = '';
  String status = '';

  GetPGTenantRequestModel({this.pgId, this.term, this.status});

  Map<String, dynamic> toMap() => {
    "pg_id": pgId,
    "term": term,
    "status": status,
  };
}
