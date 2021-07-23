class Facilitiestype {
  String? statusCode;
  String? message;
  List<Rows>? rows;

  Facilitiestype({this.statusCode, this.message, this.rows});

  Facilitiestype.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
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

class Rows {
  String? name;
  String? code;
  String? description;
  int? facilityTypeId;

  Rows({this.name, this.code, this.description, this.facilityTypeId});

  Rows.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    description = json['description'];
    facilityTypeId = json['facility_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['facility_type_id'] = this.facilityTypeId;
    return data;
  }
}
