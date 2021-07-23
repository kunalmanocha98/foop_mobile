class AlreadyExistingUser {
  String? statusCode;
  String? message;
  SocialLogin? rows;

  AlreadyExistingUser({this.statusCode, this.message, this.rows});

  AlreadyExistingUser.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new SocialLogin.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class SocialLogin {
  Null expiry;
  String? token;
  bool? isExisted;

  SocialLogin({this.expiry, this.token, this.isExisted});

  SocialLogin.fromJson(Map<String, dynamic> json) {
    expiry = json['expiry'];
    token = json['token'];
    isExisted = json['isExisted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiry'] = this.expiry;
    data['token'] = this.token;
    data['isExisted'] = this.isExisted;
    return data;
  }
}
