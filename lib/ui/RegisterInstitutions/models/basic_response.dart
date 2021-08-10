class BasicDataResponse {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;

  BasicDataResponse({this.statusCode, this.message, this.rows, this.total});

  BasicDataResponse.fromJson(Map<String, dynamic> json) {
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
  int? institutionId;
  String? message;

  Rows({this.institutionId, this.message});

  Rows.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['message'] = this.message;
    return data;
  }
}
