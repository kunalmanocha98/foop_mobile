class AddClassNew {
  int? personId;
  String? id;
  String? institutionId;
  String? personType;
  String? institutionCourse;
  List<String>? institutionSubject;
  String? institutionAcademicYearId;
  String? standardExpertiseCategoryId;
  String? institutionClassId;
  List<String?>? abilities;
  List<String?>? goals;
  int? givenById;
int? sectionId;
  AddClassNew(
      {this.personId,
        this.institutionId,
        this.personType,
        this.goals,
        this.id,
        this.givenById,
        this.institutionCourse,
        this.institutionSubject,
        this.institutionAcademicYearId,
        this.sectionId,
        this.standardExpertiseCategoryId,
        this.institutionClassId,
        this.abilities});

  AddClassNew.fromJson(Map<String, dynamic> json) {
    personId = json['person_id'];
    sectionId=json['section_id'];
    id = json['id'];
    givenById=json['given_by_id'];
    institutionId = json['institution_id'];
    personType = json['person_type'];
    institutionCourse = json['institution_course'];
    institutionAcademicYearId = json['institution_academic_year_id'];
    standardExpertiseCategoryId = json['standardExpertiseCategory_id'];
    institutionClassId = json['institution_class_id'];
    abilities = json['abilities'].cast<String>();
    goals = json['goals'].cast<String>();
    institutionSubject = json['institution_subject'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_id'] = this.personId;
    data['goals'] = this.goals;
    data['section_id']=this.sectionId;
    data['id'] = this.id;
    data['given_by_id']=this.givenById;
    data['institution_id'] = this.institutionId;
    data['person_type'] = this.personType;
    data['institution_course'] = this.institutionCourse;
    data['institution_subject'] = this.institutionSubject;
    data['institution_academic_year_id'] = this.institutionAcademicYearId;
    data['standardExpertiseCategory_id'] = this.standardExpertiseCategoryId;
    data['institution_class_id'] = this.institutionClassId;
    data['abilities'] = this.abilities;
    return data;
  }
}
