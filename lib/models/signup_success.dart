class SignUpSuccess {
  String statusCode;
  String message;
  String rows;

  SignUpSuccess({this.statusCode, this.message, this.rows});

  SignUpSuccess.fromJson(Map<String, dynamic> json) {
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
