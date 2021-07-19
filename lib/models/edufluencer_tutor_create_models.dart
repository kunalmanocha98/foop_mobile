class CreateEdufluencerTutorRequest {
  String edufluencerType;
  String edufluencerTitle;
  String edufluencerCurrentPosition;
  String edufluencerBio;
  bool isFreeService;
  double trialHours;
  int feesPerHour;
  String feesCurrency;
  double totalExperienceYears;
  List<String> mediumOfCommunication;
  List<String> working_days;
  List<SubjectsList> subjectsList;
  List<SkillsList> skillsList;
  List<SpecialitiesList> specialitiesList;
  List<ClassesList> classesList;

  CreateEdufluencerTutorRequest(
      {this.edufluencerType,
        this.edufluencerTitle,
        this.edufluencerCurrentPosition,
        this.edufluencerBio,
        this.isFreeService,
        this.trialHours,
        this.feesPerHour,
        this.feesCurrency,
        this.totalExperienceYears,
        this.mediumOfCommunication,
        this.subjectsList,
        this.skillsList,
        this.specialitiesList,
        this.working_days,
        this.classesList});

  CreateEdufluencerTutorRequest.fromJson(Map<String, dynamic> json) {
    edufluencerType = json['edufluencer_type'];
    edufluencerTitle = json['edufluencer_title'];
    edufluencerCurrentPosition = json['edufluencer_current_position'];
    edufluencerBio = json['edufluencer_bio'];
    isFreeService = json['is_free_service'];
    trialHours = json['trial_hours'];
    feesPerHour = json['fees_per_hour'];
    feesCurrency = json['fees_currency'];
    totalExperienceYears = json['total_experience_years'];
    mediumOfCommunication = json['medium_of_communication'].cast<String>();
    working_days = json['working_days'].cast<String>();
    if (json['subjects_list'] != null) {
      subjectsList = [];//SubjectsList>();
      json['subjects_list'].forEach((v) {
        subjectsList.add(new SubjectsList.fromJson(v));
      });
    }
    if (json['skills_list'] != null) {
      skillsList = [];//SkillsList>();
      json['skills_list'].forEach((v) {
        skillsList.add(new SkillsList.fromJson(v));
      });
    }
    if (json['specialities_list'] != null) {
      specialitiesList = [];//SpecialitiesList>();
      json['specialities_list'].forEach((v) {
        specialitiesList.add(new SpecialitiesList.fromJson(v));
      });
    }
    if (json['classes_list'] != null) {
      classesList = [];//ClassesList>();
      json['classes_list'].forEach((v) {
        classesList.add(new ClassesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['edufluencer_type'] = this.edufluencerType;
    data['edufluencer_title'] = this.edufluencerTitle;
    data['edufluencer_current_position'] = this.edufluencerCurrentPosition;
    data['edufluencer_bio'] = this.edufluencerBio;
    data['is_free_service'] = this.isFreeService;
    data['trial_hours'] = this.trialHours;
    data['fees_per_hour'] = this.feesPerHour;
    data['fees_currency'] = this.feesCurrency;
    data['total_experience_years'] = this.totalExperienceYears;
    data['medium_of_communication'] = this.mediumOfCommunication;
    data['working_days'] = this.working_days;
    if (this.subjectsList != null) {
      data['subjects_list'] = this.subjectsList.map((v) => v.toJson()).toList();
    }
    if (this.skillsList != null) {
      data['skills_list'] = this.skillsList.map((v) => v.toJson()).toList();
    }
    if (this.specialitiesList != null) {
      data['specialities_list'] =
          this.specialitiesList.map((v) => v.toJson()).toList();
    }
    if (this.classesList != null) {
      data['classes_list'] = this.classesList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubjectsList {
  int subjectId;
  String subjectCode;
  String subjectName;

  SubjectsList({this.subjectId, this.subjectCode, this.subjectName});

  SubjectsList.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'];
    subjectCode = json['subject_code'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_id'] = this.subjectId;
    data['subject_code'] = this.subjectCode;
    data['subject_name'] = this.subjectName;
    return data;
  }
}

class SkillsList {
  int skillId;
  String skillCode;
  String skillName;

  SkillsList({this.skillId, this.skillCode, this.skillName});

  SkillsList.fromJson(Map<String, dynamic> json) {
    skillId = json['skill_id'];
    skillCode = json['skill_code'];
    skillName = json['skill_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skill_id'] = this.skillId;
    data['skill_code'] = this.skillCode;
    data['skill_name'] = this.skillName;
    return data;
  }
}

class SpecialitiesList {
  int specialityId;
  String specialityCode;
  String specialityName;

  SpecialitiesList(
      {this.specialityId, this.specialityCode, this.specialityName});

  SpecialitiesList.fromJson(Map<String, dynamic> json) {
    specialityId = json['speciality_id'];
    specialityCode = json['speciality_code'];
    specialityName = json['speciality_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['speciality_id'] = this.specialityId;
    data['speciality_code'] = this.specialityCode;
    data['speciality_name'] = this.specialityName;
    return data;
  }
}

class ClassesList {
  int classId;
  String classCode;
  String className;

  ClassesList({this.classId, this.classCode, this.className});

  ClassesList.fromJson(Map<String, dynamic> json) {
    classId = json['class_id'];
    classCode = json['class_code'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_id'] = this.classId;
    data['class_code'] = this.classCode;
    data['class_name'] = this.className;
    return data;
  }
}

class CreateEdufluencerResponse {
  String statusCode;
  String message;
  int total;

  CreateEdufluencerResponse(
      {this.statusCode, this.message, this.total});

  CreateEdufluencerResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    return data;
  }
}