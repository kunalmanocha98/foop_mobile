class RolesList {
  String? statusCode;
  String? message;
  List<Roles>? rows;

  RolesList({this.statusCode, this.message, this.rows});

  RolesList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//Roles>();
      json['rows'].forEach((v) {
        rows!.add(new Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Roles {
  int? id;
  String? roleName;
  bool? isSelected = false;
  String? roleCode;
  String? roleDescription;

  Roles({this.id, this.roleName, this.roleCode, this.roleDescription});

  Roles.fromJson(Map<String, dynamic> json) {
    id = json['role_id'];
    roleName = json['role_name'];
    roleCode = json['role_code'];
    isSelected = json['isSelected'];
    roleDescription = json['role_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role_id'] = this.id;
    data['role_name'] = this.roleName;
    data['role_code'] = this.roleCode;
    data['isSelected'] = this.isSelected;
    data['role_description'] = this.roleDescription;
    return data;
  }
}
