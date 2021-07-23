class ProgramsData {
  String? statusCode;
  String? message;
  List<Programs>? rows;
  int? total;

  ProgramsData({this.statusCode, this.message, this.rows, this.total});

  ProgramsData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//Programs>();
      json['rows'].forEach((v) {
        rows!.add(new Programs.fromJson(v));
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

class Programs {
  int? id;
  String? programName;
  String? programCode;
  String? programDescription;
  bool? isSelected = false;
  Programs({this.id, this.programName, this.programCode, this.programDescription,this.isSelected});

  Programs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programName = json['program_name'];
    programCode = json['program_code'];
    isSelected=json["isSelected"];
    programDescription = json['program_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['program_name'] = this.programName;
    data['program_code'] = this.programCode;
    data['isSelected'] = this.isSelected;
    data['program_description'] = this.programDescription;
    return data;
  }
}
