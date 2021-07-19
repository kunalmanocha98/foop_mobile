class ClassesList {
  String statusCode;
  String message;
  List<Classes> rows;

  ClassesList({this.statusCode, this.message, this.rows});

  ClassesList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//Classes>();
      json['rows'].forEach((v) {
        rows.add(new Classes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Classes {
  int id;
  String className;
  String classDescription;
  String classCode;
  bool hasSections;
  bool isSelected = false;
  Null section;
  Null classMedium;
  Null classType;
  Null imageUrl;

  Classes(
      {this.id,
      this.className,
      this.classDescription,
      this.classCode,
      this.section,
      this.classMedium,
      this.classType,
      this.imageUrl,
      this.hasSections});

  Classes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    className = json['class_name'];
    classDescription = json['class_description'];
    classCode = json['class_code'];
    isSelected = json['isSelected'];
    hasSections = json['has_sections'];
    section = json['section'];
    classMedium = json['class_medium'];
    classType = json['class_type'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_name'] = this.className;
    data['class_description'] = this.classDescription;
    data['class_code'] = this.classCode;
    data['isSelected'] = this.isSelected;
    data['has_sections'] = this.hasSections;
    data['section'] = this.section;
    data['class_medium'] = this.classMedium;
    data['class_type'] = this.classType;
    data['image_url'] = this.imageUrl;
    return data;
  }
}
