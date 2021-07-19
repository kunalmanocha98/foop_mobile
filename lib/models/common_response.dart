class CommonBasicResponse {
  String statusCode;
  String message;
  DataAfterOptVerification rows;

  CommonBasicResponse({this.statusCode, this.message, this.rows});

  CommonBasicResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new DataAfterOptVerification.fromJson(json['rows'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    return data;
  }
}

class DataAfterOptVerification {
  String expiry;
  String token;
  int userId;
  DataAfterOptVerification({this.expiry, this.token});

  DataAfterOptVerification.fromJson(Map<String, dynamic> json) {
    expiry = json['expiry'];
    token = json['token'];
    userId = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['expiry'] = this.expiry;
    data['token'] = this.token;
    data['id'] = this.userId;
    return data;
  }
}
