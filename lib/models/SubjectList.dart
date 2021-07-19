class SubjectList {
  String statusCode;
  String message;
  List<Subjects> rows;

  SubjectList({this.statusCode, this.message, this.rows});

  SubjectList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//Subjects>();
      json['rows'].forEach((v) {
        rows.add(new Subjects.fromJson(v));
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

class Subjects {
  int id;
  String subjectCode;
  String subjectName;
  Null subjectCredits;
  int isSelected = 0;
  String subject_category_name;
  String subjectDescription;

  Subjects(
      {this.id,
      this.subjectCode,
      this.subjectName,
      this.subjectCredits,
        this.subject_category_name,
      this.subjectDescription});

  Subjects.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectCode = json['subject_code'];
    subjectName = json['subject_name'];
    subject_category_name=json['subject_category_name'];
    subjectCredits = json['subject_credits'];
    isSelected = json['isSelected'];
    subjectDescription = json['subject_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject_code'] = this.subjectCode;
    data['subject_name'] = this.subjectName;
    data['subject_category_name']=this.subject_category_name;
    data['subject_credits'] = this.subjectCredits;
    data['isSelected'] = this.isSelected;
    data['subject_description'] = this.subjectDescription;
    return data;
  }
}
