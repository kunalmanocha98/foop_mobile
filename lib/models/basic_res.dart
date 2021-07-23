class BasicRes {
  String? statusCode;
  String? message;
  BasicRes({this.statusCode, this.message});
  BasicRes.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    return data;
  }
}


