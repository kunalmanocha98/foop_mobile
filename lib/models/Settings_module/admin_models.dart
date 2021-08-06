class AdminListResponse {
String? statusCode;
String? message;
List<AdminListItem>? rows;
int? total;

AdminListResponse({this.statusCode, this.message, this.rows, this.total});

AdminListResponse.fromJson(Map<String, dynamic> json) {
statusCode = json['statusCode'];
message = json['message'];
if (json['rows'] != null) {
rows = [];
json['rows'].forEach((v) {
rows!.add(new AdminListItem.fromJson(v));
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

class AdminListItem {
  int? id;
  int? institutionId;
  String? institutionName;
  String? personName;
  int? personId;
  String? profileImage;
  int? roleId;
  String? roleName;

  AdminListItem(
      {this.id,
        this.institutionId,
        this.institutionName,
        this.personName,
        this.personId,
        this.profileImage,
        this.roleId,
        this.roleName});

  AdminListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionId = json['business_id'];
    institutionName = json['institution_name'];
    personName = json['person_name'];
    personId = json['person_id'];
    profileImage = json['profile_image'];
    roleId = json['role_id'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.institutionId;
    data['institution_name'] = this.institutionName;
    data['person_name'] = this.personName;
    data['person_id'] = this.personId;
    data['profile_image'] = this.profileImage;
    data['role_id'] = this.roleId;
    data['role_name'] = this.roleName;
    return data;
  }
}

class RemoveAdminResponse {
  String? statusCode;
  String? message;
  String? rows;
  int? total;

  RemoveAdminResponse({this.statusCode, this.message, this.rows, this.total});

  RemoveAdminResponse.fromJson(Map<String, dynamic> json) {
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