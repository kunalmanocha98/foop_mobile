import 'package:oho_works_app/models/post/postlist.dart';

class PostViewResponse {
  String? statusCode;
  String? message;
  PostListItem? rows;
  int? total;

  PostViewResponse({this.statusCode, this.message, this.rows, this.total});

  PostViewResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new PostListItem.fromJson(json['rows']) : null;
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


