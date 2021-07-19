import 'dart:ui';

import 'package:oho_works_app/e_learning_module/model/chapter_response.dart';
import 'package:oho_works_app/e_learning_module/model/create_lesson_data.dart';
import 'package:oho_works_app/e_learning_module/model/learner_list_response.dart';
import 'package:oho_works_app/e_learning_module/ui/lesson_list_response.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/post/postcreate.dart';

class PostListRequest {
  int personId;
  int pageSize;
  int pageNumber;
  String postRecipientStatus;
  bool isOwnPost;
  String type;
  String postOwnerType;
  int postOwnerTypeId;
  String postType;
  List<String> postSubTypes;
  bool isBookmarked;
  bool isRoomPost;
  int roomId;
  int eventId;
  bool isEventPost;
  int excludeNRecords;
  bool isReceived;
  String postStatus;
  PostListRequest(
      {this.personId,
        this.pageSize,
        this.pageNumber,
        this.postRecipientStatus,
      this.isOwnPost,
      this.type,
        this.postStatus,
      this.postOwnerType,
      this.postOwnerTypeId,
        this.postSubTypes,
        this.isBookmarked,
        this.roomId,
        this.isRoomPost,
        this.eventId,
        this.excludeNRecords,
        this.isEventPost,
        this.isReceived,
      this.postType});

  PostListRequest.fromJson(Map<String, dynamic> json) {
    personId = json['person_id'];
    pageSize = json['page_size'];
    postStatus = json['post_status'];
    pageNumber = json['page_number'];
    isOwnPost = json['is_own_post'];
    postRecipientStatus = json['post_recipient_status'];
    type = json['type'];
    postOwnerType = json['post_owner_type'];
    postOwnerTypeId = json['post_owner_type_id'];
    postType = json['post_type'];
    isBookmarked = json['is_bookmarked'];
    isRoomPost = json['is_room_post'];
    roomId = json['room_id'];
    isEventPost = json['is_event_post'];
    eventId = json['event_id'];
    excludeNRecords = json['exclude_first_n_records'];
    isReceived = json['is_received_posts'];
    postSubTypes = json['post_sub_types'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_id'] = this.personId;
    data['page_size'] = this.pageSize;
    data['page_number'] = this.pageNumber;
    data['post_recipient_status'] = this.postRecipientStatus;
    data['is_own_post'] = this.isOwnPost;
    data['type'] = this.type;
    data['post_owner_type_id'] = this.postOwnerTypeId;
    data['post_owner_type'] = this.postOwnerType;
    data['post_type'] = this.postType;
    data['post_sub_types'] = this.postSubTypes;
    data['is_bookmarked'] = this.isBookmarked;
    data['is_room_post']= this.isRoomPost;
    data['room_id'] = this.roomId;
    data['is_event_post']= this.isEventPost;
    data['event_id'] = this.eventId;
    data['post_status'] = this.postStatus;
    data['is_received_posts'] = this.isReceived;
    data['exclude_first_n_records'] = this.excludeNRecords;
    return data;
  }
}


class PostListResponse {
  String statusCode;
  String message;
  List<PostListItem> rows;
  int total;

  PostListResponse({this.statusCode, this.message, this.rows, this.total});

  PostListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    if (json['rows'] != null) {
      rows = [];//PostListItem>();
      json['rows'].forEach((v) {
        rows.add(new PostListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostListItem {

  String languageCode;
  String postType;
  int postDatetime;
  int postId;
  int postTypeReferenceId;
  int postOwnerTypeId;
  String postOwnerType;
  bool isVoted;
  bool isBookmarked;
  PostContent postContent;
  List<String>  postSubTypes;
  String sourceLink;
  int prevId;
  int nextId;
  String lessonType;
  LessonTopic lessonTopic;
  List<LearnerListItem> learnerItem;
  List<Affiliation> affiliatedList ;
  List<Programme> programmesList ;
  List<Classes> classesList ;
  List<Subjects> subjectsList ;
  List<Discipline> disciplineList;
  ChapterItem chapterItem;
  LessonListItem lessonListItem;
  String coverImage;
  LessonReadDetails lessonReadDetails;
  List<MembersList> membersList;
  Color bookcovercolor;




  PostListItem(
      { this.lessonListItem,
        this.chapterItem,
        this.languageCode,
        this.disciplineList,
        this.subjectsList,
        this.classesList,
        this.programmesList,
        this.affiliatedList,
        this.learnerItem,
        this.lessonTopic,
        this.lessonType,
        this.postType,
        this.postDatetime,
        this.postId,
        this.postTypeReferenceId,
        this.postContent,
        this.postOwnerType,
        this.postOwnerTypeId,
        this.isVoted,
        this.postSubTypes,
        this.sourceLink,
        this.prevId,
        this.nextId,
        this.coverImage,
        this.lessonReadDetails,
        this.membersList,
        this.bookcovercolor,
      this.isBookmarked});

  PostListItem.fromJson(Map<String, dynamic> json) {
    languageCode=json['language_code'];
    postType = json['post_type']!=null?json['post_type']:null;
    postDatetime = json['post_datetime'];
    postId = json['post_id'];
    postTypeReferenceId = json['post_type_reference_id'];
    postOwnerType = json['post_owner_type'];
    postOwnerTypeId = json['post_owner_type_id'];
    isBookmarked = json['is_bookmarked'];
    isVoted = json['is_voted'];
    postSubTypes = json['post_sub_types']!=null ?json['post_sub_types'].cast<String>():null;
    sourceLink =json['source_link'];
    prevId = json['prev_id'];
    nextId = json['next_id'];
    if (json['members_list'] != null) {
      membersList = [];//MembersList>();
      json['members_list'].forEach((v) {membersList.add(new MembersList.fromJson(v));});
    }
    lessonReadDetails = json['lesson_read_details'] != null
        ? new LessonReadDetails.fromJson(json['lesson_read_details'])
        : null;
    postContent = json['post_content'] != null
        ? new PostContent.fromJson(json['post_content'])
        : null;
    if (json['learner_category'] != null) {
      learnerItem = [];//LearnerListItem>();
      json['learner_category'].forEach((v) {
        learnerItem.add(new LearnerListItem.fromJson(v));
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
        disciplineList.add(new Discipline.fromJson(v));
      });
    }

    if (json['subjects'] != null) {
      subjectsList = [];//Subjects>();
      json['subjects'].forEach((v) {
        subjectsList.add(new Subjects.fromJson(v));
      });
    }
    if (json['classes'] != null) {
      classesList = [];//Classes>();
      json['classes'].forEach((v) {
        classesList.add(new Classes.fromJson(v));
      });
    }
    if (json['programme'] != null) {
      programmesList = [];//Programme>();
      json['programme'].forEach((v) {
        programmesList.add(new Programme.fromJson(v));
      });
    }

    if (json['affiliation'] != null) {
      affiliatedList = [];//Affiliation>();
      json['affiliation'].forEach((v) {
        affiliatedList.add(new Affiliation.fromJson(v));
      });
    }
    lessonType = json['lesson_type'];
    coverImage = json['cover_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_type'] = this.postType;

    data['language_code']=this.languageCode;
    data['post_datetime'] = this.postDatetime;
    data['post_id'] = this.postId;
    data['post_type_reference_id'] = this.postTypeReferenceId;
    data['post_owner_type'] = this.postOwnerType;
    data['post_owner_type_id'] = this.postOwnerTypeId;
    data['is_bookmarked'] = this.isBookmarked;
    data['is_voted'] = this.isVoted;
    data['prev_id'] = this.prevId;
    data['next_id'] = this.nextId;
    if (this.postContent != null) {
      data['post_content'] = this.postContent.toJson();
    }
    if (this.lessonReadDetails != null) {
      data['lesson_read_details'] = this.lessonReadDetails.toJson();
    }
    if (this.membersList != null) {
      data['members_list'] = this.membersList.map((v) => v.toJson()).toList();
    }
    data['post_sub_types'] = this.postSubTypes;
    data['source_link'] = this.sourceLink;
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
    data['cover_image'] = this.coverImage;
    return data;
  }
}
class LessonReadDetails {
  int percentage;
  int totalLessons;
  List<LessonDetails> lessonDetails;
  int totalReadLessons;

  LessonReadDetails(
      {this.percentage,
        this.totalLessons,
        this.lessonDetails,
        this.totalReadLessons});

  LessonReadDetails.fromJson(Map<String, dynamic> json) {
    percentage = json['percentage'];
    totalLessons = json['total_lessons'];
    if (json['lesson_details'] != null) {
      lessonDetails = [];//LessonDetails>();
      json['lesson_details'].forEach((v) {
        lessonDetails.add(new LessonDetails.fromJson(v));
      });
    }
    totalReadLessons = json['total_read_lessons'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['percentage'] = this.percentage;
    data['total_lessons'] = this.totalLessons;
    if (this.lessonDetails != null) {
      data['lesson_details'] =
          this.lessonDetails.map((v) => v.toJson()).toList();
    }
    data['total_read_lessons'] = this.totalReadLessons;
    return data;
  }
}

class LessonDetails {
  int id;
  int chapterId;
  String lessonName;
  int referenceId;
  String referenceType;
  String postRecipientStatus;

  LessonDetails(
      {this.id,
        this.chapterId,
        this.lessonName,
        this.referenceId,
        this.referenceType,
        this.postRecipientStatus});

  LessonDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chapterId = json['chapter_id'];
    lessonName = json['lesson_name'];
    referenceId = json['reference_id'];
    referenceType = json['reference_type'];
    postRecipientStatus = json['post_recipient_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chapter_id'] = this.chapterId;
    data['lesson_name'] = this.lessonName;
    data['reference_id'] = this.referenceId;
    data['reference_type'] = this.referenceType;
    data['post_recipient_status'] = this.postRecipientStatus;
    return data;
  }
}

class PostContent {
  List<String> extra;
  Footer footer;
  Header header;
  Content content;
  Statistics statistics;
  Specifications specifications;

  PostContent(
      {this.extra,
        this.footer,
        this.header,
        this.content,
        this.statistics,
        this.specifications});

  PostContent.fromJson(Map<String, dynamic> json) {
    extra = json['extra'].cast<String>();
    footer =
    json['footer'] != null ? new Footer.fromJson(json['footer']) : null;
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    content =
    json['content'] != null ? new Content.fromJson(json['content']) : null;
    statistics = json['statistics'] != null
        ? new Statistics.fromJson(json['statistics'])
        : null;
    specifications = json['specifications'] != null
        ? new Specifications.fromJson(json['specifications'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extra'] = this.extra;
    if (this.footer != null) {
      data['footer'] = this.footer.toJson();
    }
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    if (this.statistics != null) {
      data['statistics'] = this.statistics.toJson();
    }
    if (this.specifications != null) {
      data['specifications'] = this.specifications.toJson();
    }
    return data;
  }
}

class Footer {
  List<String> action;
  String lastComment;

  Footer({this.action, this.lastComment});

  Footer.fromJson(Map<String, dynamic> json) {
    action = json['action'].cast<String>();
    lastComment = json['last_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action'] = this.action;
    data['last_comment'] = this.lastComment;
    return data;
  }
}

class Header {
  List<String> extra;
  String title;
  List<Action> action;
  String avatar;
  String layout;
  String subtitle1;
  Null subtitle2;
  bool isVerified;

  Header(
      {this.extra,
        this.title,
        this.action,
        this.avatar,
        this.layout,
        this.subtitle1,
        this.isVerified,
        this.subtitle2});

  Header.fromJson(Map<String, dynamic> json) {
    extra = json['extra'].cast<String>();
    title = json['title'];
    if (json['action'] != null) {
      action = [];//Action>();
      json['action'].forEach((v) {
        action.add(new Action.fromJson(v));
      });
    }
    avatar = json['avatar'];
    layout = json['layout'];
    layout = json['layout'];
    isVerified = json['is_verified'];
    subtitle2 = json['subtitle2'];
    subtitle1 = json['subtitle1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extra'] = this.extra;
    data['title'] = this.title;
    if (this.action != null) {
      data['action'] = this.action.map((v) => v.toJson()).toList();
    }
    data['is_verified'] = this.isVerified;
    data['avatar'] = this.avatar;
    data['layout'] = this.layout;
    data['subtitle1'] = this.subtitle1;
    data['subtitle2'] = this.subtitle2;
    return data;
  }
}

class Action {
  String type;
  bool value;

  Action({this.type, this.value});

  Action.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class Content {
  List<Media> media;
  ContentMeta contentMeta;
  String typeHeading;
  List<dynamic> keywords;
  List<dynamic> mentions;
  Content({this.media, this.contentMeta});

  Content.fromJson(Map<String, dynamic> json) {
    keywords = json['keywords'];
    mentions = json['mentions'];
    typeHeading = json['type_heading'];
    if (json['media'] != null) {
      media = [];//Media>();
      json['media'].forEach((v) {
        media.add(new Media.fromJson(v));
      });
    }
    contentMeta = json['content_meta'] != null
        ? new ContentMeta.fromJson(json['content_meta'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['keywords'] = keywords;
    data['mentions'] =mentions;
    data['type_heading'] = typeHeading;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    if (this.contentMeta != null) {
      data['content_meta'] = this.contentMeta.toJson();
    }
    return data;
  }
}
class OtherImageUrls {
  String s64dp;
  String s128dp;
  String s256dp;
  String s512dp;
  String original;

  OtherImageUrls(
      {this.s64dp, this.s128dp, this.s256dp, this.s512dp, this.original});

  OtherImageUrls.fromJson(Map<String, dynamic> json) {
    s64dp = json['64dp'];
    s128dp = json['128dp'];
    s256dp = json['256dp'];
    s512dp = json['512dp'];
    original = json['original'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['64dp'] = this.s64dp;
    data['128dp'] = this.s128dp;
    data['256dp'] = this.s256dp;
    data['512dp'] = this.s512dp;
    data['original'] = this.original;
    return data;
  }
}
class Media {
  String fileType;
  String mediaType;
  String mediaUrl;
  String mediaThumbnailUrl;
  OtherImageUrls otherImageUrls;
  Media({this.mediaType, this.mediaUrl});

  Media.fromJson(Map<String, dynamic> json) {
    mediaType = json['media_type'];
    mediaUrl = json['media_url'];
    fileType = json['file_type'];
    mediaThumbnailUrl = json['media_thumbnail_url'];
    otherImageUrls = json['other_image_urls'] != null
        ? new OtherImageUrls.fromJson(json['other_image_urls'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_type'] = this.mediaType;
    data['file_type'] = this.fileType;
    data['media_url'] = this.mediaUrl;
    data['media_thumbnail_url'] = this.mediaThumbnailUrl;
    if (this.otherImageUrls != null) {
      data['other_image_urls'] = this.otherImageUrls.toJson();
    }
    return data;
  }
}

class ContentMeta {
  String meta;
  String title;
  String subtitle1;
  String subtitle2;
  OtherPollRequest others;

  ContentMeta({this.meta, this.title, this.subtitle1, this.subtitle2,this.others});

  ContentMeta.fromJson(Map<String, dynamic> json) {
    meta = json['meta'];
    title = json['title'];
    subtitle1 = json['subtitle1'];
    subtitle2 = json['subtitle2'];
    others = json['others'] != null
        ? new OtherPollRequest.fromJson(json['others'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['meta'] = this.meta;
    data['title'] = this.title;
    data['subtitle1'] = this.subtitle1;
    data['subtitle2'] = this.subtitle2;
    if (this.others != null) {
      data['others'] = this.others.toJson();
    }
    return data;
  }
}

class Statistics {
  int starRating;
  int commentCount;

  Statistics({this.starRating, this.commentCount});

  Statistics.fromJson(Map<String, dynamic> json) {
    starRating = json['star_rating'];
    commentCount = json['comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['star_rating'] = this.starRating;
    data['comment_count'] = this.commentCount;
    return data;
  }
}

class Specifications {
  int size;
  int width;
  int height;
  String color;

  Specifications({this.size, this.width, this.height,this.color});

  Specifications.fromJson(Map<String, dynamic> json) {
    size = json['size'];
    width = json['width'];
    height = json['height'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['width'] = this.width;
    data['height'] = this.height;
    data['color'] = this.color;
    return data;
  }
}