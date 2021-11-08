import 'package:email_validator/email_validator.dart';

class ValidationRepository {
  bool firstNameValidation(String firstName) {
    if (firstName.length > 2) return true;

    return false;
  }

  bool lastNameValidation(String lastName) {
    if (lastName.length > 1) return true;

    return false;
  }

  bool birthdayValidation(int dateTime, int now) {
    var yearsInSeconds = 16 * 365.25 * 24 * 60 * 60;
    if ((now - dateTime) / 1000 < yearsInSeconds) return false;

    return true;
  }

  bool emailValidation(String email) {
    if (EmailValidator.validate(email) == true) return true;
    return false;
  }

  bool phoneNumberValidation(int length, int phoneNumberLength) {
    if (length != phoneNumberLength) return false;
    return true;
  }

  bool userNameValidation(int usernameLength) {
    if (usernameLength < 5) return false;
    return true;
  }

  bool passwordValidation(int passwordLength) {
    if (passwordLength < 8) return false;
    return true;
  }
}
