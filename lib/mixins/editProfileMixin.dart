class EditProfileMixins {
  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value!))
      return 'Enter a valid Email Address';
    else
      return null;
  }

  String? validatePassword(String? value) {
    if (value!.length < 8) {
      return "Minimum 8 character required for Password";
    } else {
      return null;
    }
  }
  bool validatePasswordBool(String value) {
    if (value.length < 8) {
      return false;
    } else {
      return true;
    }
  }
  String? validateFirstName(String value) {
    if (value.isEmpty) {
      return "Please Enter your first name";
    } else {
      return null;
    }
  }

  String? validateLastName(String value) {
    if (value.isEmpty) {
      return "Please enter your last name";
    } else {
      return null;
    }
  }

  String? validateDob(String value) {
    if (value.isEmpty) {
      return "Please select DoB";
    } else {
      return null;
    }
  }

  int  maxLengthValidator(String value,int maxValue) {
    if (value.isEmpty) {
      return 0;
    } else {
     return  value.length;

    }
  }
  // ignore: missing_return
  String? removeLastWord (String? value) {
    var res = value!.split(" ");  //split by space
    res.removeAt(res.length);  //remove last element
    res.join(" ");
  }

  String? validateBioName(String? value) {
    if (value!.isEmpty) {
      return "Please Enter your Bio";
    } else {
      return null;
    }
  }

  String? validateQuote(String value) {
    if (value.isEmpty) {
      return "Please Enter a Qoute";
    } else {
      return null;
    }
  }
}
