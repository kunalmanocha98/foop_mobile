class LearnerCategoryListResponse {
  String? statusCode;
  String? message;
  List<LearnerListItem>? rows;
  int? total;

  LearnerCategoryListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  LearnerCategoryListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//LearnerListItem>();
      json['rows'].forEach((v) {
        rows!.add(new LearnerListItem.fromJson(v));
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

class LearnerListItem {
  String? learnerCategoryCode;
  String? learnerCategoryName;
  String? learnerCategoryDescription;
  String? imageUrl;
  String? ageGroupStart;
  String? ageGroupEnd;
  bool? isSelected;
  int? learnerCategoryId;
  String? learnerCategoryType;

  LearnerListItem(
      {this.learnerCategoryCode,
        this.learnerCategoryName,
        this.learnerCategoryDescription,
        this.imageUrl,
        this.isSelected,
        this.ageGroupStart,
        this.ageGroupEnd,
        this.learnerCategoryType,
        this.learnerCategoryId});

  LearnerListItem.fromJson(Map<String, dynamic> json) {
    learnerCategoryCode = json['learner_category_code'];
    learnerCategoryName = json['learner_category_name'];
    learnerCategoryDescription = json['learner_category_description'];
    learnerCategoryType = json['learner_category_type'];
    imageUrl = json['image_url'];
    ageGroupStart = json['age_group_start'];
    ageGroupEnd = json['age_group_end'];
    learnerCategoryId = json['learner_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['learner_category_code'] = this.learnerCategoryCode;
    data['learner_category_name'] = this.learnerCategoryName;
    data['learner_category_type'] = this.learnerCategoryType;
    data['learner_category_description'] = this.learnerCategoryDescription;
    data['image_url'] = this.imageUrl;
    data['age_group_start'] = this.ageGroupStart;
    data['age_group_end'] = this.ageGroupEnd;
    data['learner_category_id'] = this.learnerCategoryId;
    return data;
  }
}
