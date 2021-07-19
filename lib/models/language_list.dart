class LanguageList {
  String statusCode;
  String message;
  List<LanguageItem> rows;

  LanguageList({this.statusCode, this.message, this.rows});

  LanguageList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//LanguageItem>();
      json['rows'].forEach((v) {
        rows.add(new LanguageItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class EmailContactList {
  int id;
  String contactDetail;
  String countryCode;
  bool isPrimary;
  bool isVerified;

  EmailContactList(
      {this.id,
        this.contactDetail,
        this.countryCode,
        this.isPrimary,
        this.isVerified});

  EmailContactList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactDetail = json['contact_detail'];
    countryCode = json['country_code'];
    isPrimary = json['is_primary'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contact_detail'] = this.contactDetail;
    data['country_code'] = this.countryCode;
    data['is_primary'] = this.isPrimary;
    data['is_verified'] = this.isVerified;
    return data;
  }
}
class LanguageItem {
  int id;
  String languageCode;
  String isoCode;
  String languageName;
  String languageNameLocal;
  bool isSelected = false;

  LanguageItem(
      {this.id,
      this.languageCode,
      this.isoCode,
      this.languageName,
      this.languageNameLocal});

  LanguageItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageCode = json['language_code'];
    isoCode = json['iso_code'];
    isSelected = json['isSelected'];
    languageName = json['language_name'];
    languageNameLocal = json['language_name_local'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_code'] = this.languageCode;
    data['iso_code'] = this.isoCode;
    data['language_name'] = this.languageName;
    data['language_name_local'] = this.languageNameLocal;
    return data;
  }
}
class LanguageItemNew {
  int id;
  String languageCode;
  String isoCode;
  String languageName;
  String languageNameLocal;
  bool isSelected = false;

  LanguageItemNew(
      {this.id,
        this.languageCode,
        this.isoCode,
        this.languageName,
        this.languageNameLocal});

  LanguageItemNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageCode = json['code'];
    isoCode = json['iso_code'];
    isSelected = json['isSelected'];
    languageName = json['name'];
    languageNameLocal = json['language_name_local'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.languageCode;
    data['iso_code'] = this.isoCode;
    data['name'] = this.languageName;
    data['language_name_local'] = this.languageNameLocal;
    return data;
  }
}
