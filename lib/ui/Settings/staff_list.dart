class StaffListRequest {
  int? institutionId;
  String? searchVal;
  int? pageNumber;
  int? pageSize;

  StaffListRequest(
      {this.institutionId, this.searchVal, this.pageNumber, this.pageSize});

  StaffListRequest.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    searchVal = json['search_val'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['search_val'] = this.searchVal;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    return data;
  }
}

class StaffListResponse {
  String? statusCode;
  String? message;
  List<StaffListMember>? rows;
  int? total;

  StaffListResponse({this.statusCode, this.message, this.rows, this.total});

  StaffListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows =  [];
      json['rows'].forEach((v) {
        rows!.add(new StaffListMember.fromJson(v));
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

class StaffListMember {
  int? id;
  int? institutionId;
  String? institutionName;
  String? personName;
  int? personId;
  String? profileImage;

  StaffListMember(
      {this.id,
        this.institutionId,
        this.institutionName,
        this.personName,
        this.personId,
        this.profileImage});

  StaffListMember.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionId = json['business_id'];
    institutionName = json['institution_name'];
    personName = json['person_name'];
    personId = json['person_id'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.institutionId;
    data['institution_name'] = this.institutionName;
    data['person_name'] = this.personName;
    data['person_id'] = this.personId;
    data['profile_image'] = this.profileImage;
    return data;
  }
}

class AssignRoleResponse {
  String? statusCode;
  String? message;
  dynamic rows;
  int? total;

  AssignRoleResponse({this.statusCode, this.message, this.rows, this.total});

  AssignRoleResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['rows'] = this.rows;
    data['total'] = this.total;
    return data;
  }
}

class Rows {
  int? institutionId;
  int? personId;
  int? roleId;
  int? id;

  Rows({this.institutionId, this.personId, this.roleId, this.id});

  Rows.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    personId = json['person_id'];
    roleId = json['role_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['person_id'] = this.personId;
    data['role_id'] = this.roleId;
    data['id'] = this.id;
    return data;
  }
}