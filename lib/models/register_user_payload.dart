class RegisterUserPayload {
  String? fbId;
  String? googleId;
  String? firstName;
  String? lastName;
  String? email;
  String? password;
  int? mobile;
  int? gender;
  String? dob;
  int? token;
  String? reason;
String? mobileCountryCode;
  RegisterUserPayload(
      {this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.mobile,
      this.gender,
      this.token,
      this.reason,
        this.mobileCountryCode,
      this.dob});

  RegisterUserPayload.fromJson(Map<String, dynamic> json) {
    fbId = json['fb_provider_id'];
    mobileCountryCode=json['mobile_country_code'];
    googleId = json['g_provider_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    password = json['password'];
    mobile = json['mobile'];
    gender = json['gender'];
    dob = json['dob'];
    reason = json['otp_reason'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fb_provider_id'] = this.fbId;
    data['mobile_country_code'] = this.mobileCountryCode;
    data['g_provider_id'] = this.googleId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['password'] = this.password;
    data['mobile'] = this.mobile;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['token'] = this.token;
    data['otp_reason'] = this.reason;
    return data;
  }
}
