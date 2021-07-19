
class EdufluencerData {
  String statusCode;
  String message;
  List<EdufluncerItem> rows;
  int total;

  EdufluencerData({this.statusCode, this.message, this.rows, this.total});

  EdufluencerData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//EdufluncerItem>();
      json['rows'].forEach((v) {
        rows.add(new EdufluncerItem.fromJson(v));
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

class EdufluncerItem {
  int id;
  int personId;
  String name;
  String edufluencerTitle;
  String edufluencerCurrentPosition;
  String edufluencerBio;
  Null edufluencerBioMedia;
  bool isFreeService;
  double trialHours;
  double feesPerHour;
  String feesCurrency;
  double totalExperienceYears;
  List<String> mediumOfCommunication;
  List<String> workingDays;
  List<SkillsList> skillsList;
  List<String> classesList;
  List<SubjectsList> subjectsList;
  double rating;
  bool isRated;
  bool isFollowing;
  bool isFollower;

  EdufluncerItem(
      {this.id,
        this.personId,
        this.name,
        this.edufluencerTitle,
        this.edufluencerCurrentPosition,
        this.edufluencerBio,
        this.edufluencerBioMedia,
        this.isFreeService,
        this.trialHours,
        this.feesPerHour,
        this.feesCurrency,
        this.totalExperienceYears,
        this.mediumOfCommunication,
        this.workingDays,
        this.skillsList,
        this.classesList,
        this.subjectsList,
        this.rating,
        this.isRated,
        this.isFollowing,
        this.isFollower});

  EdufluncerItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    name = json['name'];
    edufluencerTitle = json['edufluencer_title'];
    edufluencerCurrentPosition = json['edufluencer_current_position'];
    edufluencerBio = json['edufluencer_bio'];
    edufluencerBioMedia = json['edufluencer_bio_media'];
    isFreeService = json['is_free_service'];
    trialHours = json['trial_hours'];
    feesPerHour = json['fees_per_hour'];
    feesCurrency = json['fees_currency'];
    totalExperienceYears = json['total_experience_years'];
    mediumOfCommunication = json['medium_of_communication'].cast<String>();
    workingDays = json['working_days'].cast<String>();
    if (json['skills_list'] != null) {
      skillsList = [];//SkillsList>();
      json['skills_list'].forEach((v) {
        skillsList.add(new SkillsList.fromJson(v));
      });
    }
    classesList = json['classes_list'].cast<String>();
    if (json['subjects_list'] != null) {
      subjectsList = [];//SubjectsList>();
      json['subjects_list'].forEach((v) {
        subjectsList.add(new SubjectsList.fromJson(v));
      });
    }
    rating = json['rating'];
    isRated = json['is_rated'];
    isFollowing = json['is_following'];
    isFollower = json['is_follower'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['person_id'] = this.personId;
    data['name'] = this.name;
    data['edufluencer_title'] = this.edufluencerTitle;
    data['edufluencer_current_position'] = this.edufluencerCurrentPosition;
    data['edufluencer_bio'] = this.edufluencerBio;
    data['edufluencer_bio_media'] = this.edufluencerBioMedia;
    data['is_free_service'] = this.isFreeService;
    data['trial_hours'] = this.trialHours;
    data['fees_per_hour'] = this.feesPerHour;
    data['fees_currency'] = this.feesCurrency;
    data['total_experience_years'] = this.totalExperienceYears;
    data['medium_of_communication'] = this.mediumOfCommunication;
    data['working_days'] = this.workingDays;
    if (this.skillsList != null) {
      data['skills_list'] = this.skillsList.map((v) => v.toJson()).toList();
    }
    data['classes_list'] = this.classesList;
    if (this.subjectsList != null) {
      data['subjects_list'] = this.subjectsList.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    data['is_rated'] = this.isRated;
    data['is_following'] = this.isFollowing;
    data['is_follower'] = this.isFollower;
    return data;
  }
}

class SkillsList {
  int id;
  Null skillId;
  String skillCode;
  String skillName;

  SkillsList({this.id, this.skillId, this.skillCode, this.skillName});

  SkillsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    skillId = json['skill_id'];
    skillCode = json['skill_code'];
    skillName = json['skill_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['skill_id'] = this.skillId;
    data['skill_code'] = this.skillCode;
    data['skill_name'] = this.skillName;
    return data;
  }
}

class SubjectsList {
  int id;
  Null subjectId;
  Null subjectCode;
  String subjectName;

  SubjectsList({this.id, this.subjectId, this.subjectCode, this.subjectName});

  SubjectsList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subjectId = json['subject_id'];
    subjectCode = json['subject_code'];
    subjectName = json['subject_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['subject_id'] = this.subjectId;
    data['subject_code'] = this.subjectCode;
    data['subject_name'] = this.subjectName;
    return data;
  }
}
