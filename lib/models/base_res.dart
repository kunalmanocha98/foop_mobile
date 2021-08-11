import 'dart:convert';

import 'package:oho_works_app/models/post/postlist.dart';

import 'Rooms/roomlistmodels.dart';

class BaseResponses {
  List<CommonCardData>? rows;
  String? statusCode;
  String? message;
  int? total;

  BaseResponses({this.rows, this.statusCode, this.message, this.total});

  BaseResponses.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    if (json['rows'] != null) {
      rows = [];//CommonCardData>();
      json['rows'].forEach((v) {
        if (v != null) rows!.add(new CommonCardData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommonCardData {
  List<Data>? data;
  List<SubRow>? subRow;
  String? id;
  bool? isUserExist;
  String? userName;
  bool? isVerified;
  String? locality;
  String? localityInstitute;
  String? institutionId;
  String? type;
  String? classTeacherName;
  String? totalCount;
  String? cardName;
  String? cardNames;
  String? image;
  String? coverImage;
  String? name;
  String? backgroundColor;
  String? title;
  bool? isIntroCard;
  bool? isEditable;
  String? textOne;
  String? textTwo;
  String? textThree;
  String? textFour;
  String? textFive;
  String? textSix;
  String? textSeven;
  String? textEight;
  String? textTen;
  String? textEleven;
  String? textTwelve;
  bool? isCurrent;
  String? textNine;
  bool? isFollow;
  bool? isFollow2;
  bool? isShowMore;
  bool? isBlur;
  String? urlOne;
  String? urlThree;
  String? urlFour;
  String? urlTwo;
  double? ratingValue;
  double? ratingValueFiveStar;
  double? ratingValueFourStar;
  double? ratingValueThreeStar;
  double? ratingValueTwoStar;
  double? ratingValueOneStar;
  int? progress;
  String? imageUrl;
  String? moneyVal;
  String? quote;
  int? givenRating;
  int? givenratingid;
  int? givenreviewid;
  String? givenReview;
  double? lat;
  double? lon;
  String? heading;
  String? coins;

  CommonCardData.fromJson(Map<String, dynamic> json) {
    progress = json['progress'];
    lat = json['lat'];
    lon = json['lon'];
    heading = json['heading'];
    coins = json['coins'];
    givenReview = json['givenReview'];
    givenreviewid = json['givenreviewid'];
    givenratingid = json['givenratingid'];
    id = json['id'];
    userName = json['user_name'];
    isVerified = json['is_user_verified'];
    givenRating = json["givenRating"];
    isUserExist = json['is_user_exist'];
    locality = json['locality'];
    type = json['type'];
    localityInstitute = json['locality_val'];
    isFollow2 = json['is_following'];
    institutionId = json['business_id'];
    coverImage = json['cover_image'];
    name = json['name'];

    textTen = json['textTen'];
    name = json['name'];
    classTeacherName = json['class_taecher_name'];
    textEleven = json['textEleven'];
    textTwelve = json['textTwelve'];
    isCurrent = json['is_current'];
    cardName = json['cardName'];

    totalCount = json['total_count'];
    textOne = json['textOne'];
    image = json['image'];
    backgroundColor = json['backgroundColor'];
    title = json['title'];
    isEditable = json['isEditable'];
    textNine = json['textNine'].toString();
    isFollow = json['isFollow'];
    isShowMore = json['isShowMore'];
    isIntroCard = json['isIntroCard'];
    textTwo = json['textTwo'].toString();
    textThree = json['textThree'].toString();
    textFour = json['textFour'].toString();
    textFive = json['textFive'].toString();
    textSix = json['textSix'].toString();
    textSeven = json['textSeven'].toString();
    textEight = json['textEight'].toString();
    urlOne = json['urlOne'];
    urlThree = json['urlThree'];
    urlFour = json['urlFour'];
    urlTwo = json['urlTwo'];
    isBlur = json['isBlur'];
    ratingValueFiveStar = json['ratingValueFiveStar'];
    ratingValueFourStar = json['ratingValueFourStar'];
    ratingValueThreeStar = json['ratingValueThreeStar'];
    ratingValueTwoStar = json['ratingValueTwoStar'];
    ratingValueOneStar = json['ratingValueOneStar'];
    ratingValue = json['ratingValue'];
    imageUrl = json['image_url'];
    moneyVal = json['money_val'];
    quote = json['quote'];

    if (json['subRow'] != null) {
      subRow = [];//SubRow>();
      json['subRow'].forEach((v) {
        subRow!.add(new SubRow.fromJson(v));
      });
    }
    cardNames = json['card_name'];
    if (json['data'] != null) {
      data = [];//Data>();
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['givenratingid'] = this.givenratingid;
    data['user_name'] = this.userName;
    data['givenreviewid'] = this.givenreviewid;
    data['givenReview'] = this.givenReview;
    data['money_val'] = this.moneyVal;
    data['quote'] = this.quote;
    data["givenRating"] = this.givenRating;
    data['is_user_verified'] = this.isVerified;
    data['progress'] = this.progress;
    data['id'] = this.id;
    data['card_name'] = this.cardNames;
    data['name'] = this.name;
    data['type'] = this.type;
    data['is_user_exist'] = this.isUserExist;
    data['locality_val'] = this.localityInstitute;
    data['locality'] = this.locality;
    data['is_following'] = this.isFollow2;
    data['business_id'] = this.institutionId;
    data['cover_image'] = this.coverImage;
    data['class_taecher_name'] = this.classTeacherName;
    data['is_current'] = this.isCurrent;
    data['total_count'] = this.totalCount;
    data['textNine'] = this.textNine;
    data['image'] = this.image;
    data['isFollow'] = this.isFollow;
    data['isShowMore'] = this.isShowMore;
    data['cardName'] = this.cardName;
    data['isEditable'] = this.isEditable;
    data['backgroundColor'] = this.backgroundColor;
    data['title'] = this.title;
    data['textOne'] = this.textOne;
    data['isIntroCard'] = this.isIntroCard;
    data['textTwo'] = this.textTwo;
    data['textThree'] = this.textThree;
    data['textFour'] = this.textFour;
    data['textFive'] = this.textFive;
    data['textSix'] = this.textSix;
    data['textSeven'] = this.textSeven;
    data['textEight'] = this.textEight;
    data['urlOne'] = this.urlOne;
    data['urlTwo'] = this.urlTwo;
    data['urlFour'] = this.urlFour;
    data['urlThree'] = this.urlThree;
    data['image_url'] = this.imageUrl;
    data['money_val'] = this.moneyVal;
    data['quote'] = this.quote;
    data['isBlur'] = this.isBlur;
    data['ratingValueFiveStar'] = this.ratingValueFiveStar;
    data['ratingValueFourStar'] = this.ratingValueFourStar;
    data['ratingValueThreeStar'] = this.ratingValueThreeStar;
    data['ratingValueTwoStar'] = this.ratingValueTwoStar;
    data['ratingValueOneStar'] = this.ratingValueOneStar;
    data['ratingValue'] = this.ratingValue;
    data['coins'] = this.coins;
    data['heading'] = this.heading;
    if (this.subRow != null) {
      data['subRow'] = this.subRow!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  CommonCardData({this.progress});
}

class Data {
  int? id;
  String? quotedByName;
  String? quoteText;
  String? suggestedType;
  String? quoteImageThumbnailUrl;
  String? quoteImageUrl;
  String? bannerText;
  String? bannerImageThumbnailUrl;
  String? bannerImageUrl;
  String? bannerSeq;
  String? title;
  String? subtitle;
  String? avatar;
  bool? isFollowed;
  int? postDatetime;
  bool? isBookmarked;
  String? postOwnerType;
  int? postOwnerTypeId;
  String? postType;
  int? postId;
  Null postTypeReferenceId;
  PostContent? postContent;
  bool? isRequestedByMember;
  String? roomOwnerType;
  int? roomOwnerTypeId;
  int? roomInstitutionId;
  String? roomName;
  String? roomDescription;
  bool? isPrivate;
  bool? isSharable;
  String? roomStatus;
  String? roomType;
  String? roomCreatedByType;
  int? roomCreatedById;
  int? membersCount;
  String? membershipStatus;
  String? memberRoleType;
  String? roomProfileImageUrl;
  bool? isAutoGeneratedRoom;
  HeaderRoom? header;
  List<MembersList>? membersList;
  bool? isVoted;

  Data(
      {this.id,
      this.quotedByName,
      this.quoteText,
      this.suggestedType,
      this.quoteImageThumbnailUrl,
      this.quoteImageUrl,
      this.bannerText,
      this.bannerImageThumbnailUrl,
      this.bannerImageUrl,
      this.bannerSeq,
      this.title,
      this.subtitle,
      this.avatar,
      this.isFollowed,
      this.postDatetime,
      this.isBookmarked,
      this.postOwnerType,
      this.postOwnerTypeId,
      this.postType,
      this.postId,
      this.postTypeReferenceId,
      this.postContent,
        this.roomOwnerType,
        this.roomOwnerTypeId,
        this.roomInstitutionId,
        this.roomName,
        this.isRequestedByMember,
        this.roomDescription,
        this.isPrivate,
        this.isSharable,
        this.roomStatus,
        this.roomType,
        this.roomCreatedByType,
        this.roomCreatedById,
        this.membersCount,
        this.membershipStatus,
        this.memberRoleType,
        this.isAutoGeneratedRoom,
        this.header,
        this.membersList,
        this.roomProfileImageUrl,
        this.isVoted,
      });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    suggestedType = json['suggested_type'];
    quotedByName = json['quoted_by_name'];
    quoteText = json['quote_text'];
    quoteImageThumbnailUrl = json['quote_image_thumbnail_url'];
    quoteImageUrl = json['quote_image_url'];
    bannerText = json['banner_text'];
    bannerImageThumbnailUrl = json['banner_image_thumbnail_url'];
    bannerImageUrl = json['banner_image_url'];
    bannerSeq = json['banner_seq'];
    title = json['title'];
    subtitle = json['subtitle'];
    avatar = json['avatar'];
    isFollowed = json['is_followed'];
    postDatetime = json['post_datetime'];
    isBookmarked = json['is_bookmarked'];
    postOwnerType = json['post_owner_type'];
    postOwnerTypeId = json['post_owner_type_id'];
    postType = json['post_type'];
    postId = json['post_id'];
    postTypeReferenceId = json['post_type_reference_id'];
    postContent = json['post_content'] != null
        ? new PostContent.fromJson(json['post_content'])
        : null;
    isRequestedByMember = json['is_requested_by_member'];
    roomOwnerType = json['room_owner_type'];
    roomOwnerTypeId = json['room_owner_type_id'];
    roomInstitutionId = json['room_institution_id'];
    roomName = json['room_name'];
    roomDescription = json['room_description'];
    isPrivate = json['is_private'];
    isSharable = json['is_sharable'];
    roomStatus = json['room_status'];
    roomType = json['room_type'];
    roomCreatedByType = json['room_created_by_type'];
    roomCreatedById = json['room_created_by_id'];
    membersCount = json['members_count'];
    membershipStatus = json['membership_status'];
    memberRoleType = json['member_role_type'];
    roomProfileImageUrl = json['room_profile_image_url'];
    isAutoGeneratedRoom = json['is_auto_created'];
    isVoted = json['is_voted'];
    header = json['header'] != null ? new HeaderRoom.fromJson(json['header']) : null;
    if (json['members_list'] != null) {
      membersList = [];//MembersList>();
      json['members_list'].forEach((v) {membersList!.add(new MembersList.fromJson(v));});
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['suggested_type'] = this.suggestedType;
    data['quoted_by_name'] = this.quotedByName;
    data['quote_text'] = this.quoteText;
    data['quote_image_thumbnail_url'] = this.quoteImageThumbnailUrl;
    data['quote_image_url'] = this.quoteImageUrl;
    data['banner_text'] = this.bannerText;
    data['banner_image_thumbnail_url'] = this.bannerImageThumbnailUrl;
    data['banner_image_url'] = this.bannerImageUrl;
    data['banner_seq'] = this.bannerSeq;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['avatar'] = this.avatar;
    data['is_followed'] = this.isFollowed;
    data['post_datetime'] = this.postDatetime;
    data['is_bookmarked'] = this.isBookmarked;
    data['post_owner_type'] = this.postOwnerType;
    data['post_owner_type_id'] = this.postOwnerTypeId;
    data['post_type'] = this.postType;
    data['post_id'] = this.postId;
    data['post_type_reference_id'] = this.postTypeReferenceId;
    if (this.postContent != null) {
      data['post_content'] = this.postContent!.toJson();
    }
    data['is_voted'] = this.isVoted;
    data['is_requested_by_member']=this.isRequestedByMember;
    data['room_owner_type'] = this.roomOwnerType;
    data['room_owner_type_id'] = this.roomOwnerTypeId;
    data['room_institution_id'] = this.roomInstitutionId;
    data['room_name'] = this.roomName;
    data['room_description'] = this.roomDescription;
    data['is_private'] = this.isPrivate;
    data['is_sharable'] = this.isSharable;
    data['room_status'] = this.roomStatus;
    data['room_type'] = this.roomType;
    data['room_created_by_type'] = this.roomCreatedByType;
    data['room_created_by_id'] = this.roomCreatedById;
    data['members_count'] = this.membersCount;
    data['membership_status'] = this.membershipStatus;
    data['member_role_type'] = this.memberRoleType;
    data['room_profile_image_url'] = this.roomProfileImageUrl;
    data['is_auto_created'] = this.isAutoGeneratedRoom;
    if (this.header != null) {
      data['header'] = this.header!.toJson();
    }
    if (this.membersList != null) {
      data['members_list'] = this.membersList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HeaderRoom {
  String? title;
  List<Action>? action;
  String? avatar;
  double? rating;
  String? subtitle1;
  bool? isVerified;

  HeaderRoom(
      {this.title,
        this.action,
        this.avatar,
        this.rating,
        this.subtitle1,
        this.isVerified});

  HeaderRoom.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['action'] != null) {
      action = [];//Action>();
      json['action'].forEach((v) {
        action!.add(new Action.fromJson(v));
      });
    }
    avatar = json['avatar'];
    rating = json['rating'];
    subtitle1 = json['subtitle1'];
    isVerified = json['is_verified'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.action != null) {
      data['action'] = this.action!.map((v) => v.toJson()).toList();
    }
    data['avatar'] = this.avatar;
    data['rating'] = this.rating;
    data['subtitle1'] = this.subtitle1;
    data['is_verified'] = this.isVerified;
    return data;
  }
}
class Action {
  String? type;
  bool? value;

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


class SubRow {
  List<SubRowInternal>? subRow;
  List<String>? images;
  String? personType;
  String? locality;
  String? isUserAuthorized;
  int? starRatingId;
  String? imageUrl;
  String? childId;
  bool? isFollow2;
  String? standardExpertiseCategoryTypes;
  List<String>? abilites;
  String? institutionCourse;
  String? institutionSubject;
  String? institutionAcademicYearId;
  String? standardExpertiseCategoryId;
  String? standardExpertiseCategoryTypeId;
  String? institutionClassId;
  String? instSubjectId;
  int? allInstitutions;
  int? allInstitutionsId;
  String? institutionId;
  String? id;
  int? institutionClass;
  int? rattingStar;
  double? avgRating;
  String? totalCount;
  String? language;
  String? course;
  String? department;
  String? gradientOne;
  String? gradientTwo;
  String? cardName;
  String? backgroundColor;
  String? title;
  bool? isEditable;
  bool? isIntroCard;
  String? textOne;
  String? textTwo;
  String? textThree;
  String? textFour;
  String? textFive;
  String? textSix;
  String? textSeven;
  String? textEight;
  bool? isFollow;
  bool? isShowMore;
  bool? isBlur;
  bool? isSelected;
  String? urlOne;
  String? urlThree;
  String? urlFour;
  String? urlTwo;
  String? ratingValue;
  String? ratingValueFiveStar;
  String? ratingValueFourStar;
  String? ratingValueThreeStar;
  String? ratingValueTwoStar;
  String? ratingValueOneStar;
  String? classTeacherName;
  String? chairperson;

  SubRow.fromJson(Map<String, dynamic> json) {
    if (json['subRow'] != null) {
      subRow = [];//SubRowInternal>();
      json['subRow'].forEach((v) {
        subRow!.add(new SubRowInternal.fromJson(v));
      });
    }
    images =
        json['imagesURL'] != null ? json['imagesURL'].cast<String>() : null;
    totalCount = json['total_count'];
    rattingStar = json['star_rating'];
    institutionClass = json['institution_class'];
    locality = json['locality'];
    isUserAuthorized = json['is_user_authorize'];
    chairperson = json['chairperson'];
    course = json['course'];
    department = json['department'];
    childId = json['child_id'];
    isFollow2 = json['is_following'];
    starRatingId = json['star_rating_id'];
    avgRating = json['average_rating'];
    id = json['id'] != null ? json['id'] : "";
    standardExpertiseCategoryTypeId = json['standardExpertiseCategoryTypes_id'];
    institutionId = json['business_id'];
    standardExpertiseCategoryTypes = json['standardExpertiseCategoryTypes'];
    gradientOne = json['gradientOne'];
    gradientTwo = json['gradientTwo'];
    cardName = json['cardName'];
    textOne = json['textOne'];
    imageUrl = json['image_url'];
    personType = json['person_type'];
    institutionCourse = json['institution_course'];
    institutionSubject = json['institution_subject'];
    institutionAcademicYearId = json['institution_academic_year_id'];
    standardExpertiseCategoryId = json['standardExpertiseCategory_id'];
    institutionClassId = json['institution_class_id'];
    instSubjectId = json['institution_subject_id'];
    classTeacherName = json['class_taecher_name'];
    language = json['language'];
    backgroundColor = json['backgroundColor'];
    title = json['title'];
    isEditable = json['isEditable'];
    isFollow = json['isFollow'];
    isShowMore = json['isShowMore'];
    isIntroCard = json['isIntroCard'];
    textTwo = json['textTwo'];
    textThree = json['textThree'];
    textFour = json['textFour'];
    textFive = json['textFive'];
    textSix = json['textSix'];
    textSeven = json['textSeven'];
    textEight = json['textEight'];
    urlOne = json['urlOne'];
    urlThree = json['urlThree'];
    urlFour = json['urlFour'];
    urlTwo = json['urlTwo'];
    isBlur = json['isBlur'];
    ratingValueFiveStar = json['ratingValueFiveStar'];
    ratingValueFourStar = json['ratingValueFourStar'];
    ratingValueThreeStar = json['ratingValueThreeStar'];
    ratingValueTwoStar = json['ratingValueTwoStar'];
    ratingValueOneStar = json['ratingValueOneStar'];
    ratingValue = json['ratingValue'];
    allInstitutions = json['all_institutions'];
    allInstitutionsId = json['all_institutions_id'];
    abilites =
        json['abilities'] != null ? json['abilities'].cast<String>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.subRow != null) {
      data['subRow'] = this.subRow!.map((v) => v.toJson()).toList();
    }
    data['institution_class'] = this.institutionClass;
    data['class_taecher_name'] = this.classTeacherName;
    data['all_institutions_id'] = this.allInstitutionsId;
    data['standardExpertiseCategoryTypes_id'] =
        this.standardExpertiseCategoryTypeId;
    data['institution_subject_id'] = instSubjectId;
    data['id'] = this.id;
    data['is_user_authorize'] = isUserAuthorized;
    data['child_id'] = this.childId;
    data['is_following'] = this.isFollow2;
    data['locality'] = this.locality;
    data['business_id'] = institutionId;
    data['standardExpertiseCategoryTypes'] =
        this.standardExpertiseCategoryTypes;
    data['language'] = this.language;
    data['course'] = this.course;
    data['image_url'] = this.imageUrl;
    data['chairperson'] = this.chairperson;
    data['star_rating_id'] = this.starRatingId;
    data['average_rating'] = this.avgRating;
    data['all_institutions'] = this.allInstitutions;
    data['institution_course'] = this.institutionCourse;
    data['institution_subject'] = this.institutionSubject;
    data['institution_academic_year_id'] = this.institutionAcademicYearId;
    data['standardExpertiseCategory_id'] = this.standardExpertiseCategoryId;
    data['institution_class_id'] = this.institutionClassId;
    data['abilities'] = this.abilites;
    data['star_rating'] = this.rattingStar;
    data['person_type'] = this.personType;
    data['imagesURL'] = this.images;
    data['isFollow'] = this.isFollow;
    data['total_count'] = this.totalCount;
    data['isShowMore'] = this.isShowMore;
    data['cardName'] = this.cardName;
    data['backgroundColor'] = this.backgroundColor;
    data['title'] = this.title;
    data['isEditable'] = this.isEditable;
    data['textOne'] = this.textOne;
    data['isIntroCard'] = this.isIntroCard;
    data['textTwo'] = this.textTwo;
    data['textThree'] = this.textThree;
    data['textFour'] = this.textFour;
    data['textFive'] = this.textFive;
    data['textSix'] = this.textSix;
    data['textSeven'] = this.textSeven;
    data['textEight'] = this.textEight;
    data['urlOne'] = this.urlOne;
    data['urlTwo'] = this.urlTwo;
    data['urlFour'] = this.urlFour;
    data['urlThree'] = this.urlThree;
    data['gradientOne'] = this.gradientOne;
    data['gradientTwo'] = this.gradientTwo;
    data['isBlur'] = this.isBlur;
    data['department'] = this.department;
    data['ratingValueFiveStar'] = this.ratingValueFiveStar;
    data['ratingValueFourStar'] = this.ratingValueFourStar;
    data['ratingValueThreeStar'] = this.ratingValueThreeStar;
    data['ratingValueTwoStar'] = this.ratingValueTwoStar;
    data['ratingValueOneStar'] = this.ratingValueOneStar;
    data['ratingValue'] = this.ratingValue;

    return data;
  }

  static Map<String, dynamic> toMap(SubRow s) => {
        'institution_class': s.institutionClass,
        'textThree': s.textThree,
      };

  static String encode(List<SubRow> s) => json.encode(
        s.map<Map<String, dynamic>>((s) => SubRow.toMap(s)).toList(),
      );

  static List<SubRow> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<SubRow>((item) => SubRow.fromJson(item))
          .toList();
}

class SubRowInternal {
  List<String>? images;
  String? personType;
  String? locality;
  String? isUserAuthorized;
  int? starRatingId;
  String? imageUrl;
  String? childId;
  bool? isFollow2;
  String? standardExpertiseCategoryTypes;
  List<String>? abilites;
  String? institutionCourse;
  String? institutionSubject;
  String? institutionAcademicYearId;
  String? standardExpertiseCategoryId;
  String? standardExpertiseCategoryTypeId;
  String? institutionClassId;
  String? instSubjectId;
  int? allInstitutions;
  int? allInstitutionsId;
  String? institutionId;
  String? id;
  int? institutionClass;
  int? rattingStar;
  double? avgRating;
  String? totalCount;
  String? language;
  String? course;
  String? gradientOne;
  String? gradientTwo;
  String? cardName;
  String? backgroundColor;
  String? title;
  bool? isEditable;
  bool? isIntroCard;
  String? textOne;
  String? textTwo;
  String? textThree;
  String? textFour;
  String? textFive;
  String? textSix;
  String? textSeven;
  String? textEight;
  bool? isFollow;
  bool? isShowMore;
  bool? isBlur;
  String? urlOne;
  String? urlThree;
  String? urlFour;
  String? urlTwo;
  String? ratingValue;
  String? ratingValueFiveStar;
  String? ratingValueFourStar;
  String? ratingValueThreeStar;
  String? ratingValueTwoStar;
  String? ratingValueOneStar;
  String? classTeacherName;
  String? chairperson;

  SubRowInternal.fromJson(Map<String, dynamic> json) {
    images =
        json['imagesURL'] != null ? json['imagesURL'].cast<String>() : null;
    totalCount = json['total_count'];
    rattingStar = json['star_rating'];
    locality = json['locality'];
    isUserAuthorized = json['is_user_authorize'];
    chairperson = json['chairperson'];
    course = json['course'];
    childId = json['child_id'];
    isFollow2 = json['is_following'];
    starRatingId = json['star_rating_id'];
    avgRating = json['average_rating'];
    id = json['id'] != null ? json['id'] : "";
    standardExpertiseCategoryTypeId = json['standardExpertiseCategoryTypes_id'];
    institutionId = json['business_id'];
    standardExpertiseCategoryTypes = json['standardExpertiseCategoryTypes'];
    gradientOne = json['gradientOne'];
    gradientTwo = json['gradientTwo'];
    cardName = json['cardName'];
    textOne = json['textOne'];
    imageUrl = json['image_url'];
    personType = json['person_type'];
    institutionCourse = json['institution_course'];
    institutionSubject = json['institution_subject'];
    institutionAcademicYearId = json['institution_academic_year_id'];
    standardExpertiseCategoryId = json['standardExpertiseCategory_id'];
    institutionClassId = json['institution_class_id'];
    instSubjectId = json['institution_subject_id'];
    classTeacherName = json['class_taecher_name'];
    language = json['language'];
    backgroundColor = json['backgroundColor'];
    title = json['title'];
    isEditable = json['isEditable'];
    isFollow = json['isFollow'];
    isShowMore = json['isShowMore'];
    isIntroCard = json['isIntroCard'];
    textTwo = json['textTwo'];
    textThree = json['textThree'];
    textFour = json['textFour'];
    textFive = json['textFive'];
    textSix = json['textSix'];
    textSeven = json['textSeven'];
    textEight = json['textEight'];
    urlOne = json['urlOne'];
    urlThree = json['urlThree'];
    urlFour = json['urlFour'];
    urlTwo = json['urlTwo'];
    isBlur = json['isBlur'];
    ratingValueFiveStar = json['ratingValueFiveStar'];
    ratingValueFourStar = json['ratingValueFourStar'];
    ratingValueThreeStar = json['ratingValueThreeStar'];
    ratingValueTwoStar = json['ratingValueTwoStar'];
    ratingValueOneStar = json['ratingValueOneStar'];
    ratingValue = json['ratingValue'];
    allInstitutions = json['all_institutions'];
    allInstitutionsId = json['all_institutions_id'];
    abilites =
        json['abilities'] != null ? json['abilities'].cast<String>() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['class_taecher_name'] = this.classTeacherName;
    data['all_institutions_id'] = this.allInstitutionsId;
    data['standardExpertiseCategoryTypes_id'] =
        this.standardExpertiseCategoryTypeId;
    data['institution_subject_id'] = instSubjectId;
    data['id'] = this.id;
    data['is_user_authorize'] = isUserAuthorized;
    data['child_id'] = this.childId;
    data['is_following'] = this.isFollow2;
    data['locality'] = this.locality;
    data['business_id'] = institutionId;
    data['standardExpertiseCategoryTypes'] =
        this.standardExpertiseCategoryTypes;
    data['language'] = this.language;
    data['course'] = this.course;
    data['image_url'] = this.imageUrl;
    data['chairperson'] = this.chairperson;
    data['star_rating_id'] = this.starRatingId;
    data['average_rating'] = this.avgRating;
    data['all_institutions'] = this.allInstitutions;
    data['institution_course'] = this.institutionCourse;
    data['institution_subject'] = this.institutionSubject;
    data['institution_academic_year_id'] = this.institutionAcademicYearId;
    data['standardExpertiseCategory_id'] = this.standardExpertiseCategoryId;
    data['institution_class_id'] = this.institutionClassId;
    data['abilities'] = this.abilites;
    data['star_rating'] = this.rattingStar;
    data['person_type'] = this.personType;
    data['imagesURL'] = this.images;
    data['isFollow'] = this.isFollow;
    data['total_count'] = this.totalCount;
    data['isShowMore'] = this.isShowMore;
    data['cardName'] = this.cardName;
    data['backgroundColor'] = this.backgroundColor;
    data['title'] = this.title;
    data['isEditable'] = this.isEditable;
    data['textOne'] = this.textOne;
    data['isIntroCard'] = this.isIntroCard;
    data['textTwo'] = this.textTwo;
    data['textThree'] = this.textThree;
    data['textFour'] = this.textFour;
    data['textFive'] = this.textFive;
    data['textSix'] = this.textSix;
    data['textSeven'] = this.textSeven;
    data['textEight'] = this.textEight;
    data['urlOne'] = this.urlOne;
    data['urlTwo'] = this.urlTwo;
    data['urlFour'] = this.urlFour;
    data['urlThree'] = this.urlThree;
    data['gradientOne'] = this.gradientOne;
    data['gradientTwo'] = this.gradientTwo;
    data['isBlur'] = this.isBlur;
    data['ratingValueFiveStar'] = this.ratingValueFiveStar;
    data['ratingValueFourStar'] = this.ratingValueFourStar;
    data['ratingValueThreeStar'] = this.ratingValueThreeStar;
    data['ratingValueTwoStar'] = this.ratingValueTwoStar;
    data['ratingValueOneStar'] = this.ratingValueOneStar;
    data['ratingValue'] = this.ratingValue;

    return data;
  }
}
