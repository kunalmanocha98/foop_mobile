class ClassesAndSectionResponse {
  String statusCode;
  String message;
  List<ClassesWithSection> rows;
  int total;

  ClassesAndSectionResponse(
      {this.statusCode, this.message, this.rows, this.total});

  ClassesAndSectionResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ClassesWithSection>();
      json['rows'].forEach((v) {
        rows.add(new ClassesWithSection.fromJson(v));
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

class ClassesWithSection {
  int id;
  String className;
  String classCode;
  String classDescription;
  List<Sections> sections;
  List<Sections> sectionWithMore;
  bool isSelected=false;

  ClassesWithSection(
      {this.id,
        this.className,
        this.classCode,
        this.isSelected,
        this.sectionWithMore,
        this.classDescription,
        this.sections});

  ClassesWithSection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    className = json['class_name'];
    classCode = json['class_code'];
    classDescription = json['class_description'];
    if (json['sections'] != null) {
      sections = [];//Sections>();
      json['sections'].forEach((v) {
        sections.add(new Sections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_name'] = this.className;
    data['class_code'] = this.classCode;
    data['class_description'] = this.classDescription;
    if (this.sections != null) {
      data['sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sections {
  int id;
  bool isSelected=false;
  String sectionName;
  String sectionDescription;

  Sections({this.id, this.sectionName, this.sectionDescription,this.isSelected});

  Sections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sectionName = json['section_name'];
    sectionDescription = json['section_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['section_name'] = this.sectionName;
    data['section_description'] = this.sectionDescription;
    return data;
  }
}
