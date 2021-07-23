import 'package:oho_works_app/e_learning_module/model/chapter_response.dart';
import 'package:oho_works_app/e_learning_module/model/create_lesson_data.dart';
import 'package:oho_works_app/e_learning_module/model/learner_list_response.dart';
import 'package:oho_works_app/e_learning_module/ui/lesson_list_response.dart';

class PostCreatePayload {
  int? postId;
  int? id;
  int? originalPsPostMainId;
  String? postOwnerType;
  int? postOwnerTypeId;
  int? postCreatedById;
  int? postInstitutionId;
  String? postType;
  String? postCategory;
  String? postStatus;
  List<String?>? postRecipientType;
  int? postTypeReferenceId;
  ContentMetaCreate? contentMeta;
  List<MediaDetails>? mediaDetails;
  List<PostRecipientDetailItem>? postRecipientDetails;
  List<String?>? postKeywords;
  List<String>? postMentions;
  List<String?>?  postSubTypes;
  String? sourceLink;
  String? postColor;
  //=============================lesson data
  String? coverImage;
  String? lessonType;
  LessonTopic? lessonTopic;
  List<LearnerListItem>? learnerItem;
  List<Affiliation>? affiliatedList ;
  List<Programme>? programmesList ;
  List<Classes>? classesList ;
  List<Subjects>? subjectsList ;
  List<Discipline>? disciplineList;
  ChapterItem? chapterItem;
  LessonListItem? lessonListItem;
  List<PostCreatePayload>? listOfLessons;

  PostCreatePayload(
      {
        this.listOfLessons,
        this.lessonListItem,
        this.chapterItem,
        this.disciplineList,
        this.subjectsList,
        this.classesList,
        this.programmesList,
        this.affiliatedList,
        this.learnerItem,
        this.lessonTopic,
        this.lessonType,
        this.originalPsPostMainId,
        this.postOwnerType,
        this.postOwnerTypeId,
        this.postCreatedById,
        this.postInstitutionId,
        this.postType,
        this.postCategory,
        this.postStatus,
        this.postRecipientType,
        this.postTypeReferenceId,
        this.contentMeta,
        this.mediaDetails,
        this.postKeywords,
        this.postMentions,
        this.postId,
        this.postColor,
        this.postRecipientDetails,
        this.postSubTypes,
        this.sourceLink,
        this.coverImage,
      this.id});

