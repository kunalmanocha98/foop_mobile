class SaveHistoryRequest {
  String? searchVal;
  String? entityType;
  String? searchPage;
  int? personId;
  int? institutionId;
  String? searchType;
  int? pageNumber;
  int? pageSize;
  dynamic entityDetails;

  SaveHistoryRequest(
      {this.searchVal,
        this.entityType,
        this.searchPage,
        this.personId,
        this.institutionId,
        this.searchType,
        this.pageNumber,
        this.pageSize,
        this.entityDetails});

  SaveHistoryRequest.fromJson(Map<String, dynamic> json) {
    searchVal = json['search_val'];
    entityType = json['entity_type'];
    searchPage = json['search_page'];
    personId = json['person_id'];
    institutionId = json['institution_id'];
    searchType = json['search_type'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    entityDetails = json['entity_details'] ;
        // != null
        // ? new EntityDetails.fromJson(json['entity_details'])
        // : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_val'] = this.searchVal;
    data['entity_type'] = this.entityType;
    data['search_page'] = this.searchPage;
    data['person_id'] = this.personId;
    data['institution_id'] = this.institutionId;
    data['search_type'] = this.searchType;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    // if (this.entityDetails != null) {
      data['entity_details'] = this.entityDetails;
    // }
    return data;
  }
}

class EntityDetails {
  int? id;
  String? avatar;
  String? title;
  String? subtitle1;
  String? subtitle2;
  String? link;
  bool? isFollowed;

  EntityDetails(
      {this.id,
        this.avatar,
        this.title,
        this.subtitle1,
        this.subtitle2,
        this.link,
        this.isFollowed});

  EntityDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    title = json['title'];
    subtitle1 = json['subtitle1'];
    subtitle2 = json['subtitle2'];
    link = json['link'];
    isFollowed = json['is_followed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['title'] = this.title;
    data['subtitle1'] = this.subtitle1;
    data['subtitle2'] = this.subtitle2;
    data['link'] = this.link;
    data['is_followed'] = this.isFollowed;
    return data;
  }
}

class SaveHistoryResponse {
  String? statusCode;
  String? message;
  int? total;

  SaveHistoryResponse({this.statusCode, this.message, this.total});

  SaveHistoryResponse.fromJson(Map<String, dynamic> json) {
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