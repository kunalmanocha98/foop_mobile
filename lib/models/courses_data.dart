class CourseData {
  String statusCode;
  String message;
  List<CoursesItem> rows;

  CourseData({this.statusCode, this.message, this.rows});

  CourseData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//CoursesItem>();
      json['rows'].forEach((v) {
        rows.add(new CoursesItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CoursesItem {
  String courseName;
  Null courseCode;
  String courseDescription;
  Null courseTypeId;
  int courseId;

  CoursesItem(
      {this.courseName,
      this.courseCode,
      this.courseDescription,
      this.courseTypeId,
      this.courseId});

  CoursesItem.fromJson(Map<String, dynamic> json) {
    courseName = json['course_name'];
    courseCode = json['course_code'];
    courseDescription = json['course_description'];
    courseTypeId = json['course_type_id'];
    courseId = json['course_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['course_name'] = this.courseName;
    data['course_code'] = this.courseCode;
    data['course_description'] = this.courseDescription;
    data['course_type_id'] = this.courseTypeId;
    data['course_id'] = this.courseId;
    return data;
  }
}
