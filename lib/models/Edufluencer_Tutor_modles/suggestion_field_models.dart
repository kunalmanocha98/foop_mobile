class SubjectListResponse {
  String statusCode;
  String message;
  List<SubjectListItem> rows;
  int total;

  SubjectListResponse({this.statusCode, this.message, this.rows, this.total});

  SubjectListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//SubjectListItem>();
      json['rows'].forEach((v) {
        rows.add(new SubjectListItem.fromJson(v));
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

class SubjectListItem {
  String subjectName;
  String subjectCode;
  String subjectDescription;
  int subjectId;

  SubjectListItem(
      {this.subjectName,
        this.subjectCode,
        this.subjectDescription,
        this.subjectId});

  SubjectListItem.fromJson(Map<String, dynamic> json) {
    subjectName = json['subject_name'];
    subjectCode = json['subject_code'];
    subjectDescription = json['subject_description'];
    subjectId = json['subject_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_name'] = this.subjectName;
    data['subject_code'] = this.subjectCode;
    data['subject_description'] = this.subjectDescription;
    data['subject_id'] = this.subjectId;
    return data;
  }
}



class ClassListResponse {
  String statusCode;
  String message;
  List<ClassListItem> rows;
  int total;

  ClassListResponse({this.statusCode, this.message, this.rows, this.total});

  ClassListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ClassListItem>();
      json['rows'].forEach((v) {
        rows.add(new ClassListItem.fromJson(v));
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

class ClassListItem {
  String className;
  String classCode;
  String classDescription;
  int classId;

  ClassListItem({this.className, this.classCode, this.classDescription, this.classId});

  ClassListItem.fromJson(Map<String, dynamic> json) {
    className = json['class_name'];
    classCode = json['class_code'];
    classDescription = json['class_description'];
    classId = json['class_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_name'] = this.className;
    data['class_code'] = this.classCode;
    data['class_description'] = this.classDescription;
    data['class_id'] = this.classId;
    return data;
  }
}