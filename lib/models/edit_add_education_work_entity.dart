class EditEducationWork {
  String cardType;
  String personId;
  String schoolName;
  String startDate;
  String endDate;
  String className;
  String fieldOfStudy;
  String grade;
  int id;
  String description;
  String designation;
  bool iscurrent;
  String classId;
  int institutionId;
  String employmentType;
  String industryType;
  String location;
  String institutionName;

  EditEducationWork({this.cardType,
    this.personId,
    this.institutionId,
    this.employmentType,
    this.industryType,
    this.location,
    this.classId,
    this.institutionName,

    this.schoolName,
    this.startDate,
    this.endDate,
    this.id,
    this.className,
    this.fieldOfStudy,
    this.grade,
    this.description,
    this.iscurrent,
    this.designation});

  EditEducationWork.fromJson(Map<String, dynamic> json) {
    industryType = json['industry_type'];
    institutionId = json['institution_id'];
    institutionName=json['institution_name'];
    employmentType = json['employment_type'];
    location = json['location'];
    classId = json['class_id'];
    cardType = json['add_type'];
    id = json['id'];
    iscurrent = json['is_current'];
    personId = json['person_id'];
    schoolName = json['school_name'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    className = json['class_name'];
    fieldOfStudy = json['field_of_study'];
    grade = json['grade'];
    description = json['description'];
    designation = json['designation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['institution_id'] = this.institutionId;
    data['industry_type']=this.industryType;
    data['institution_name']=this.institutionName;
    data['class_id'] = this.classId;
    data['location'] = this.location;
    data['employment_type'] = this.employmentType;
    data['add_type'] = this.cardType;

    data['add_type'] = this.cardType;
    data['id'] = this.id;
    data['is_current'] = this.iscurrent;
    data['person_id'] = this.personId;
    data['school_name'] = this.schoolName;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['class_name'] = this.className;
    data['field_of_study'] = this.fieldOfStudy;
    data['grade'] = this.grade;
    data['description'] = this.description;
    data['designation'] = this.designation;
    return data;
  }
}
