class RequestListRequest {
  int? institutionId;
  int? pageNumber;
  int? pageSize;
  String? searchVal;
  int? approvedByPersonId;

  RequestListRequest(
      {this.institutionId,
        this.pageNumber,
        this.pageSize,
        this.searchVal,
        this.approvedByPersonId});

  RequestListRequest.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    searchVal = json['search_val'];
    approvedByPersonId = json['approved_by_person_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['search_val'] = this.searchVal;
    data['approved_by_person_id'] = this.approvedByPersonId;
    return data;
  }
}

class RequestListResponse {
  String? statusCode;
  String? message;
  List<RequestListItem>? rows;
  int? total;

  RequestListResponse({this.statusCode, this.message, this.rows, this.total});

  RequestListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//RequestListItem>();
      json['rows'].forEach((v) {
        rows!.add(new RequestListItem.fromJson(v));
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

class RequestListItem {
  int? institutionUserId;
  int? personId;
  int? institutionId;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? profileImage;
  String? assignmentStatus;
  String? personType;
  String? className;


  RequestListItem(
      {this.institutionUserId,
        this.personId,
        this.firstName,
        this.lastName,
        this.email,
        this.mobile,
        this.profileImage,
        this.assignmentStatus,
        this.personType,
        this.institutionId,
        this.className});

  RequestListItem.fromJson(Map<String, dynamic> json) {
    institutionUserId = json['institution_user_id'];
    personId = json['person_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    mobile = json['mobile'];
    profileImage = json['profile_image'];
    assignmentStatus = json['assignment_status'];
    personType = json['person_type'];
    className = json['class_name'];
    institutionId = json['business_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['institution_user_id'] = this.institutionUserId;
    data['person_id'] = this.personId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['profile_image'] = this.profileImage;
    data['assignment_status'] = this.assignmentStatus;
    data['person_type'] = this.personType;
    data['class_name'] = this.className;
    data['business_id']=this.institutionId;
    return data;
  }
}