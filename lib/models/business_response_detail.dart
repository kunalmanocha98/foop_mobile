class BusinessDetailResponse {
  String ?statusCode;
  String ?message;
  BusinessData? rows;
  int ?total;

  BusinessDetailResponse(
      {this.statusCode, this.message, this.rows, this.total});

  BusinessDetailResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new BusinessData.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != String) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class BusinessData {
  int? id;
  String? accessCode;
  String? accessUrl;
  String? businessType;
  String? code;
  String? description;
  String? name;
  String? slug;
  String ?shortName;
  String? profileImage;
  String ?coverImage;
  String ?mission;
  String ?vision;
  String?businessCategory;
  String? establishmentYear;
  String ?history;
  String ?tagLine;
  String ?quote;
  String ?fullUrl;

  BusinessData(
      {this.id,
        this.accessCode,
        this.accessUrl,
        this.businessType,
        this.code,
        this.description,
        this.name,
        this.slug,
        this.shortName,
        this.profileImage,
        this.coverImage,
        this.mission,
        this.vision,
        this.businessCategory,
        this.establishmentYear,
        this.history,
        this.tagLine,
        this.quote,
        this.fullUrl});

  BusinessData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessCode = json['access_code'];
    accessUrl = json['access_url'];
    businessType = json['business_type'];
    code = json['code'];
    description = json['description'];
    name = json['name'];
    slug = json['slug'];
    shortName = json['short_name'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    mission = json['mission'];
    vision = json['vision'];
    businessCategory = json['business_category'];
    establishmentYear = json['establishment_year'];
    history = json['history'];
    tagLine = json['tag_line'];
    quote = json['quote'];
    fullUrl = json['full_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['access_code'] = this.accessCode;
    data['access_url'] = this.accessUrl;
    data['business_type'] = this.businessType;
    data['code'] = this.code;
    data['description'] = this.description;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['short_name'] = this.shortName;
    data['profile_image'] = this.profileImage;
    data['cover_image'] = this.coverImage;
    data['mission'] = this.mission;
    data['vision'] = this.vision;
    data['business_category'] = this.businessCategory;
    data['establishment_year'] = this.establishmentYear;
    data['history'] = this.history;
    data['tag_line'] = this.tagLine;
    data['quote'] = this.quote;
    data['full_url'] = this.fullUrl;
    return data;
  }
}