  PostCreatePayload.fromJson(Map<String, dynamic> json) {
    if (json['learner_category'] != null) {
      learnerItem = [];//LearnerListItem>();
      json['learner_category'].forEach((v) {
        learnerItem!.add(new LearnerListItem.fromJson(v));
      });
    };
    lessonTopic = json['lesson_topic'] != null
        ? new LessonTopic.fromJson(json['lesson_topic'])
        : null;
    chapterItem =
    json['chapter'] != null ? new ChapterItem.fromJson(json['chapter']) : null;
    lessonListItem =
    json['lesson'] != null ? new LessonListItem.fromJson(json['lesson']) : null;

    if (json['discipline'] != null) {
      disciplineList = [];//Discipline>();
      json['discipline'].forEach((v) {
        disciplineList!.add(new Discipline.fromJson(v));
      });
    }

    if (json['subjects'] != null) {
      subjectsList = [];//Subjects>();
      json['subjects'].forEach((v) {
        subjectsList!.add(new Subjects.fromJson(v));
      });
    }
    if (json['classes'] != null) {
      classesList = [];//Classes>();
      json['classes'].forEach((v) {
        classesList!.add(new Classes.fromJson(v));
      });
    }
    if (json['programme'] != null) {
      programmesList = [];//Programme>();
      json['programme'].forEach((v) {
        programmesList!.add(new Programme.fromJson(v));
      });
    }

    if (json['affiliation'] != null) {
      affiliatedList = [];//Affiliation>();
      json['affiliation'].forEach((v) {
        affiliatedList!.add(new Affiliation.fromJson(v));
      });
    }
    lessonType = json['lesson_type'];
    coverImage = json['cover_image'];
    postId = json['post_id'];
    originalPsPostMainId = json['original_ps_post_main_id'];
    postOwnerType = json['post_owner_type'];
    postOwnerTypeId = json['post_owner_type_id'];
    postCreatedById = json['post_created_by_id'];
    postInstitutionId = json['post_institution_id'];
    postType = json['post_type'];
    postCategory = json['post_category'];
    postStatus = json['post_status'];
    postRecipientType =json['post_recipient_type']!=null? json['post_recipient_type'].cast<String>():null;
    postTypeReferenceId = json['post_type_reference_id'];
    id = json['id'];
    sourceLink =json['source_link'];
    postColor = json['post_color'];
    postRecipientDetails = json['post_recipient_details'];
    contentMeta = json['content_meta'] != null
        ? new ContentMetaCreate.fromJson(json['content_meta'])
        : null;
    if (json['media_details'] != null) {
      mediaDetails = [];//MediaDetails>();
      json['media_details'].forEach((v) {
        mediaDetails!.add(new MediaDetails.fromJson(v));
      });
    }
    postKeywords =json['post_keywords']!=null? json['post_keywords'].cast<String>():null;
    postMentions =  json['post_mentions']!=null?json['post_mentions'].cast<String>():null;
    postSubTypes = json['post_sub_types']!=null?json['post_sub_types'].cast<String>():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['learner_category'] = this.learnerItem;
    data['lesson_topic'] = this.lessonTopic;
    data['chapter'] = this.chapterItem;
    data['lesson'] = this.lessonListItem;
    data['discipline'] = this.disciplineList;
    data['subjects'] = this.subjectsList;
    data['classes'] = this.classesList;
    data['programme'] = this.programmesList;
    data['affiliation'] = this.affiliatedList;
    data['lesson_type'] = this.lessonType;
    data['original_ps_post_main_id'] = this.originalPsPostMainId;
    data['post_owner_type'] = this.postOwnerType;
    data['post_owner_type_id'] = this.postOwnerTypeId;
    data['post_created_by_id'] = this.postCreatedById;
    data['post_institution_id'] = this.postInstitutionId;
    data['post_type'] = this.postType;
    data['post_category'] = this.postCategory;
    data['post_status'] = this.postStatus;
    data['post_recipient_type'] = this.postRecipientType;
    data['post_type_reference_id'] = this.postTypeReferenceId;
    data['post_id'] = this.postId;
    data['id'] = this.id;
    data['post_color'] = this.postColor;
    data['cover_image'] = this.coverImage;
    data['post_recipient_details'] = this.postRecipientDetails;
    if (this.contentMeta != null) {
      data['content_meta'] = this.contentMeta!.toJson();
    }
    if (this.mediaDetails != null) {
      data['media_details'] = this.mediaDetails!.map((v) => v.toJson()).toList();
    }
    data['post_keywords'] = this.postKeywords;
    data['post_mentions'] = this.postMentions;
    data['post_sub_types'] = this.postSubTypes;
    data['source_link'] = this.sourceLink;
    return data;
  }
}

class Affiliation {
  int? id;
  String? organizationCode;
  String? organizationName;

  Affiliation({this.id, this.organizationCode, this.organizationName});

  Affiliation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    organizationCode = json['organization_code'];
    organizationName = json['organization_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['organization_code'] = this.organizationCode;
    data['organization_name'] = this.organizationName;
    return data;
  }
}

class Programme {
  int? id;
  String? programCode;
  String? programName;

  Programme({this.id, this.programCode, this.programName});

  Programme.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programCode = json['program_code'];
    programName = json['program_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['program_code'] = this.programCode;
    data['program_name'] = this.programName;
    return data;
  }
}

class Discipline {
  int? id;
  String? departmentCode;
  String? departmentName;

  Discipline({this.id, this.departmentCode, this.departmentName});

  Discipline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentCode = json['department_code'];
    departmentName = json['department_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department_code'] = this.departmentCode;
    data['department_name'] = this.departmentName;
    return data;
  }
}

class Classes {
  int? id;
  String? classCode;
  String? className;

