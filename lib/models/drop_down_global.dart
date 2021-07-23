class DropDownCommon {
  String? statusCode;
  String? message;
  List<DropDownItem>? rows;
  int? total;

  DropDownCommon({this.statusCode, this.message, this.rows, this.total});

  DropDownCommon.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//DropDownItem>();
      json['rows'].forEach((v) {
        rows!.add(new DropDownItem.fromJson(v));
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

class DropDownItem {
  int? id;
  int? facilityTypeId;
  String? code;
  String? description;
  int? dictionaryType;

  DropDownItem({this.id, this.code, this.description, this.dictionaryType});

  DropDownItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    facilityTypeId=json['facility_type_id'];
    code = json['code'];
    description = json['description'];
    dictionaryType = json['dictionary_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['facility_type_id']=this.facilityTypeId;
    data['description'] = this.description;
    data['dictionary_type'] = this.dictionaryType;
    return data;
  }
}
