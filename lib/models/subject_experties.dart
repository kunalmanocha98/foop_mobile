class SubjectExperties {
  String? statusCode;
  String? message;
  List<SubjectItem>? rows;
  int? total;

  SubjectExperties({this.statusCode, this.message, this.rows, this.total});

  SubjectExperties.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//SubjectItem>();
      json['rows'].forEach((v) {
        rows!.add(new SubjectItem.fromJson(v));
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

class SubjectItem {
  int? id;
  bool isSelected= false;
  String? standardExpertiseCategoryId;
  String? expertiseTypeCode;
  String? expertiseTypeDescription;

  SubjectItem(
      {this.id,
        this.standardExpertiseCategoryId,
        this.expertiseTypeCode,
        this.expertiseTypeDescription});

  SubjectItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    standardExpertiseCategoryId = json['standard_expertise_category_id'];
    expertiseTypeCode = json['expertise_type_code'];
    expertiseTypeDescription = json['expertise_type_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['standard_expertise_category_id'] = this.standardExpertiseCategoryId;
    data['expertise_type_code'] = this.expertiseTypeCode;
    data['expertise_type_description'] = this.expertiseTypeDescription;
    return data;
  }
}
