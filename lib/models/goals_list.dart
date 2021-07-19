class GoalsList {
  String statusCode;
  String message;
  List<Rows> rows;
  int total;

  GoalsList({this.statusCode, this.message, this.rows, this.total});

  GoalsList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
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

class Rows {
  int id;
  int standardExpertiseCategory;
  int standardExpertiseCategoryTypes;
  String isGoal;
  String expertiseGoalCode;
  String isSelected;

  Rows(
      {this.id,
        this.standardExpertiseCategory,
        this.standardExpertiseCategoryTypes,
        this.isGoal,
        this.expertiseGoalCode,
        this.isSelected});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    standardExpertiseCategory = json['standard_expertise_category'];
    standardExpertiseCategoryTypes = json['standard_expertise_category_types'];
    isGoal = json['is_goal'];
    expertiseGoalCode = json['expertise_goal_code'];
    isSelected = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['standard_expertise_category'] = this.standardExpertiseCategory;
    data['standard_expertise_category_types'] =
        this.standardExpertiseCategoryTypes;
    data['is_goal'] = this.isGoal;
    data['expertise_goal_code'] = this.expertiseGoalCode;
    data['is_selected'] = this.isSelected;
    return data;
  }
}
