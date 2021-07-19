class MemberListPayload {
  int roomId;
  int personId;
  bool withInInstitution;
  String searchVal;
  int pageSize;
  int pageNumber;
  String privacyType;

  MemberListPayload(
      {this.roomId,
      this.personId,
      this.withInInstitution,
      this.searchVal,
      this.pageSize,
        this.privacyType,
      this.pageNumber});

  MemberListPayload.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    personId = json['person_id'];
    withInInstitution = json['with_in_institution'];
    searchVal = json['searchVal'];
    pageSize = json['page_size'];
    pageNumber = json['page_number'];
    privacyType = json['privacy_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['person_id'] = this.personId;
    data['with_in_institution'] = this.withInInstitution;
    data['searchVal'] = this.searchVal;
    data['page_size'] = this.pageSize;
    data['page_number'] = this.pageNumber;
    data['privacy_type'] = this.privacyType;
    return data;
  }
}

class MemberListResponse {
  String statusCode;
  String message;
  List<MemberListItem> rows;
  int total;

  MemberListResponse({this.statusCode, this.message, this.rows, this.total});

  MemberListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//MemberListItem>();
      json['rows'].forEach((v) {
        rows.add(new MemberListItem.fromJson(v));
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

class MemberListItem {
  int id;
  String firstName;
  String lastName;
  String profileImage;
  bool isFollowed;
  bool isFollowing;
  bool isSelected;

  MemberListItem(
      {this.id,
      this.firstName,
      this.lastName,
      this.profileImage,
      this.isFollowed,
      this.isFollowing,
      this.isSelected});

  MemberListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    isFollowed = json['is_followed'];
    isFollowing = json['is_following'];
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['is_followed'] = this.isFollowed;
    data['is_following'] = this.isFollowing;
    data['isSelected'] = this.isSelected;
    return data;
  }
}

class InviteeListResponse {
  String statusCode;
  String message;
  List<InviteeListItem> rows;
  int total;

  InviteeListResponse({this.statusCode, this.message, this.rows, this.total});

  InviteeListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//InviteeListItem>();
      json['rows'].forEach((v) {
        rows.add(new InviteeListItem.fromJson(v));
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

class InviteeListItem {
  String recipientTypeCode;
  String recipientTypeDescription;
  String recipientImage;
  String recipientType;
  int recipientTypeReferenceId;
  bool isAllowed;
  bool isSelected;

  InviteeListItem(
      {this.recipientTypeCode,
        this.recipientTypeDescription,
        this.recipientImage,
        this.recipientType,
        this.recipientTypeReferenceId,
        this.isSelected,
        this.isAllowed,});

  InviteeListItem.fromJson(Map<String, dynamic> json) {
    recipientTypeCode = json['recipient_type_code'];
    recipientTypeDescription = json['recipient_type_description'];
    recipientImage = json['recipient_image'];
    recipientType = json['recipient_type'];
    recipientTypeReferenceId = json['recipient_type_reference_id'];
    isAllowed = json['is_allowed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recipient_type_code'] = this.recipientTypeCode;
    data['recipient_type_description'] = this.recipientTypeDescription;
    data['recipient_image'] = this.recipientImage;
    data['recipient_type'] = this.recipientType;
    data['recipient_type_reference_id'] = this.recipientTypeReferenceId;
    data['is_allowed'] = this.isAllowed;
    return data;
  }
}
