class ClassesAndSectionsData {
  String statusCode;
  String message;
  List<ClassesAndSections> rows;
  int total;
  ClassesAndSectionsData(
      {this.statusCode, this.message, this.rows, this.total});

  ClassesAndSectionsData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ClassesAndSections>();
      json['rows'].forEach((v) {
        rows.add(new ClassesAndSections.fromJson(v));
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

class ClassesAndSections {
  String sectionName;
  String sectionDescription;
  String className;
  String classCode;
  int isSelected;
  String classDescription;
  int classId;
  int sectionId;

  ClassesAndSections(
      {this.sectionName,
        this.sectionDescription,
        this.className,
        this.classCode,
        this.isSelected,
        this.classDescription,
        this.classId,
        this.sectionId});

  ClassesAndSections.fromJson(Map<String, dynamic> json) {
    sectionName = json['section_name'];
    isSelected = json['isSelected'];
    sectionDescription = json['section_description'];
    className = json['class_name'];
    classCode = json['class_code'];
    classDescription = json['class_description'];
    classId = json['class_id'];
    sectionId = json['section_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section_name'] = this.sectionName;
    data['isSelected'] = this.isSelected;
    data['section_description'] = this.sectionDescription;
    data['class_name'] = this.className;
    data['class_code'] = this.classCode;
    data['class_description'] = this.classDescription;
    data['class_id'] = this.classId;
    data['section_id'] = this.sectionId;
    return data;
  }
}
