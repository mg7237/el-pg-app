class ExitTenantRequestModel {
  String propertyId;
  String tenantId;
  String exitDate;
  String exitReason;

  ExitTenantRequestModel({
    this.propertyId,
    this.tenantId,
    this.exitDate,
    this.exitReason,
  });

  factory ExitTenantRequestModel.fromMap(Map<String, dynamic> json) =>
      ExitTenantRequestModel(
        propertyId: json["property_id"] == null ? null : json["property_id"],
        tenantId: json["tenant_id"] == null ? null : json["tenant_id"],
        exitDate: json["exit_date"] == null ? null : json["exit_date"],
        exitReason: json["exit_reason"] == null ? null : json["exit_reason"],
      );

  Map<String, dynamic> toMap() => {
        "property_id": propertyId == null ? null : propertyId,
        "tenant_id": tenantId == null ? null : tenantId,
        "exit_date": exitDate == null ? null : exitDate,
        "exit_reason": exitReason == null ? null : exitReason,
      };
}
