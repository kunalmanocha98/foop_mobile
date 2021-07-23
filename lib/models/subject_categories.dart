class SubjectsCategories {
  String? statusCode;
  String? message;
  List<SubjectsItem>? rows;

  SubjectsCategories({this.statusCode, this.message, this.rows});

  SubjectsCategories.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//SubjectsItem>();
      json['rows'].forEach((v) {
        rows!.add(new SubjectsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubjectsItem {
  String? subjectCategoryName;
  String? subjectCategoryCode;
  String? subjectCategoryDescription;
  int? subjectCategoryId;

  SubjectsItem(
      {this.subjectCategoryName,
      this.subjectCategoryCode,
      this.subjectCategoryDescription,
      this.subjectCategoryId});

  SubjectsItem.fromJson(Map<String, dynamic> json) {
    subjectCategoryName = json['subject_category_name'];
    subjectCategoryCode = json['subject_category_code'];
    subjectCategoryDescription = json['subject_category_description'];
    subjectCategoryId = json['subject_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_category_name'] = this.subjectCategoryName;
    data['subject_category_code'] = this.subjectCategoryCode;
    data['subject_category_description'] = this.subjectCategoryDescription;
    data['subject_category_id'] = this.subjectCategoryId;
    return data;
  }
}
