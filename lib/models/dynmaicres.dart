class DynamicResponse {
  String statusCode;
  String message;
  dynamic rows;

  DynamicResponse({this.statusCode, this.message, this.rows});

  DynamicResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['rows'] = this.rows;
    return data;
  }
}
