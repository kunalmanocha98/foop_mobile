import 'package:oho_works_app/e_learning_module/ui/lesson_list_response.dart';

import 'chapter_response.dart';

class CreateChaptersResponse {
  String? statusCode;
  String? message;
  ChapterItem? rows;
  int? total;

  CreateChaptersResponse(
      {this.statusCode, this.message, this.rows, this.total});

  CreateChaptersResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new ChapterItem.fromJson(json['rows']) : null;
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


class LessonResponse {
  String? statusCode;
  String? message;
  LessonListItem? rows;
  int? total;

  LessonResponse(
      {this.statusCode, this.message, this.rows, this.total});

  LessonResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new LessonListItem.fromJson(json['rows']) : null;
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