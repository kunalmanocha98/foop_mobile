import 'package:oho_works_app/models/post/postcreate.dart';

class SaveAsDraftResponse {
  String statusCode;
  String message;
  PostCreatePayload rows;
  int total;

  SaveAsDraftResponse({this.statusCode, this.message, this.rows, this.total});

  SaveAsDraftResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new PostCreatePayload.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}


