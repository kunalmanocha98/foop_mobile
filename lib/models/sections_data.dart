class SectionData {
  String statusCode;
  String message;
  List<Rows> rows;
  int total;

  SectionData({this.statusCode, this.message, this.rows, this.total});

  SectionData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
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

class Rows {
  int id;
  String sectionName;
  String sectionDescription;
bool isSelected=false;
  Rows({this.id, this.sectionName, this.sectionDescription});

  Rows.fromJson(Map<String, dynamic> json) {
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
