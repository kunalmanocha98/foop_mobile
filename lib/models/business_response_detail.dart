class BusinessDataResponse {
  String ?statusCode;
  String ?message;
  List<BusinessData>? rows;
  int? total;

  BusinessDataResponse({this.statusCode, this.message, this.rows, this.total});

  BusinessDataResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != String) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(new BusinessData.fromJson(v));
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

class BusinessData {
  int ?id;
  int? adminUserId;
  String ?businessType;
  String? code;
  String?description;
  String? name;
  String ?shortName;
  String? profile_image;
  String ?mission;
  String ?vision;
  String ?establishmentYear;
  String ?history;
  String ?tagLine;
  String ?quote;
  String ?businessCategory;
  bool ?isActive;
  String ?noOfEmployees;
  String ?businessAddressCountry;
  String ?businessAddressRegion;
  String? businessAddressStreetAddress;
  List<BusinessContacts> ?businessContacts;
  List<String>? businessOperatingHours;
  List<String> ?businessHolidays;
  List<BusinessDomains>? businessDomains;
  List<String>? businessCalendars;

  BusinessData(
      {this.id,
        this.adminUserId,
        this.businessType,
        this.code,
        this.profile_image,
        this.description,
        this.name,
        this.shortName,
        this.mission,
        this.vision,
        this.establishmentYear,
        this.history,
        this.tagLine,
        this.quote,
        this.businessCategory,
        this.isActive,
        this.noOfEmployees,
        this.businessAddressCountry,
        this.businessAddressRegion,
        this.businessAddressStreetAddress,
        this.businessContacts,
        this.businessOperatingHours,
        this.businessHolidays,
        this.businessDomains,
        this.businessCalendars});

  BusinessData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminUserId = json['admin_user_id'];
    profile_image=json['profile_image'];
    businessType = json['business_type'];
    code = json['code'];
    description = json['description'];
    name = json['name'];
    shortName = json['short_name'];
    mission = json['mission'];
    vision = json['vision'];
    establishmentYear = json['establishment_year'];
    history = json['history'];
    tagLine = json['tag_line'];
    quote = json['quote'];
    businessCategory = json['business_category'];
    isActive = json['is_active'];
    noOfEmployees = json['no_of_employees'];
    businessAddressCountry = json['business_address_country'];
    businessAddressRegion = json['business_address_region'];
    businessAddressStreetAddress = json['business_address_street_address'];
    if (json['business_contacts'] != String) {
      businessContacts = [];
      json['business_contacts'].forEach((v) {
        businessContacts!.add(new BusinessContacts.fromJson(v));
      });
    }
    if (json['business_operating_hours'] != String) {
      businessOperatingHours = [];
      json['business_operating_hours'].forEach((v) {
        businessOperatingHours!.add( v);
      });
    }
    if (json['business_holidays'] != String) {
      businessHolidays = [
        
      ];
      json['business_holidays'].forEach((v) {
        businessHolidays!.add(v);
      });
    }
    if (json['business_domains'] != String) {
      businessDomains = [];
      json['business_domains'].forEach((v) {
        businessDomains!.add(new BusinessDomains.fromJson(v));
      });
    }
    if (json['business_calendars'] != String) {
      businessCalendars = [];
      json['business_calendars'].forEach((v) {
        businessCalendars!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin_user_id'] = this.adminUserId;
    data['business_type'] = this.businessType;
    data['code'] = this.code;
    data['description'] = this.description;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['mission'] = this.mission;
    data['vision'] = this.vision;
    data['profile_image']=this.profile_image;
    data['establishment_year'] = this.establishmentYear;
    data['history'] = this.history;
    data['tag_line'] = this.tagLine;
    data['quote'] = this.quote;
    data['business_category'] = this.businessCategory;
    data['is_active'] = this.isActive;
    data['no_of_employees'] = this.noOfEmployees;
    data['business_address_country'] = this.businessAddressCountry;
    data['business_address_region'] = this.businessAddressRegion;
    data['business_address_street_address'] = this.businessAddressStreetAddress;
    if (this.businessContacts != String) {
      data['business_contacts'] =
          this.businessContacts!.map((v) => v.toJson()).toList();
    }
    if (this.businessOperatingHours != String) {
      data['business_operating_hours'] =
          this.businessOperatingHours!.map((v) => v).toList();
    }
    if (this.businessHolidays != String) {
      data['business_holidays'] =
          this.businessHolidays!.map((v) => v).toList();
    }
    if (this.businessDomains != String) {
      data['business_domains'] =
          this.businessDomains!.map((v) => v.toJson()).toList();
    }
    if (this.businessCalendars != String) {
      data['business_calendars'] =
          this.businessCalendars!.map((v) => v).toList();
    }
    return data;
  }
}

class BusinessContacts {
  int ?id;
  String? contactType;
  String ?contactInfo;

  BusinessContacts({this.id, this.contactType, this.contactInfo});

  BusinessContacts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactType = json['contact_type'];
    contactInfo = json['contact_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contact_type'] = this.contactType;
    data['contact_info'] = this.contactInfo;
    return data;
  }
}

class BusinessDomains {
  int? id;
  String ?domainName;

  BusinessDomains({this.id, this.domainName});

  BusinessDomains.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    domainName = json['domain_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['domain_name'] = this.domainName;
    return data;
  }
}
