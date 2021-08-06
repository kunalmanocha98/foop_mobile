class StaffListRequest {
  String? searchVal;
  int? institutionId;
  String? personType;
  int? pageNumber;
  int? pageSize;

  StaffListRequest(
      {this.searchVal,
        this.institutionId,
        this.personType,
        this.pageNumber,
        this.pageSize});

  StaffListRequest.fromJson(Map<String, dynamic> json) {
    searchVal = json['search_val'];
    institutionId = json['business_id'];
    personType = json['person_type'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['search_val'] = this.searchVal;
    data['business_id'] = this.institutionId;
    data['person_type'] = this.personType;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    return data;
  }
}



class StaffListResponse {
  String? statusCode;
  String? message;
  List<StaffListItem>? rows;
  int? total;

  StaffListResponse({this.statusCode, this.message, this.rows, this.total});

  StaffListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//StaffListItem>();
      json['rows'].forEach((v) {
        rows!.add(new StaffListItem.fromJson(v));
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

class StaffListItem {
  int? id;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? coverImages;
  String? personType;

  StaffListItem(
      {this.id,
        this.firstName,
        this.lastName,
        this.profileImage,
        this.coverImages,
        this.personType});

  StaffListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    coverImages = json['cover_images'];
    personType = json['person_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['cover_images'] = this.coverImages;
    data['person_type'] = this.personType;
    return data;
  }
}