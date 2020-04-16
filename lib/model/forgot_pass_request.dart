class ForgotPasswordRequest {
  String securityCode;
  String newPassword1;
  String newPassword2;
  String user;

  Map<String, dynamic> toMap() => {
        "securityCode": securityCode,
        "newPassword1": newPassword1,
        "newPassword2": newPassword2,
        "user": user,
      };

  String validateSecurityCode(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your securty code.";
    }
  }

  String validateNewPassword1(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your new password.";
    }
  }

  String validateNewPassword2(String pas1, String pass2) {
    if (pas1.isNotEmpty) {
      if (pas1 == pass2) {
        return null;
      } else {
        return "Password not match.";
      }
    } else {
      return "Confirm your new password.";
    }
  }
}
