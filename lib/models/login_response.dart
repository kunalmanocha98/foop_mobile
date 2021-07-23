class LoginResponse {
  String? statusCode;
  String? message;
  Data? rows;

  LoginResponse({this.statusCode, this.message, this.rows});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Data.fromJson(json['rows']) : null;
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

class Data {
  String? expiry;
  String? token;

  Data({this.expiry, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    expiry = json['expiry'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiry'] = this.expiry;
    data['token'] = this.token;
    return data;
  }
}
