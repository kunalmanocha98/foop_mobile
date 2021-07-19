class SubjectResponse {
  String statusCode;
  String message;
  List<SubjectItems> rows;
  int total;

  SubjectResponse({this.statusCode, this.message, this.rows, this.total});

  SubjectResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//SubjectItems>();
      json['rows'].forEach((v) {
        rows.add(new SubjectItems.fromJson(v));
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

class SubjectItems {
  String subjectCategoryName;
  List<Subjects> subjects;

  SubjectItems({this.subjectCategoryName, this.subjects});

  SubjectItems.fromJson(Map<String, dynamic> json) {
    subjectCategoryName = json['subject_category_name'];
    if (json['subjects'] != null) {
      subjects = [];//Subjects>();
      json['subjects'].forEach((v) {
        subjects.add(new Subjects.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_category_name'] = this.subjectCategoryName;
    if (this.subjects != null) {
      data['subjects'] = this.subjects.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subjects {
  int id;
  bool isSelected=false;
  String subjectName;
  String subjectCode;
  String subjectDescription;

  Subjects(
      {this.id, this.subjectName, this.subjectCode, this.subjectDescription,this.isSelected});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectName = json['subject_name'];
    subjectCode = json['subject_code'];
    subjectDescription = json['subject_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject_name'] = this.subjectName;
    data['subject_code'] = this.subjectCode;
    data['subject_description'] = this.subjectDescription;
    return data;
  }
}
