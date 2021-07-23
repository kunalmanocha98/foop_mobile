class RequestResponse {
  String? statusCode;
  String? message;

  int? total;

  RequestResponse({this.statusCode, this.message,  this.total});

  RequestResponse.fromJson(Map<String, dynamic> json) {
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
