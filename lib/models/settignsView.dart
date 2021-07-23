import 'package:oho_works_app/models/disctionarylist.dart';
import 'package:oho_works_app/models/language_list.dart';

class SettingsView {
  String? statusCode;
  String? message;
  Rows? rows;

  SettingsView({this.statusCode, this.message, this.rows});

  SettingsView.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class Rows {
  int? id;
  int? institutionsId;
  int? personsId;
  String? academicDateStart;
  String? academicDateEnd;
  String? dateFormat;
  String? timeFormat;
  LanguageItem? language;
  TranslateLanguage? transLateLanguage;
  List<LanguageItem>? contentLanguage;
  Currency? currency;
  List<EmailContactList>? emailContactList;
  List<EmailContactList>? mobileContactList;

  Rows(
      {this.id,
      this.institutionsId,
      this.personsId,
      this.academicDateStart,
      this.academicDateEnd,
      this.dateFormat,
      this.timeFormat,
      this.language,
      this.transLateLanguage,
      this.contentLanguage,
      this.emailContactList,
      this.mobileContactList,
      this.currency});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionsId = json['institutions_id'];
    personsId = json['persons_id'];
    academicDateStart = json['academic_date_start'];
    academicDateEnd = json['academic_date_end'];
    dateFormat = json['date_format'];
    timeFormat = json['time_format'];
    language = json['language'] != null
        ? new LanguageItem.fromJson(json['language'])
        : null;


    transLateLanguage = json['translate_language'] != null
        ? new TranslateLanguage.fromJson(json['translate_language'])
        : null;
    if (json['content_language'] != null) {
      contentLanguage = [];//LanguageItem>();
      json['content_language'].forEach((v) {
        contentLanguage!.add(new LanguageItem.fromJson(v));
      });
    }
    currency = json['currency'] != null
        ? new Currency.fromJson(json['currency'])
        : null;
    if (json['email_contact_list'] != null) {
      emailContactList = [];//EmailContactList>();
      json['email_contact_list'].forEach((v) {
        emailContactList!.add(new EmailContactList.fromJson(v));
      });
    }
    if (json['mobile_contact_list'] != null) {
      mobileContactList = [];//EmailContactList>();
      json['mobile_contact_list'].forEach((v) {
        mobileContactList!.add(new EmailContactList.fromJson(v));
      });
    }
  }






  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['institutions_id'] = this.institutionsId;
    data['persons_id'] = this.personsId;
    data['academic_date_start'] = this.academicDateStart;
    data['academic_date_end'] = this.academicDateEnd;
    data['date_format'] = this.dateFormat;
    data['time_format'] = this.timeFormat;
    if (this.language != null) {
      data['language'] = this.language!.toJson();
    }
    if (this.transLateLanguage != null) {
      data['translate_language'] = this.transLateLanguage!.toJson();
    }

    if (this.contentLanguage != null) {
      data['content_language'] =
          this.contentLanguage!.map((v) => v.toJson()).toList();
    }
    if (this.currency != null) {
      data['currency'] = this.currency!.toJson();
    }
    if (this.emailContactList != null) {
      data['email_contact_list'] =
          this.emailContactList!.map((v) => v.toJson()).toList();
    }
    if (this.mobileContactList != null) {
      data['mobile_contact_list'] =
          this.mobileContactList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class TranslateLanguage {
  int? id;
  String? code;
  String? name;
  int? isoCode;
  String? languageNameLocal;

  TranslateLanguage(
      {this.id, this.code, this.name, this.isoCode, this.languageNameLocal});

  TranslateLanguage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    isoCode = json['iso_code'];
    languageNameLocal = json['language_name_local'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['iso_code'] = this.isoCode;
    data['language_name_local'] = this.languageNameLocal;
    return data;
  }
}
class Currency {
  int? id;
  String? code;
  String? name;
  String? symbol;

  Currency({this.id, this.code, this.name, this.symbol});

  Currency.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    return data;
  }
}

class PrivacySettingsView {
  String? statusCode;
  String? message;
  PrivacySettingsResposne? rows;

