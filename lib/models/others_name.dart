class OthersName {
  String? statusCode;
  String? message;
  List<String>? rows;
  int? total;

  OthersName({this.statusCode, this.message, this.rows, this.total});

  OthersName.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'].cast<String>();
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
