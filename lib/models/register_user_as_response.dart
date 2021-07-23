class RegisterUserAsResponse {
  String? statusCode;
  String? message;
  RegisterUserData? rows;

  RegisterUserAsResponse({this.statusCode, this.message, this.rows});

  RegisterUserAsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new RegisterUserData.fromJson(json['rows'])
        : null;
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

class RegisterUserData {
  String? studentName;
  String? institutionName;
  bool? isVerified;

  RegisterUserData({this.studentName, this.institutionName});

  RegisterUserData.fromJson(Map<String, dynamic> json) {
    studentName = json['student_name'];
    institutionName = json['institution_name'];
    isVerified= json['is_verified'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student_name'] = this.studentName;
    data['institution_name'] = this.institutionName;
    data['is_verified'] = this.isVerified;
    return data;
  }
}
