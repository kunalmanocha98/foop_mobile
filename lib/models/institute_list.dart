class InstituteList {
  String? statusCode;
  String? message;
  List<InstituteItem>? rows;

  InstituteList({this.statusCode, this.message, this.rows});

  InstituteList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(new InstituteItem.fromJson(v));
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

class InstituteItem {
  int? id;
  bool isLoading = false;
  bool isSelected = false;
  bool? isRegistered;
  bool? isValidated;
  String? accessCode;
  String? accessUrl;
  String? profileImage;
  String? personType;
  String? institutionType;
  String? code;
  String? description;
  String? name;
  String? shortName;
  String? mission;
  String? vision;
  String? institutionCategory;
  String? yearofEstablishment;
  int? establishmentYear;
  String? history;
  String? tagLine;
  String? quote;
  InstitutionAddress? institutionAddress;

  InstituteItem(
      {this.id,
      this.accessCode,
      this.accessUrl,
      this.institutionType,
      this.code,
      this.description,
      this.name,
        this.isValidated,
        this.isRegistered,
        this.profileImage,
        this.personType,
      this.shortName,
      this.mission,
      this.vision,
      this.institutionCategory,
      this.yearofEstablishment,
      this.establishmentYear,
      this.history,
      this.tagLine,
      this.quote,
      this.institutionAddress});

  InstituteItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isValidated=json['is_validated'];
    profileImage=json['profile_image'];
    personType = json['person_type'];
    accessCode = json['access_code'];
    isRegistered=json['is_registered'];
    accessUrl = json['access_url'];
    institutionType = json['institution_type'];
    code = json['code'];
    description = json['description'];
    name = json['name'];
    shortName = json['short_name'];
    mission = json['mission'];
    vision = json['vision'];
    institutionCategory = json['institution_category'];
    yearofEstablishment = json['yearof_establishment'];
    establishmentYear = json['establishment_year'];
    history = json['history'];
    tagLine = json['tag_line'];
    quote = json['quote'];
    institutionAddress = json['institution_address'] != null
        ? new InstitutionAddress.fromJson(json['institution_address'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_validated']=this.isValidated;
    data['profile_image']=this.profileImage;
    data['person_type'] = this.personType;
    data['is_registered']=this.isRegistered;
    data['access_code'] = this.accessCode;
    data['access_url'] = this.accessUrl;
    data['institution_type'] = this.institutionType;
    data['code'] = this.code;
    data['description'] = this.description;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['mission'] = this.mission;
    data['vision'] = this.vision;
    data['institution_category'] = this.institutionCategory;
    data['yearof_establishment'] = this.yearofEstablishment;
    data['establishment_year'] = this.establishmentYear;
    data['history'] = this.history;
    data['tag_line'] = this.tagLine;
    data['quote'] = this.quote;
    if (this.institutionAddress != null) {
      data['institution_address'] = this.institutionAddress!.toJson();
    }
    return data;
  }
}

class InstitutionAddress {
  int? id;
  String? country;
  String? postalCode;
  String? region;
  String? city;
  String? streetAddress;
  String? subRegion;
  bool? isPrimary;
  String? locality;
  String? longitude;
  String? latitude;
  String? elevation;
  String? addressType;

  InstitutionAddress(
      {this.id,
      this.country,
      this.postalCode,
      this.region,
      this.city,
      this.streetAddress,
      this.subRegion,
      this.isPrimary,
      this.locality,
      this.longitude,
      this.latitude,
      this.elevation,
      this.addressType});

  InstitutionAddress.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    postalCode = json['postal_code'];
    region = json['region'];
    city = json['city'];
    streetAddress = json['street_address'];
    subRegion = json['sub_region'];
    isPrimary = json['is_primary'];
    locality = json['locality'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    elevation = json['elevation'];
    addressType = json['address_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country'] = this.country;
    data['postal_code'] = this.postalCode;
    data['region'] = this.region;
    data['city'] = this.city;
    data['street_address'] = this.streetAddress;
    data['sub_region'] = this.subRegion;
    data['is_primary'] = this.isPrimary;
    data['locality'] = this.locality;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['elevation'] = this.elevation;
    data['address_type'] = this.addressType;
    return data;
  }
}
