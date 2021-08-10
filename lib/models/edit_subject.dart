class EditSubject {
  String? id;
  String? personType;
  Null institutionCourse;
  String? institutionSubject;
  String? institutionAcademicYearId;
  String? standardExpertiseCategoryId;
  Null institutionClassId;
  List<String?>? abilities;
  List<String>? goals;
  int? givenById;
  String? institutionId;
  String? personId;
  EditSubject(
      {this.id,
        this.personId,
        this.institutionId,
        this.personType,
        this.institutionCourse,
        this.institutionSubject,
        this.institutionAcademicYearId,
        this.standardExpertiseCategoryId,
        this.institutionClassId,
        this.abilities,
        this.givenById,
        this.goals});

  EditSubject.fromJson(Map<String, dynamic> json) {
    id = json['person_id'];
    personId = json['id'];
    institutionId = json['business_id'];
    givenById=json['given_by_id'];
    personType = json['person_type'];
    institutionCourse = json['institution_course'];
    institutionSubject = json['institution_subject'];
    institutionAcademicYearId = json['institution_academic_year_id'];
    standardExpertiseCategoryId = json['standardExpertiseCategory_id'];
    institutionClassId = json['institution_class_id'];
    abilities = json['abilities'].cast<String>();
    goals = json['goals'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_id'] = this.personId;
    data['id'] = this.id;
    data['business_id'] = this.institutionId;
    data['given_by_id'] = this.givenById;
    data['person_type'] = this.personType;
    data['institution_course'] = this.institutionCourse;
    data['institution_subject'] = this.institutionSubject;
    data['institution_academic_year_id'] = this.institutionAcademicYearId;
    data['standardExpertiseCategory_id'] = this.standardExpertiseCategoryId;
    data['institution_class_id'] = this.institutionClassId;
    data['abilities'] = this.abilities;
    data['goals'] = this.goals;
    return data;
  }
}
