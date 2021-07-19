class BlankResponse {
  String statusCode;
  String message;
  Rows rows;
  int total;

  BlankResponse({this.statusCode, this.message, this.rows, this.total});

  BlankResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Rows {
  String facilityName;
  String facilityCode;
  String facilityDescription;
  String imageUrl;
  int facilityTypeId;
  int id;

  Rows(
      {this.facilityName,
        this.facilityCode,
        this.facilityDescription,
        this.imageUrl,
        this.facilityTypeId,
        this.id});

  Rows.fromJson(Map<String, dynamic> json) {
    facilityName = json['facility_name'];
    facilityCode = json['facility_code'];
    facilityDescription = json['facility_description'];
    imageUrl = json['image_url'];
    facilityTypeId = json['facility_type_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facility_name'] = this.facilityName;
    data['facility_code'] = this.facilityCode;
    data['facility_description'] = this.facilityDescription;
    data['image_url'] = this.imageUrl;
    data['facility_type_id'] = this.facilityTypeId;
    data['id'] = this.id;
    return data;
  }
}
