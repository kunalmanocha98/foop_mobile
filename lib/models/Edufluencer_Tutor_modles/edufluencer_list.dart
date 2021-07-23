class EdufluenerListResponse {
  String? statusCode;
  String? message;
  List<EdufluencerListItem>? rows;
  int? total;

  EdufluenerListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  EdufluenerListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//EdufluencerListItem>();
      json['rows'].forEach((v) {
        rows!.add(new EdufluencerListItem.fromJson(v));
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

class EdufluencerListItem {
  int? id;
  int? personId;
  String? name;
  String? edufluencerTitle;
  String? edufluencerCurrentPosition;
  String? edufluencerBio;
  String? profileImage;
  Null edufluencerBioMedia;
  bool? isFreeService;
  double? trialHours;
  double? feesPerHour;
  String? feesCurrency;
  double? totalExperienceYears;
  List<String>? mediumOfCommunication;
  List<String>? workingDays;
  List<SkillsList>? skillsList;
  List<ClassesList>? classesList;
  List<SubjectsList>? subjectsList;
  double? rating;
  bool? isRated;
  bool? isFollowing;
  bool? isFollower;
  String? bookingStatus;

  EdufluencerListItem(
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
        this.bookingStatus,
        this.totalExperienceYears,
        this.mediumOfCommunication,
        this.workingDays,
        this.skillsList,
        this.classesList,
        this.subjectsList,
        this.rating,
        this.isRated,
        this.isFollowing,
        this.profileImage,
        this.isFollower});

  EdufluencerListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingStatus=json['booking_status'];
    personId = json['person_id'];
    name = json['name'];
    profileImage = json['profile_image'];
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
        skillsList!.add(new SkillsList.fromJson(v));
      });
    }
    if (json['classes_list'] != null) {
      classesList = [];//ClassesList>();
      json['classes_list'].forEach((v) {
        classesList!.add(new ClassesList.fromJson(v));
      });
    }
    if (json['subjects_list'] != null) {
      subjectsList = [];//SubjectsList>();
      json['subjects_list'].forEach((v) {
        subjectsList!.add(new SubjectsList.fromJson(v));
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
    data['booking_status']=this.bookingStatus;
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
    data['profile_image'] = this.profileImage;
    if (this.skillsList != null) {
      data['skills_list'] = this.skillsList!.map((v) => v.toJson()).toList();
    }
    if (this.classesList != null) {
      data['classes_list'] = this.classesList!.map((v) => v.toJson()).toList();
    }
    if (this.subjectsList != null) {
      data['subjects_list'] = this.subjectsList!.map((v) => v.toJson()).toList();
    }
    data['rating'] = this.rating;
    data['is_rated'] = this.isRated;
    data['is_following'] = this.isFollowing;
    data['is_follower'] = this.isFollower;
    return data;
  }
}

class SkillsList {
  int? id;
  int? skillId;
  String? skillCode;
  String? skillName;

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

class ClassesList {
  int? id;
  int? classId;
  String? classCode;
  String? className;

  ClassesList({this.id, this.classId, this.classCode, this.className});

  ClassesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    classCode = json['class_code'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_id'] = this.classId;
    data['class_code'] = this.classCode;
    data['class_name'] = this.className;
    return data;
  }
}

class SubjectsList {
  int? id;
  int? subjectId;
  String? subjectCode;
  String? subjectName;

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

class EdufluenerListRequest {
  String? edufluencerType;
  String? listType;
  String? searchVal;
  int? pageNumber;
  int? pageSize;

  EdufluenerListRequest(
      {this.edufluencerType,
        this.listType,
        this.searchVal,
        this.pageNumber,
        this.pageSize});

  EdufluenerListRequest.fromJson(Map<String, dynamic> json) {
    edufluencerType = json['edufluencer_type'];
    listType = json['list_type'];
    searchVal = json['search_val'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['edufluencer_type'] = this.edufluencerType;
    data['list_type'] = this.listType;
    data['search_val'] = this.searchVal;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    return data;
  }
}