class ProgramsData {
  String? statusCode;
  String? message;
  List<ProgramDataItem>? rows;
  int? total;

  ProgramsData({this.statusCode, this.message, this.rows, this.total});

  ProgramsData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ProgramDataItem>();
      json['rows'].forEach((v) {
        rows!.add(new ProgramDataItem.fromJson(v));
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

class ProgramDataItem {
  String? degreeType;
  List<Programs>? programs;

  ProgramDataItem({this.degreeType, this.programs});

  ProgramDataItem.fromJson(Map<String, dynamic> json) {
    degreeType = json['degree_type'];
    if (json['programs'] != null) {
      programs = [];//Programs>();
      json['programs'].forEach((v) {
        programs!.add(new Programs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['degree_type'] = this.degreeType;
    if (this.programs != null) {
      data['programs'] = this.programs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Programs {
  int? id;
  String? degreeType;
  String? programName;
  String? programCode;
  String? programDescription;
  bool? isSelected = false;

  Programs(
      {this.id,
      this.programName,
      this.programCode,
      this.programDescription,
      this.isSelected,
      this.degreeType});

  Programs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    programName = json['program_name'];
    programCode = json['program_code'];
    programDescription = json['program_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['program_name'] = this.programName;
    data['program_code'] = this.programCode;
    data['program_description'] = this.programDescription;
    return data;
  }
}
