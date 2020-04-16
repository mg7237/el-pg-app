import 'package:email_validator/email_validator.dart';

class OtpRequestModel {
  String phoneNumber;
  String otp;

  Map<String, dynamic> toMap() => {
        "phone": phoneNumber
      };

}
