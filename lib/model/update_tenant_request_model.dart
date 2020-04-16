import 'dart:io';

import 'package:email_validator/email_validator.dart';

class UpdateTenantRequestModel {
  String tenantId, pgId, fullName, email, phoneNumber, joinDate, exitDate;
  String address1, address2, city, state, pinCode;
  String roomNumber, rent, maintenance, deposit;
  String emContactNumber, emContactName, emContactEmail, employeeName;
  File profileImg, idDoc1, idDoc2, employeeId;
  String idType1 = '', idType2 = '';
  String document1_del = '', document2_del = '';

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

  /// To validate full name
  String fullNameValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your full name.";
    }
  }

  /// To validate full name
  String phoneValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your phone number.";
    }
  }

  String joinDateValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your join date.";
    }
  }

  String addressValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your address.";
    }
  }

  String cityValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your city.";
    }
  }

  String stateValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your state.";
    }
  }

  String pinValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter your pin code.";
    }
  }

  String roomNumberValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter room number.";
    }
  }

  String rentValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter rent.";
    }
  }

  String maintenanceValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter maintenance.";
    }
  }

  String depositValidate(String value) {
    if (value.isNotEmpty) {
      return null;
    } else {
      return "Enter deposit.";
    }
  }
}
