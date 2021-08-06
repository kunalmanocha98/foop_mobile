import 'package:oho_works_app/models/CalenderModule/event_listings.dart';
import 'package:oho_works_app/models/Rooms/roomlistmodels.dart';
import 'package:oho_works_app/models/post/postlist.dart';

class GlobalSearchRequest {
  String? searchVal;
  String? entityType;
  String? searchPage;
  int? personId;
  int? institutionId;
  String? searchType;
  int? pageNumber;
  int? pageSize;
  String? entitySubType;

  GlobalSearchRequest(
      {this.searchVal,
      this.entityType,
      this.searchPage,
      this.personId,
      this.institutionId,
      this.searchType,
      this.pageNumber,
        this.entitySubType,
      this.pageSize});

  GlobalSearchRequest.fromJson(Map<String, dynamic> json) {
    searchVal = json['search_val'];
    entityType = json['entity_type'];
    searchPage = json['search_page'];
    personId = json['person_id'];
    institutionId = json['business_id'];
    searchType = json['search_type'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    entitySubType = json['entity_subtype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_val'] = this.searchVal;
    data['entity_type'] = this.entityType;
    data['search_page'] = this.searchPage;
    data['person_id'] = this.personId;
    data['business_id'] = this.institutionId;
    data['search_type'] = this.searchType;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['entity_subtype'] = this.entitySubType;
    return data;
  }
}

class GlobalSearchResponse {
  String? statusCode;
  String? message;
  GlobalSearchResponseModel? rows;
  int? total;

  GlobalSearchResponse({this.statusCode, this.message, this.rows, this.total});

  GlobalSearchResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new GlobalSearchResponseModel.fromJson(json['rows'])
        : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class GlobalSearchResponseModel {
  List<SearchTypeItem>? person;
  List<SearchTypeItem>? institution;
  List<RoomListItem>? rooms;
  List<EventListItem>? events;
  List<PostListItem>? post;

  GlobalSearchResponseModel({this.person, this.institution});

  GlobalSearchResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['room'] != null) {
      rooms = [];//RoomListItem>();
      json['room'].forEach((v) {
        rooms!.add(new RoomListItem.fromJson(v));
      });
    }
    if (json['event'] != null) {
      events = [];//EventListItem>();
      json['event'].forEach((v) {
        events!.add(new EventListItem.fromJson(v));
      });
    }
    if (json['post'] != null) {
      post = [];//PostListItem>();
      json['post'].forEach((v) {
        post!.add(new PostListItem.fromJson(v));
      });
    }

    if (json['person'] != null) {
      person = [];//SearchTypeItem>();
      json['person'].forEach((v) {
        person!.add(new SearchTypeItem.fromJson(v));
      });
    }
    if (json['institution'] != null) {
      institution = [];//SearchTypeItem>();
      json['institution'].forEach((v) {
        institution!.add(new SearchTypeItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.post != null) {
      data['post'] = this.post!.map((v) => v.toJson()).toList();
    }
    if (this.rooms != null) {
      data['room'] = this.rooms!.map((v) => v.toJson()).toList();
    }
    if (this.events != null) {
      data['person'] = this.events!.map((v) => v.toJson()).toList();
    }



    if (this.person != null) {
      data['person'] = this.person!.map((v) => v.toJson()).toList();
    }
    if (this.institution != null) {
      data['institution'] = this.institution!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SearchTypeItem {
  int? id;
  String? avatar;
  String? title;
  String? subtitle1;
  String? subtitle2;
  String? link;
  bool? isFollowing;

  SearchTypeItem(
      {this.id,
      this.avatar,
      this.title,
      this.subtitle1,
      this.subtitle2,
      this.link,
      this.isFollowing});

  SearchTypeItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    title = json['title'];
    isFollowing = json['is_followed'];
    subtitle1 = json['subtitle1'];
    subtitle2 = json['subtitle2'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['title'] = this.title;
    data['is_followed'] = this.isFollowing;
    data['subtitle1'] = this.subtitle1;
    data['subtitle2'] = this.subtitle2;
    data['link'] = this.link;
    return data;
  }
}

class SearchTypeMasterModel {
  String? title;
  String? type;
  List<SearchTypeItem>? list;

  SearchTypeMasterModel({this.title, this.type, this.list});
}

class GlobalSearchHistoryResponse {
  String? statusCode;
  String? message;
  List<GlobalSearchHistoryItem>? rows;
  int? total;

  GlobalSearchHistoryResponse(
      {this.statusCode, this.message, this.rows, this.total});

  GlobalSearchHistoryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//GlobalSearchHistoryItem>();
      json['rows'].forEach((v) {
        rows!.add(new GlobalSearchHistoryItem.fromJson(v));
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

class GlobalSearchHistoryItem {
  String? searchVal;
  String? searchPage;
  String? entityType;
  int? personId;
  int? institutionId;
  String? searchType;
  int? searchDatetime;
  Null sessionId;
  Null deviceId;
  Null deviceIp;
  Null deviceMac;
  Null deviceFbId;
  Null appType;
  Null userLocation;
  dynamic entityDetails;


  GlobalSearchHistoryItem(
      {this.searchVal,
      this.searchPage,
      this.entityType,
      this.personId,
      this.institutionId,
      this.searchType,
      this.searchDatetime,
      this.sessionId,
      this.deviceId,
      this.deviceIp,
      this.deviceMac,
      this.deviceFbId,
      this.appType,
        this.entityDetails,
      this.userLocation});

  GlobalSearchHistoryItem.fromJson(Map<String, dynamic> json) {
    searchVal = json['search_val'];
    searchPage = json['search_page'];
    entityType = json['entity_type'];
    personId = json['person_id'];
    institutionId = json['business_id'];
    searchType = json['search_type'];
    searchDatetime = json['search_datetime'];
    sessionId = json['session_id'];
    deviceId = json['device_id'];
    deviceIp = json['device_ip'];
    deviceMac = json['device_mac'];
    deviceFbId = json['device_fb_id'];
    appType = json['app_type'];
    userLocation = json['user_location'];
    entityDetails = json['entity_details'];
        // != null
        // ? new EntityDetails.fromJson(json['entity_details'])
        // : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_val'] = this.searchVal;
    data['search_page'] = this.searchPage;
    data['entity_type'] = this.entityType;
    data['person_id'] = this.personId;
    data['business_id'] = this.institutionId;
    data['search_type'] = this.searchType;
    data['search_datetime'] = this.searchDatetime;
    data['session_id'] = this.sessionId;
    data['device_id'] = this.deviceId;
    data['device_ip'] = this.deviceIp;
    data['device_mac'] = this.deviceMac;
    data['device_fb_id'] = this.deviceFbId;
    data['app_type'] = this.appType;
    data['user_location'] = this.userLocation;
    // if (this.entityDetails != null) {
      data['entity_details'] = this.entityDetails;
    // }
    return data;
  }
}
