class PostReceiverRequest {
  String? searchVal;
  int? pageSize;
  int? pageNumber;
  String? type;
  int? institutionId;
  String? postType;

  PostReceiverRequest(
      {this.searchVal,
        this.pageSize,
        this.pageNumber,
        this.type,
        this.postType,
        this.institutionId});

  PostReceiverRequest.fromJson(Map<String, dynamic> json) {
    searchVal = json['searchVal'];
    pageSize = json['page_size'];
    pageNumber = json['page_number'];
    type = json['type'];
    institutionId = json['institution_id'];
    postType = json['post_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchVal'] = this.searchVal;
    data['page_size'] = this.pageSize;
    data['page_number'] = this.pageNumber;
    data['type'] = this.type;
    data['institution_id'] = this.institutionId;
    data['post_type'] = this.postType;
    return data;
  }
}


class PostReceiverResponse {
  String? statusCode;
  String? message;
  List<PostReceiverListItem?>? rows;
  int? total;

  PostReceiverResponse({this.statusCode, this.message, this.rows, this.total});

  PostReceiverResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//PostReceiverListItem>();
      json['rows'].forEach((v) {
        rows!.add(new PostReceiverListItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v!.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class PostReceiverListItem {
  String? recipientTypeCode;
  String? recipientTypeDescription;
  String? recipientType;
  int? recipientTypeReferenceId;
  bool? isSelected;
  bool? isAllowed;
  String? allowedMsg;
  String? recipientImage;

  PostReceiverListItem(
      {this.recipientTypeCode,
        this.recipientTypeDescription,
        this.recipientType,
        this.recipientTypeReferenceId,
        this.isAllowed,
        this.allowedMsg,
        this.recipientImage,
      this.isSelected});

  PostReceiverListItem.fromJson(Map<String, dynamic> json) {
    recipientTypeCode = json['recipient_type_code'];
    recipientTypeDescription = json['recipient_type_description'];
    recipientType = json['recipient_type'];
    recipientTypeReferenceId = json['recipient_type_reference_id'];
    isSelected = json['is_selected'];
    isAllowed = json['is_allowed'];
    allowedMsg = json['allowed_msg'];
    recipientImage = json['recipient_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient_type_code'] = this.recipientTypeCode;
    data['recipient_type_description'] = this.recipientTypeDescription;
    data['recipient_type'] = this.recipientType;
    data['recipient_type_reference_id'] = this.recipientTypeReferenceId;
    data['is_selected'] = this.isSelected;
    data['is_allowed'] = this.isAllowed;
    data['allowed_msg'] = this.allowedMsg;
    data['recipient_image'] = this.recipientImage;
    return data;
  }
}