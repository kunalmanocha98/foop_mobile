class PostSubTypeListRequest {
  int pageNumber;
  int pageSize;
  String postType;
  String searchVal;
  PostSubTypeListRequest(
      {this.pageNumber, this.pageSize, this.postType, this.searchVal});

  PostSubTypeListRequest.fromJson(Map<String, dynamic> json) {
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    postType = json['post_type'];
    searchVal = json['searchVal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['post_type'] = this.postType;
    data['searchVal'] = this.searchVal;
    return data;
  }
}


class PostSubTypeListResponse {
  String statusCode;
  String message;
  List<PostSubTypeListItem> rows;
  int total;

  PostSubTypeListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  PostSubTypeListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//PostSubTypeListItem>();
      json['rows'].forEach((v) {
        rows.add(new PostSubTypeListItem.fromJson(v));
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

class PostSubTypeListItem {
  String postSubTypeName;
  String postSubTypeCode;
  String postSubTypeDescription;
  String imageUrl;
  int postSubTypesId;
  bool isSelected;

  PostSubTypeListItem(
      {this.postSubTypeName,
        this.postSubTypeCode,
        this.postSubTypeDescription,
        this.imageUrl,
        this.postSubTypesId,
      this.isSelected});

  PostSubTypeListItem.fromJson(Map<String, dynamic> json) {
    postSubTypeName = json['post_sub_type_name'];
    postSubTypeCode = json['post_sub_type_code'];
    postSubTypeDescription = json['post_sub_type_description'];
    imageUrl = json['image_url'];
    postSubTypesId = json['post_sub_types_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_sub_type_name'] = this.postSubTypeName;
    data['post_sub_type_code'] = this.postSubTypeCode;
    data['post_sub_type_description'] = this.postSubTypeDescription;
    data['image_url'] = this.imageUrl;
    data['post_sub_types_id'] = this.postSubTypesId;
    return data;
  }
}