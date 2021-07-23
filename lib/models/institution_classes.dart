class InstitutionClasses {
  String? statusCode;
  String? message;
  List<InstituteClass>? rows;

  InstitutionClasses({this.statusCode, this.message, this.rows});

  InstitutionClasses.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(new InstituteClass.fromJson(v));
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

class InstituteClass {
  int? id;
  int? classId;
  String? className;
  String? classCode;
  String? classDescription;
  Course? course;
  Department? department;
  Program? program;
  ClassType? classType;
  Null imageUrl;
  String? section;
  String? roomNumber;
  String? floorNumber;
  String? building;
  int? studentsCapacity;
  bool? isSelected = false;

  InstituteClass(
      {this.id,
        this.classId,
      this.className,
      this.classCode,
      this.classDescription,
      this.course,
      this.department,
      this.program,
      this.classType,
      this.imageUrl,
      this.section,
      this.roomNumber,
      this.floorNumber,
      this.building,
      this.studentsCapacity});

  InstituteClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    className = json['class_name'];
    classCode = json['class_code'];
    isSelected = json['isSelected'];
    classDescription = json['class_description'];
    course =
        json['course'] != null ? new Course.fromJson(json['course']) : null;
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    program =
        json['program'] != null ? new Program.fromJson(json['program']) : null;
    classType = json['class_type'] != null
        ? new ClassType.fromJson(json['class_type'])
        : null;
    imageUrl = json['image_url'];
    section = json['section'];
    roomNumber = json['room_number'];
    floorNumber = json['floor_number'];
    building = json['building'];
    studentsCapacity = json['students_capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_id'] = this.classId;
    data['class_name'] = this.className;
    data['class_code'] = this.classCode;
    data['class_description'] = this.classDescription;
    if (this.course != null) {
      data['course'] = this.course!.toJson();
    }
    if (this.department != null) {
      data['department'] = this.department!.toJson();
    }
    if (this.program != null) {
      data['program'] = this.program!.toJson();
    }
    if (this.classType != null) {
      data['class_type'] = this.classType!.toJson();
    }
    data['image_url'] = this.imageUrl;
    data['section'] = this.section;
    data['room_number'] = this.roomNumber;
    data['floor_number'] = this.floorNumber;
    data['building'] = this.building;
    data['isSelected'] = this.isSelected;
    data['students_capacity'] = this.studentsCapacity;
    return data;
  }
}

class Course {
  int? id;
  String? courseName;
  String? courseCode;

  Course({this.id, this.courseName, this.courseCode});

  Course.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    courseName = json['course_name'];
    courseCode = json['course_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course_name'] = this.courseName;
    data['course_code'] = this.courseCode;
    return data;
  }
}

class Department {
  int? id;
  String? departmentName;
  String? departmentCode;

  Department({this.id, this.departmentName, this.departmentCode});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentName = json['department_name'];
    departmentCode = json['department_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department_name'] = this.departmentName;
    data['department_code'] = this.departmentCode;
    return data;
  }
}

class Program {
  int? id;
  String? programName;
  String? programCode;

  Program({this.id, this.programName, this.programCode});

  Program.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programName = json['program_name'];
    programCode = json['program_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['program_name'] = this.programName;
    data['program_code'] = this.programCode;
    return data;
  }
}

class ClassType {
  int? id;
  String? classTypeName;
  String? classTypeCode;

  ClassType({this.id, this.classTypeName, this.classTypeCode});

  ClassType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classTypeName = json['class_type_name'];
    classTypeCode = json['class_type_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_type_name'] = this.classTypeName;
    data['class_type_code'] = this.classTypeCode;
    return data;
  }
}
