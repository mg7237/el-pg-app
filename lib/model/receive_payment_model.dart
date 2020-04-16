import 'dart:io';

class ReceivePaymentModel {
  String tenantId = '',
      propertyId = '',
      amountPaid = '',
      paymentMode = '',
      transactionReference = '',
      remark = '';
  File paymentProofImg;

  ReceivePaymentModel({
    this.tenantId,
    this.propertyId,
    this.amountPaid,
    this.paymentMode,
    this.transactionReference,
    this.paymentProofImg,
    this.remark,
  });

  String amountPaidValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter paid amount.";
    }
  }

  String transactionReferenceValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter transaction reference.";
    }
  }
}
