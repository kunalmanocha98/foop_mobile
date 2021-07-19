class DepartmentResponse {
  String statusCode;
  String message;
  List<DepartmentItems> rows;
  int total;

  DepartmentResponse({this.statusCode, this.message, this.rows, this.total});

  DepartmentResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//DepartmentItems>();
      json['rows'].forEach((v) {
        rows.add(new DepartmentItems.fromJson(v));
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

class DepartmentItems {
  String departmentGroup;
  List<Departments> departments;

  DepartmentItems({this.departmentGroup, this.departments});

  DepartmentItems.fromJson(Map<String, dynamic> json) {
    departmentGroup = json['department_group'];
    if (json['departments'] != null) {
      departments = [];//Departments>();
      json['departments'].forEach((v) {
        departments.add(new Departments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['department_group'] = this.departmentGroup;
    if (this.departments != null) {
      data['departments'] = this.departments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Departments {
  int id;
  String departmentName;
  String departmentCode;
  String departmentDescription;
bool isSelected=false;
  Departments(
      {this.id,
        this.departmentName,
        this.departmentCode,
        this.isSelected,
        this.departmentDescription});

  Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentName = json['department_name'];
    departmentCode = json['department_code'];
    departmentDescription = json['department_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department_name'] = this.departmentName;
    data['department_code'] = this.departmentCode;
    data['department_description'] = this.departmentDescription;
    return data;
  }
}
