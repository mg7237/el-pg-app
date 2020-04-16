import 'package:email_validator/email_validator.dart';

class LoginRequestModel {
  String email;
  String password;
  String phoneNumber;
  String otp;

  Map<String, dynamic> toMap() => {
        "user": email,
        "password": password,
      };


  /// To validate email in login form
  String emailValidate(String value) {
    if (value.isNotEmpty) {
      if (EmailValidator.validate(value)) {
        return null;
      } else {
        return "Enter valid email.";
      }
    } else {
      return "Enter your email.";
    }
  }

  /// To validate password in login form
  String passwordValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your password.";
    }
  }

  /// To validate phone number in login form
  String phoneValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your phone number.";
    }
  }

  /// To validate phone number in login form
  String otpValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your OTP.";
    }
  }
}
