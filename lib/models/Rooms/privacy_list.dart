class RoomPrivacyTypeRequest {
  int pageNumber;
  int pageSize;
  String searchVal;

  RoomPrivacyTypeRequest({this.pageNumber, this.pageSize, this.searchVal});

  RoomPrivacyTypeRequest.fromJson(Map<String, dynamic> json) {
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    searchVal = json['searchVal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['searchVal'] = this.searchVal;
    return data;
  }
}

class RoomPrivacyListResponse {
  String statusCode;
  String message;
  List<PrivacyListItem> rows;
  int total;

  RoomPrivacyListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  RoomPrivacyListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//PrivacyListItem>();
      json['rows'].forEach((v) {
        rows.add(new PrivacyListItem.fromJson(v));
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

class PrivacyListItem {
  String privacyTypeName;
  String privacyTypeCode;
  String privacyTypeDescription;
  String imageUrl;
  int roomPrivacyTypesId;

  PrivacyListItem(
      {this.privacyTypeName,
        this.privacyTypeCode,
        this.privacyTypeDescription,
        this.imageUrl,
        this.roomPrivacyTypesId});

  PrivacyListItem.fromJson(Map<String, dynamic> json) {
    privacyTypeName = json['privacy_type_name'];
    privacyTypeCode = json['privacy_type_code'];
    privacyTypeDescription = json['privacy_type_description'];
    imageUrl = json['image_url'];
    roomPrivacyTypesId = json['room_privacy_types_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['privacy_type_name'] = this.privacyTypeName;
    data['privacy_type_code'] = this.privacyTypeCode;
    data['privacy_type_description'] = this.privacyTypeDescription;
    data['image_url'] = this.imageUrl;
    data['room_privacy_types_id'] = this.roomPrivacyTypesId;
    return data;
  }
}