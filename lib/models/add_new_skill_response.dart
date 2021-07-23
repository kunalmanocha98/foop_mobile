class AddNewSkillLangResponse {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;

  AddNewSkillLangResponse(
      {this.statusCode, this.message, this.rows, this.total});

  AddNewSkillLangResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
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

class Rows {
  String? categoryType;
  String? valueCode;
  String? valueDescription;
  int? id;

  Rows({this.categoryType, this.valueCode, this.valueDescription, this.id});

  Rows.fromJson(Map<String, dynamic> json) {
    categoryType = json['category_type'];
    valueCode = json['value_code'];
    valueDescription = json['value_description'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_type'] = this.categoryType;
    data['value_code'] = this.valueCode;
    data['value_description'] = this.valueDescription;
    data['id'] = this.id;
    return data;
  }
}
