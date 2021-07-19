import 'package:oho_works_app/models/post/postlist.dart';

class MediaFiles {
  String statusCode;
  String message;
  List<Media> rows;
  int total;

  MediaFiles({this.statusCode, this.message, this.rows, this.total});

  MediaFiles.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = <Media>[];
      json['rows'].forEach((v) {
        rows.add(new Media.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}



