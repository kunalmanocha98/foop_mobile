class CommonMixins {

  String? validateWebLink(String? value) {
    if (value!.isEmpty) {
      return null;
    } else {
      var regex = new RegExp(r"((https?:www\.)|(https?:\/\/)|(www\.))?[\w\-?=%.][-a-zA-Z0-9@:%.\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%\+.~#?&\/=]*)?");
      var matchRegex =regex.hasMatch(value);
      if(matchRegex)
        return null;
      else
        return 'Enter a valid web-link';
    }
  }

  String? validateTextField(String? value) {
    if (value!.isEmpty) {
      return "This field is empty";
    } else {
      return null;
    }
  }

  String? validateEmail(String? value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value!))
      return 'Enter a valid Email Address';
    else
      return null;
  }
}
