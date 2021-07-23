class VerifyRequestModel {
  int? id;
  int? buddyApprovalId;
  String? questionResponse;

  VerifyRequestModel({this.id, this.buddyApprovalId, this.questionResponse});

  VerifyRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buddyApprovalId = json['buddy_approval_id'];
    questionResponse = json['question_response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buddy_approval_id'] = this.buddyApprovalId;
    data['question_response'] = this.questionResponse;
    return data;
  }
}

class VerifyResponseModel {
  String? statusCode;
  String? message;
  VerifyResponseRow? rows;
  int? total;

  VerifyResponseModel({this.statusCode, this.message, this.rows, this.total});

  VerifyResponseModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new VerifyResponseRow.fromJson(json['rows']) : null;
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

class VerifyResponseRow {
  String? personName;
  String? institutionName;
  String? role;

  VerifyResponseRow({this.personName, this.institutionName, this.role});

  VerifyResponseRow.fromJson(Map<String, dynamic> json) {
    personName = json['person_name'];
    institutionName = json['institution_name'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_name'] = this.personName;
    data['institution_name'] = this.institutionName;
    data['role'] = this.role;
    return data;
  }
}