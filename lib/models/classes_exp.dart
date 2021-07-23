class ClassesExpertises {
  String? statusCode;
  String? message;
  List<ClassesItemsExpert>? rows;
  int? total;

  ClassesExpertises({this.statusCode, this.message, this.rows, this.total});

  ClassesExpertises.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ClassesItemsExpert>();
      json['rows'].forEach((v) {
        rows!.add(new ClassesItemsExpert.fromJson(v));
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

class ClassesItemsExpert {
  int? id;
  int? classId;
  String? className;
  String? classCode;
  bool? isSelected;
  String? section;
  String? isSelectedString;

  ClassesItemsExpert(
      {this.id, this.classId, this.className, this.classCode, this.isSelectedString, this.section,});

  ClassesItemsExpert.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'];
    className = json['class_name'];
    classCode = json['class_code'];
    section = json['section'];
    isSelectedString = json['is_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_id'] = this.classId;
    data['section'] = this.section;
    data['class_name'] = this.className;
    data['class_code'] = this.classCode;
    data['is_selected'] = this.isSelectedString;
    return data;
  }
}
