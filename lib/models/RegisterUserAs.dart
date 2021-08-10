class RegisterUserAs {
  int? institutionId;
  int? personId;
  List<int?>? personTypeList;
  List<PersonClasses>? personClasses;
  List<int>? personSubjects;
  int? childId;
  String? dateOfBirth;
  List<int?>? personPrograms;
  List<int>? personDepartments;
  String ?personCode;
  String ?invitation_code;
  List<String>? inactiveInstitutionIds;
  String? academicYear;
  bool? isDepartment;
  int? deleted_institution_user_id;
bool? isDefaultInstitution;
  RegisterUserAs(
      {this.institutionId,
      this.personId,
      this.isDepartment,
        this.invitation_code,
      this.personTypeList,
      this.personClasses,
      this.personSubjects,
      this.childId,
        this.isDefaultInstitution,
      this.dateOfBirth,
      this.personPrograms,
      this.personDepartments,
      this.personCode,
      this.inactiveInstitutionIds,
        this.deleted_institution_user_id,
      this.academicYear});

  RegisterUserAs.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    personId = json['person_id'];
    childId = json['child_id'];
    invitation_code=json['invitation_code'];
    isDefaultInstitution=json['is_default_institution'];
    isDepartment = json['isDepartment'];
    dateOfBirth = json['date_of_birth'];
    personTypeList = json['person_type_list'].cast<int>();
    if (json['person_classes'] != null) {
      personClasses = [];//PersonClasses>();
      json['person_classes'].forEach((v) {
        personClasses!.add(new PersonClasses.fromJson(v));
      });
    }
    personSubjects = json['person_subjects'].cast<int>();
    personPrograms = json['person_programs'].cast<int>();
    personDepartments = json['person_departments'].cast<int>();
    personCode = json['person_code'];
    inactiveInstitutionIds = json['inactive_institution_ids'].cast<String>();
    academicYear = json['academic_year'];
    deleted_institution_user_id = json['deleted_institution_user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['person_id'] = this.personId;
    data['is_default_institution']=this.isDefaultInstitution;
    data['child_id'] = this.childId;
    data['invitation_code']=this.invitation_code;
    data['isDepartment'] = this.isDepartment;
    data['date_of_birth'] = this.dateOfBirth;
    data['person_type_list'] = this.personTypeList;
    if (this.personClasses != null) {
      data['person_classes'] =
          this.personClasses!.map((v) => v.toJson()).toList();
    }
    data['person_subjects'] = this.personSubjects;
    data['person_programs'] = this.personPrograms;
    data['person_departments'] = this.personDepartments;
    data['person_code'] = this.personCode;
    data['inactive_institution_ids'] = this.inactiveInstitutionIds;
    data['academic_year'] = this.academicYear;
    data['deleted_institution_user_id'] = this.deleted_institution_user_id;
    return data;
  }
}

class PersonClasses {
  int? classId;
  List<int?>? sections;
  String? className;

  PersonClasses({this.classId, this.sections});

  PersonClasses.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    className = json['className'];
    sections = json['sections'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_id'] = this.classId;
    data['sections'] = this.sections;
    data['className'] = this.className;
    return data;
  }
}
