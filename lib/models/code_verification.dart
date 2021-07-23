class CodeVerification {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;

  CodeVerification({this.statusCode, this.message, this.rows, this.total});

  CodeVerification.fromJson(Map<String, dynamic> json) {
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
  bool? isValid;

  Rows({this.isValid});

  Rows.fromJson(Map<String, dynamic> json) {
    isValid = json['is_valid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_valid'] = this.isValid;
    return data;
  }
}
