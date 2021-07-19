/// searchVal : null
/// page_size : 10
/// page_number : 1

class KeywordListRequest {
  String  searchVal;
  int pageSize;
  int pageNumber;

  KeywordListRequest({this.searchVal, this.pageSize, this.pageNumber});

  KeywordListRequest.fromJson(Map<String, dynamic> json) {
    searchVal = json['searchVal'];
    pageSize = json['page_size'];
    pageNumber = json['page_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchVal'] = this.searchVal;
    data['page_size'] = this.pageSize;
    data['page_number'] = this.pageNumber;
    return data;
  }
}


class KeywordListResponse {
  String statusCode;
  String message;
  List<KeywordListItem> rows;
  int total;

  KeywordListResponse({this.statusCode, this.message, this.rows, this.total});

  KeywordListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//KeywordListItem>();
      json['rows'].forEach((v) {
        rows.add(new KeywordListItem.fromJson(v));
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

class KeywordListItem {
  String id;
  String keyword;
  String display;

  KeywordListItem({this.id, this.keyword,this.display});

  KeywordListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    display = json['keyword'];
    keyword = json['keyword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['keyword'] = this.keyword;
    data['display'] = this.display;
    return data;
  }
}

class MentionsListResponse {
  String statusCode;
  String message;
  List<MentionListItem> rows;
  int total;

  MentionsListResponse({this.statusCode, this.message, this.rows, this.total});

  MentionsListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//MentionListItem>();
      json['rows'].forEach((v) {
        rows.add(new MentionListItem.fromJson(v));
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

class MentionListItem {
  int id;
  String fullName;
  String profileImage;
  String slug;
  String type;

  MentionListItem({this.id, this.fullName, this.profileImage, this.slug, this.type});

  MentionListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    profileImage = json['profile_image'];
    slug = json['slug'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['full_name'] = this.fullName;
    data['profile_image'] = this.profileImage;
    data['slug'] = this.slug;
    data['type'] = this.type;
    return data;
  }
}