  Classes({this.id, this.classCode, this.className});

  Classes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classCode = json['class_code'];
    className = json['class_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_code'] = this.classCode;
    data['class_name'] = this.className;
    return data;
  }
}
class Subjects {
int? id;
String? subjectCode;
String? subjectName;

Subjects({this.id, this.subjectCode, this.subjectName});

Subjects.fromJson(Map<String, dynamic> json) {
id = json['id'];
subjectCode = json['subject_code'];
subjectName = json['subject_name'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['subject_code'] = this.subjectCode;
  data['subject_name'] = this.subjectName;
  return data;
}
}


class ContentMetaCreate {
  String? title;
  String? subtitle1;
  String? subtitle2;
  String? meta;
  OtherPollRequest? others;

  ContentMetaCreate({this.title, this.subtitle1, this.subtitle2, this.meta, this.others});

  ContentMetaCreate.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    subtitle1 = json['subtitle1'];
    subtitle2 = json['subtitle2'];
    meta = json['meta'];
    others = json['others'] != null
        ? new OtherPollRequest.fromJson(json['others'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['subtitle1'] = this.subtitle1;
    data['subtitle2'] = this.subtitle2;
    data['meta'] = this.meta;
    if (this.others != null) {
      data['others'] = this.others!.toJson();
    }
    return data;
  }
}

class OtherPollRequest {
  int? pollStart;
  int? pollEnd;
  int? totalResponses;
  List<Options>? options;
  int? submissionDateTime ;
  int? maxMarks;
  List<String?>? subjects;


  OtherPollRequest(
      {this.pollStart, this.pollEnd, this.totalResponses, this.options,this.subjects,this.submissionDateTime,this.maxMarks});

  OtherPollRequest.fromJson(Map<String, dynamic> json) {
    pollStart = json['poll_start'];
    pollEnd = json['poll_end'];
    totalResponses = json['total_responses'];
    submissionDateTime = json['submission_datetime'];
    maxMarks = json['max_marks'];
    subjects = json['subjects']!=null ?json['subjects'].cast<String>():null;
    if (json['options'] != null) {
      options = [];//Options>();
      json['options'].forEach((v) {
        options!.add(new Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poll_start'] = this.pollStart;
    data['poll_end'] = this.pollEnd;
    data['total_responses'] = this.totalResponses;
    data['submission_datetime'] = this.submissionDateTime;
    data['max_marks'] = this.maxMarks;
    data['subjects'] = this.subjects;
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? option;
  int? optionSequence;
  int? numberSelected;
  int? percentage;

  Options(
      {this.option, this.optionSequence, this.numberSelected, this.percentage});

  Options.fromJson(Map<String, dynamic> json) {
    option = json['option'];
    optionSequence = json['option_sequence'];
    numberSelected = json['number_selected'];
    percentage = json['percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option'] = this.option;
    data['option_sequence'] = this.optionSequence;
    data['number_selected'] = this.numberSelected;
    data['percentage'] = this.percentage;
    return data;
  }
}

class MediaDetails {
  String? mediaType;
  String? mediaUrl;
  String? mediaThumbnailUrl;

  MediaDetails({this.mediaType, this.mediaUrl,this.mediaThumbnailUrl});

  MediaDetails.fromJson(Map<String, dynamic> json) {
    mediaType = json['media_type'];
    mediaUrl = json['media_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_type'] = this.mediaType;
    data['media_url'] = this.mediaUrl;
    return data;
  }
}

class PostRecipientDetailItem {
  String? type;
  int? id;

  PostRecipientDetailItem({this.type, this.id});

  PostRecipientDetailItem.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class PostCreateResponse {
  String? statusCode;
  String? message;
  PostResponseModel? rows;
  int? total;

  PostCreateResponse({this.statusCode, this.message, this.rows, this.total});

  PostCreateResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows']!=null?PostResponseModel.fromJson(json):null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if(this.rows!=null) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class PostResponseModel{
  int? id;
  PostResponseModel({this.id});
  PostResponseModel.fromJson(Map<String,dynamic> json){
    id= json['id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}