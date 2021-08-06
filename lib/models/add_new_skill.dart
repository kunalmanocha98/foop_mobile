class AddNewSkillLangEntity {
  String? categoryType;
  String? valueName;
  String? valueCode;
  String? valueDescription;
  int? instituteId;

  AddNewSkillLangEntity(
      {this.categoryType,
        this.valueName,
        this.valueCode,
        this.instituteId,
        this.valueDescription});

  AddNewSkillLangEntity.fromJson(Map<String, dynamic> json) {
    categoryType = json['category_type'];
    valueName = json['value_name'];
    valueCode = json['value_code'];
    instituteId=json['business_id'];
    valueDescription = json['value_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_type'] = this.categoryType;
    data['value_name'] = this.valueName;
    data['business_id']=this.instituteId;
    data['value_code'] = this.valueCode;
    data['value_description'] = this.valueDescription;
    return data;
  }
}
