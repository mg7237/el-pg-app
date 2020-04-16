class ViewTenantRequestModel {
  String pgId;
  String tenantId;

  ViewTenantRequestModel({
    this.pgId,
    this.tenantId,
  });

  factory ViewTenantRequestModel.fromMap(Map<String, dynamic> json) => ViewTenantRequestModel(
    pgId: json["pg_id"] == null ? null : json["pg_id"],
    tenantId: json["tenant_id"] == null ? null : json["tenant_id"],
  );

  Map<String, dynamic> toMap() => {
    "pg_id": pgId == null ? null : pgId,
    "tenant_id": tenantId == null ? null : tenantId,
  };
}