  PrivacySettingsView({this.statusCode, this.message, this.rows});

  PrivacySettingsView.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new PrivacySettingsResposne.fromJson(json['rows'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class PrivacySettingsResposne {
  int? id;
  int? institutionsId;
  int? personsId;
  List<DictionaryListItem>? goalsObjectiviesVisibleTo;
  List<DictionaryListItem>? ratingVisibleTo;
  List<DictionaryListItem>? ratingBy;
  DictionaryListItem? networkType;
  List<DictionaryListItem>? postVisibleTo;
  List<DictionaryListItem>? postBy;
  List<DictionaryListItem>? profileVisibleTo;

  PrivacySettingsResposne(
      {this.id,
      this.institutionsId,
      this.personsId,
      this.goalsObjectiviesVisibleTo,
      this.ratingVisibleTo,
      this.ratingBy,
      this.networkType,
      this.postVisibleTo,
      this.profileVisibleTo,
      this.postBy});

  PrivacySettingsResposne.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    institutionsId = json['institutions_id'];
    personsId = json['persons_id'];
    if (json['goals_objectivies_visible_to'] != null) {
      goalsObjectiviesVisibleTo = [];//DictionaryListItem>();
      json['goals_objectivies_visible_to'].forEach((v) {
        goalsObjectiviesVisibleTo!.add(new DictionaryListItem.fromJson(v));
      });
    }
    if (json['rating_visible_to'] != null) {
      ratingVisibleTo = [];//DictionaryListItem>();
      json['rating_visible_to'].forEach((v) {
        ratingVisibleTo!.add(new DictionaryListItem.fromJson(v));
      });
    }
    if (json['rating_by'] != null) {
      ratingBy = [];//DictionaryListItem>();
      json['rating_by'].forEach((v) {
        ratingBy!.add(new DictionaryListItem.fromJson(v));
      });
    }

    if (json['profile_visible_to'] != null) {
      profileVisibleTo = [];//DictionaryListItem>();
      json['profile_visible_to'].forEach((v) {
        profileVisibleTo!.add(new DictionaryListItem.fromJson(v));
      });
    }

    networkType = json['network_type'] != null
        ? new DictionaryListItem.fromJson(json['network_type'])
        : null;
    if (json['post_visible_to'] != null) {
      postVisibleTo = [];//DictionaryListItem>();
      json['post_visible_to'].forEach((v) {
        postVisibleTo!.add(new DictionaryListItem.fromJson(v));
      });
    }
    if (json['post_by'] != null) {
      postBy = [];//DictionaryListItem>();
      json['post_by'].forEach((v) {
        postBy!.add(new DictionaryListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['institutions_id'] = this.institutionsId;
    data['persons_id'] = this.personsId;
    if (this.goalsObjectiviesVisibleTo != null) {
      data['goals_objectivies_visible_to'] =
          this.goalsObjectiviesVisibleTo!.map((v) => v.toJson()).toList();
    }
    if (this.ratingVisibleTo != null) {
      data['rating_visible_to'] =
          this.ratingVisibleTo!.map((v) => v.toJson()).toList();
    }
    if (this.ratingBy != null) {
      data['rating_by'] = this.ratingBy!.map((v) => v.toJson()).toList();
    }
    if (this.profileVisibleTo != null) {
      data['profile_visible_to'] =
          this.ratingBy!.map((v) => v.toJson()).toList();
    }
    if (this.networkType != null) {
      data['network_type'] = this.networkType!.toJson();
    }
    if (this.postVisibleTo != null) {
      data['post_visible_to'] =
          this.postVisibleTo!.map((v) => v.toJson()).toList();
    }
    if (this.postBy != null) {
      data['post_by'] = this.postBy!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
