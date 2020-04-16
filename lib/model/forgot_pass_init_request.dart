import 'package:email_validator/email_validator.dart';

class ForgotPasswordInitRequest{
  String email;

  Map<String, dynamic> toMap() => {
    "user": email,
  };

  /// To validate email
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
}
