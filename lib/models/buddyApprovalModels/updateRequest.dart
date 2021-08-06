class RequestUpdateRequestModel {
  int? institutionId;
  int? institutionUserId;
  String? assignmentStatus;

  RequestUpdateRequestModel(
      {this.institutionId, this.institutionUserId, this.assignmentStatus});

  RequestUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    institutionUserId = json['institution_user_id'];
    assignmentStatus = json['assignment_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['institution_user_id'] = this.institutionUserId;
    data['assignment_status'] = this.assignmentStatus;
    return data;
  }
}

class RequestUpdateResponseModel {
  String? statusCode;
  String? message;
  Null rows;
  int? total;

  RequestUpdateResponseModel(
      {this.statusCode, this.message, this.rows, this.total});

  RequestUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['rows'] = this.rows;
    data['total'] = this.total;
    return data;
  }
}