class DepartmentCreateRequest {
  int? businessId;
  List<AddedDepartments>? addedDepartments;
  List<AddedDepartments>? deletedDepartments;

  DepartmentCreateRequest(
      {this.businessId, this.addedDepartments, this.deletedDepartments});

  DepartmentCreateRequest.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    if (json['added_departments'] != null) {
      addedDepartments = [];
      json['added_departments'].forEach((v) {
        addedDepartments!.add(new AddedDepartments.fromJson(v));
      });
    }
    if (json['deleted_departments'] != null) {
      deletedDepartments = [];
      json['deleted_departments'].forEach((v) {
        deletedDepartments!.add(new AddedDepartments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    if (this.addedDepartments != null) {
      data['added_departments'] =
          this.addedDepartments!.map((v) => v.toJson()).toList();
    }
    if (this.deletedDepartments != null) {
      data['deleted_departments'] =
          this.deletedDepartments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddedDepartments {
  String? departmentName;
  String? departmentCode;
  String? departmentDescription;

  AddedDepartments(
      {this.departmentName, this.departmentCode, this.departmentDescription});

  AddedDepartments.fromJson(Map<String, dynamic> json) {
    departmentName = json['department_name'];
    departmentCode = json['department_code'];
    departmentDescription = json['department_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department_name'] = this.departmentName;
    data['department_code'] = this.departmentCode;
    data['department_description'] = this.departmentDescription;
    return data;
  }
}