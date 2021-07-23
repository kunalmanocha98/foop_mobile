
class AcademicDetailsSelectionListRequest {
  String? searchVal;
  int? pageNumber;
  int? pageSize;
  String? categoryType;
  List<String>? excludeType;

  AcademicDetailsSelectionListRequest(
      {this.searchVal, this.pageNumber, this.pageSize,this.categoryType,this.excludeType});

  AcademicDetailsSelectionListRequest.fromJson(Map<String, dynamic> json) {
    searchVal = json['searchVal'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    categoryType = json['class_category'];
    excludeType = json['exculde_degree_type'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchVal'] = this.searchVal;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['class_category'] = this.categoryType;
    data['exculde_degree_type'] = this.excludeType;
    return data;
  }
}



class AcademicDetailsSelectionListResponse {
  String? statusCode;
  String? message;
  List<AcademicDetailSelectionItem>? rows;
  int? total;

  AcademicDetailsSelectionListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  AcademicDetailsSelectionListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//AcademicDetailSelectionItem>();
      json['rows'].forEach((v) {
        rows!.add(new AcademicDetailSelectionItem.fromJson(v));
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

class AcademicDetailSelectionItem {
  String? subjectName;
  String? subjectCode;
  String? subjectDescription;
  int? subjectId;
  String? className;
  String? classCode;
  String? classDescription;
  int? classId;
  int? departmentId;
  String? departmentName;
  String? departmentCode;
  String? departmentDescription;
  String? programName;
  String? programCode;
  String? programDescription;
  int? programId;
  String? organizationName;
  String? organizationCode;
  String? organizationDescription;
  int? organizationId;
  bool? isSelected;

  AcademicDetailSelectionItem(
      {this.subjectName,
        this.subjectCode,
        this.subjectDescription,
        this.subjectId,
        this.className,
        this.classCode,
        this.classDescription,
        this.classId,
        this.departmentId,
        this.departmentName,
        this.departmentCode,
        this.departmentDescription,
        this.programName,
        this.programCode,
        this.programDescription,
        this.programId,
        this.organizationName,
        this.organizationCode,
        this.organizationDescription,
        this.isSelected,
        this.organizationId});

  AcademicDetailSelectionItem.fromJson(Map<String, dynamic> json) {
    subjectName = json['subject_name'];
    subjectCode = json['subject_code'];
    subjectDescription = json['subject_description'];
    subjectId = json['subject_id'];
    className = json['class_name'];
    classCode = json['class_code'];
    classDescription = json['class_description'];
    classId = json['class_id'];
    departmentId = json['department_id'];
    departmentName = json['department_name'];
    departmentCode = json['department_code'];
    departmentDescription = json['department_description'];
    programName = json['program_name'];
    programCode = json['program_code'];
    programDescription = json['program_description'];
    programId = json['program_id'];
    organizationName = json['organization_name'];
    organizationCode = json['organization_code'];
    organizationDescription = json['organization_description'];
    organizationId = json['organization_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject_name'] = this.subjectName;
    data['subject_code'] = this.subjectCode;
    data['subject_description'] = this.subjectDescription;
    data['subject_id'] = this.subjectId;
    data['class_name'] = this.className;
    data['class_code'] = this.classCode;
    data['class_description'] = this.classDescription;
    data['class_id'] = this.classId;
    data['department_id'] = this.departmentId;
    data['department_name'] = this.departmentName;
    data['department_code'] = this.departmentCode;
    data['department_description'] = this.departmentDescription;
    data['program_name'] = this.programName;
    data['program_code'] = this.programCode;
    data['program_description'] = this.programDescription;
    data['program_id'] = this.programId;
    data['organization_name'] = this.organizationName;
    data['organization_code'] = this.organizationCode;
    data['organization_description'] = this.organizationDescription;
    data['organization_id'] = this.organizationId;
    return data;
  }
}