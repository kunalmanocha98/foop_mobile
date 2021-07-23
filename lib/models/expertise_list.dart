class ExpertiseList {
  String? statusCode;
  String? message;
  List<LanguageItem>? rows;
  int? total;

  ExpertiseList({this.statusCode, this.message, this.rows, this.total});

  ExpertiseList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//LanguageItem>();
      json['rows'].forEach((v) {
        rows!.add(new LanguageItem.fromJson(v));
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

class LanguageItem {
  int? id;
  bool? isSelected = false;
  int? standardExpertiseCategoryId;
  String? expertiseTypeCode;
  String? expertiseTypeDescription;
String? standardExpertiseCategoryTypeId;

  LanguageItem(
      {this.id,
        this.standardExpertiseCategoryId,
        this.expertiseTypeCode,
        this.isSelected,
        this.standardExpertiseCategoryTypeId,
        this.expertiseTypeDescription});

  LanguageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    standardExpertiseCategoryTypeId = json['standardExpertiseCategoryTypes_id'];
    standardExpertiseCategoryId = json['standard_expertise_category_id'];
    expertiseTypeCode = json['expertise_type_code'];
    expertiseTypeDescription = json['expertise_type_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['standardExpertiseCategoryTypes_id'] =
        this.standardExpertiseCategoryTypeId;
    data['standard_expertise_category_id'] = this.standardExpertiseCategoryId;
    data['expertise_type_code'] = this.expertiseTypeCode;
    data['expertise_type_description'] = this.expertiseTypeDescription;
    return data;
  }
}
