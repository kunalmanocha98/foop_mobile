class InstitutionDetail {
  String? statusCode;
  String? message;
  List<InstituteonData>? rows;

  InstitutionDetail({this.statusCode, this.message, this.rows});

  InstitutionDetail.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//InstituteonData>();
      json['rows'].forEach((v) {
        rows!.add(new InstituteonData.fromJson(v));
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

class InstituteonData {
  int? id;
  int? adminUserId;
  String? institutionType;
  Null code;
  String? description;
  String? name;
  Null shortName;
  String? mission;
  String? vision;
  int? establishmentYear;
  String? history;
  Null tagLine;
  String? quote;
  String? institutionCategory;
  bool? isActive;
  String? institutionAddressCountry;
  String? institutionAddressRegion;
  String? institutionAddressCity;
  String? institutionAddressStreetAddress;
  List<InstitutionContacts>? institutionContacts;
  List<InstitutionOperatingHours>? institutionOperatingHours;
  List<Null>? institutionHolidays;
  List<Null>? institutionCalendars;
  List<InstitutionMediums>? institutionMediums;

  InstituteonData(
      {this.id,
      this.adminUserId,
      this.institutionType,
      this.code,
      this.description,
      this.name,
      this.shortName,
      this.mission,
      this.vision,
      this.establishmentYear,
      this.history,
      this.tagLine,
      this.quote,
      this.institutionCategory,
      this.isActive,
      this.institutionAddressCountry,
      this.institutionAddressRegion,
      this.institutionAddressCity,
      this.institutionAddressStreetAddress,
      this.institutionContacts,
      this.institutionOperatingHours,
      this.institutionHolidays,
      this.institutionCalendars,
      this.institutionMediums});

  InstituteonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    adminUserId = json['admin_user_id'];
    institutionType = json['entity_type'];
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
    institutionCategory = json['institution_category'];
    isActive = json['is_active'];
    institutionAddressCountry = json['institution_address_country'];
    institutionAddressRegion = json['institution_address_region'];
    institutionAddressCity = json['institution_address_city'];
    institutionAddressStreetAddress =
        json['institution_address_street_address'];
    if (json['institution_contacts'] != null) {
      institutionContacts = [];//InstitutionContacts>();
      json['institution_contacts'].forEach((v) {
        institutionContacts!.add(new InstitutionContacts.fromJson(v));
      });
    }
    if (json['institution_operating_hours'] != null) {
      institutionOperatingHours = [];//InstitutionOperatingHours>();
      json['institution_operating_hours'].forEach((v) {
        institutionOperatingHours!
            .add(new InstitutionOperatingHours.fromJson(v));
      });
    }
    /* if (json['institution_holidays'] != null) {
      institutionHolidays = [];//Null>();
      json['institution_holidays'].forEach((v) {
        institutionHolidays.add(new Null.fromJson(v));
      });
    }*/
    /*if (json['institution_calendars'] != null) {
      institutionCalendars = [];//Null>();
      json['institution_calendars'].forEach((v) {
        institutionCalendars.add(new Null.fromJson(v));
      });
    }*/
    if (json['institution_mediums'] != null) {
      institutionMediums =  <InstitutionMediums>[];
      json['institution_mediums'].forEach((v) {
        institutionMediums!.add(new InstitutionMediums.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['admin_user_id'] = this.adminUserId;
    data['entity_type'] = this.institutionType;
    data['code'] = this.code;
    data['description'] = this.description;
    data['name'] = this.name;
    data['short_name'] = this.shortName;
    data['mission'] = this.mission;
    data['vision'] = this.vision;
    data['establishment_year'] = this.establishmentYear;
    data['history'] = this.history;
    data['tag_line'] = this.tagLine;
    data['quote'] = this.quote;
    data['institution_category'] = this.institutionCategory;
    data['is_active'] = this.isActive;
    data['institution_address_country'] = this.institutionAddressCountry;
    data['institution_address_region'] = this.institutionAddressRegion;
    data['institution_address_city'] = this.institutionAddressCity;
    data['institution_address_street_address'] =
        this.institutionAddressStreetAddress;
    if (this.institutionContacts != null) {
      data['institution_contacts'] =
          this.institutionContacts!.map((v) => v.toJson()).toList();
    }
    if (this.institutionOperatingHours != null) {
      data['institution_operating_hours'] =
          this.institutionOperatingHours!.map((v) => v.toJson()).toList();
    }
    /* if (this.institutionHolidays != null) {
      data['institution_holidays'] =
          this.institutionHolidays.map((v) => v.toJson()).toList();
    }
    if (this.institutionCalendars != null) {
      data['institution_calendars'] =
          this.institutionCalendars.map((v) => v.toJson()).toList();
    }*/
    if (this.institutionMediums != null) {
      data['institution_mediums'] =
          this.institutionMediums!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InstitutionContacts {
  String? contactType;
  String? contactInfo;

  InstitutionContacts({this.contactType, this.contactInfo});

  InstitutionContacts.fromJson(Map<String, dynamic> json) {
    contactType = json['contact_type'];
    contactInfo = json['contact_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact_type'] = this.contactType;
    data['contact_info'] = this.contactInfo;
    return data;
  }
}

class InstitutionOperatingHours {
  String? dayOfWeek;
  String? startingHours;
  String? closingHours;

  InstitutionOperatingHours(
      {this.dayOfWeek, this.startingHours, this.closingHours});

  InstitutionOperatingHours.fromJson(Map<String, dynamic> json) {
    dayOfWeek = json['day_of_week'];
    startingHours = json['starting_hours'];
    closingHours = json['closing_hours'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['day_of_week'] = this.dayOfWeek;
    data['starting_hours'] = this.startingHours;
    data['closing_hours'] = this.closingHours;
    return data;
  }
}

class InstitutionMediums {
  String? language;

  InstitutionMediums({this.language});

  InstitutionMediums.fromJson(Map<String, dynamic> json) {
    language = json['language'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    return data;
  }
}
