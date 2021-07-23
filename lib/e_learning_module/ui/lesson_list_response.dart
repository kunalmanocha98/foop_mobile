class LessonListResponse {
  String? statusCode;
  String? message;
  List<LessonListItem>? rows;
  int? total;

  LessonListResponse({this.statusCode, this.message, this.rows, this.total});

  LessonListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//LessonListItem>();
      json['rows'].forEach((v) {
        rows!.add(new LessonListItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class LessonListItem {
  int? id;
  String? lessonName;
  String? referenceType;
  int? referenceId;

  LessonListItem({this.id, this.lessonName, this.referenceType, this.referenceId});

  LessonListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lessonName = json['lesson_name'];
    referenceType = json['reference_type'];
    referenceId = json['reference_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['lesson_name'] = this.lessonName;
    data['reference_type'] = this.referenceType;
    data['reference_id'] = this.referenceId;
    return data;
  }
}
