class GlobalCategoryList {
  String? statusCode;
  String? message;
  List<Categoryies>? rows;
  int? total;

  GlobalCategoryList({this.statusCode, this.message, this.rows, this.total});

  GlobalCategoryList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//Categoryies>();
      json['rows'].forEach((v) {
        rows!.add(new Categoryies.fromJson(v));
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

class Categoryies {
  int? id;
  int? standardExpertiseCategory;
  int? standardExpertiseCategoryTypes;
  String? expertiseAbilityCode;
  String? isSelected;

  Categoryies(
      {this.id,
        this.standardExpertiseCategory,
        this.standardExpertiseCategoryTypes,
        this.expertiseAbilityCode,
        this.isSelected});

  Categoryies.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    standardExpertiseCategory = json['standard_expertise_category'];
    standardExpertiseCategoryTypes = json['standard_expertise_category_types'];
    expertiseAbilityCode = json['expertise_ability_code'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['standard_expertise_category'] = this.standardExpertiseCategory;
    data['standard_expertise_category_types'] =
        this.standardExpertiseCategoryTypes;
    data['expertise_ability_code'] = this.expertiseAbilityCode;
    data['is_selected'] = this.isSelected;
    return data;
  }
}
