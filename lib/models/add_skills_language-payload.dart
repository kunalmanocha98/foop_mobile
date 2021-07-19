class AddLanguageSkills {
  int personId;
  int id;
  int institutionId;
  int standardExpertiseCategory;
  int standardExpertiseCategoryTypes;
  String isSelected;
  String selfRating;
  String averageRating;
  String numberOfRatings;
  List<String> abilities;
  List<String> goals;
  int givenById;
  String personType;
  AddLanguageSkills(
      {this.personId,
        this.institutionId,
        this.standardExpertiseCategory,
        this.standardExpertiseCategoryTypes,
        this.isSelected,
        this.selfRating,
        this.id,
        this.givenById,
        this.averageRating,
        this.numberOfRatings,
        this.abilities,
        this.personType,
        this.goals});

  AddLanguageSkills.fromJson(Map<String, dynamic> json) {
    personId = json['person_id'];
    id = json['id'];
    institutionId = json['institution_id'];
    standardExpertiseCategory = json['standard_expertise_category'];
    standardExpertiseCategoryTypes = json['standard_expertise_category_types'];
    isSelected = json['is_selected'];
    selfRating = json['self_rating'];
    personType=json['person_type'];
    averageRating = json['average_rating'];
    givenById=json['given_by_id'];
    numberOfRatings = json['number_of_ratings'];
    abilities = json['abilities'].cast<String>();
    goals = json['goals'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_id'] = this.personId;
    data['given_by_id']=this.givenById;
    data['personType']=this.personType;
    data['institution_id'] = this.institutionId;
    data['standard_expertise_category'] = this.standardExpertiseCategory;
    data['standard_expertise_category_types'] =
        this.standardExpertiseCategoryTypes;
    data['is_selected'] = this.isSelected;
    data['id'] = this.id;
    data['self_rating'] = this.selfRating;
    data['average_rating'] = this.averageRating;
    data['number_of_ratings'] = this.numberOfRatings;
    data['abilities'] = this.abilities;
    data['goals'] = this.goals;
    return data;
  }
}
