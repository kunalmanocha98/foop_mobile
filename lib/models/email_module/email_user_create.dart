class EmailUserCreateRequest {
  String? emailId;
  String? password;
  int? customerEmailDetailsId;
  String? emailRecoveryEmailId;
  String? firstName;
  String? lastName;
  int? emailPersonId;

  EmailUserCreateRequest(
      {this.emailId,
        this.password,
        this.customerEmailDetailsId,
        this.emailRecoveryEmailId,
        this.firstName,
        this.lastName,
        this.emailPersonId});

  EmailUserCreateRequest.fromJson(Map<String, dynamic> json) {
    emailId = json['email_id'];
    password = json['password'];
    customerEmailDetailsId = json['customer_email_details_id'];
    emailRecoveryEmailId = json['email_recovery_email_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailPersonId = json['email_person_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_id'] = this.emailId;
    data['password'] = this.password;
    data['customer_email_details_id'] = this.customerEmailDetailsId;
    data['email_recovery_email_id'] = this.emailRecoveryEmailId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email_person_id'] = this.emailPersonId;
    return data;
  }
}

class EmailUserExistResponse {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;

  EmailUserExistResponse(
      {this.statusCode, this.message, this.rows, this.total});

  EmailUserExistResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Rows {
  late bool isExists;

  Rows({this.isExists= false});

  Rows.fromJson(Map<String, dynamic> json) {
    isExists = json['is_existed']!=null?json['is_existed']:false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_existed'] = this.isExists;
    return data;
  }
}

class CreateEmailUserResponse {
  String? statusCode;
  String? message;
  int? total;

  CreateEmailUserResponse({this.statusCode, this.message, this.total});

  CreateEmailUserResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    return data;
  }
}
