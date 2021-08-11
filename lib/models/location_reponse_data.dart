class LocationDetailsResponse {
  String? statusCode;
  String ?message;
  List<Rows>? rows;
  int? total;

  LocationDetailsResponse(
      {this.statusCode, this.message, this.rows, this.total});

  LocationDetailsResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != String) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != String) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Rows {
  int? id;
  String? addressType;
  int? businessId;
  String? country;
  String? createdByUserId;
  String ?createdDate;
  String? createdFromIp;
  String ?elevation;
  bool ?isPrimary;
  String? latitude;
  String? longitude;
  String ?locality;
  String ?postalCode;
  String ?region;
  String ?city;
  String ?streetAddress;
  String ?subRegion;
  String? updatedByUserId;
  String ?updatedFromIp;
  String ?updatedDate;

  Rows(
      {this.id,
        this.addressType,
        this.businessId,
        this.country,
        this.createdByUserId,
        this.createdDate,
        this.createdFromIp,
        this.elevation,
        this.isPrimary,
        this.latitude,
        this.longitude,
        this.locality,
        this.postalCode,
        this.region,
        this.city,
        this.streetAddress,
        this.subRegion,
        this.updatedByUserId,
        this.updatedFromIp,
        this.updatedDate});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressType = json['address_type'];
    businessId = json['business_id'];
    country = json['country'];
    createdByUserId = json['created_by_user_id'];
    createdDate = json['created_date'];
    createdFromIp = json['created_from_ip'];
    elevation = json['elevation'];
    isPrimary = json['is_primary'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    locality = json['locality'];
    postalCode = json['postal_code'];
    region = json['region'];
    city = json['city'];
    streetAddress = json['street_address'];
    subRegion = json['sub_region'];
    updatedByUserId = json['updated_by_user_id'];
    updatedFromIp = json['updated_from_ip'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address_type'] = this.addressType;
    data['business_id'] = this.businessId;
    data['country'] = this.country;
    data['created_by_user_id'] = this.createdByUserId;
    data['created_date'] = this.createdDate;
    data['created_from_ip'] = this.createdFromIp;
    data['elevation'] = this.elevation;
    data['is_primary'] = this.isPrimary;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['locality'] = this.locality;
    data['postal_code'] = this.postalCode;
    data['region'] = this.region;
    data['city'] = this.city;
    data['street_address'] = this.streetAddress;
    data['sub_region'] = this.subRegion;
    data['updated_by_user_id'] = this.updatedByUserId;
    data['updated_from_ip'] = this.updatedFromIp;
    data['updated_date'] = this.updatedDate;
    return data;
  }
}
