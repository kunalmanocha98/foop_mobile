



import 'language_list.dart';

class AccountSettingUpdateResponse {
  String statusCode;
  String message;
  AccountSettingUpdateRequest rows;

  AccountSettingUpdateResponse({this.statusCode, this.message, this.rows});

  AccountSettingUpdateResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new AccountSettingUpdateRequest.fromJson(json['rows'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    return data;
  }
}

class AccountSettingUpdateRequest {
  int id;
  int institutionId;
  int personId;
  String academicDateStart;
  String academicDateEnd;
  LanguageItemNew transLateLanguage;
  int languageId;

  List<int> contentLanguageIds;
  String dateFormat;
  String timeFormat;
  int currencyId;

  AccountSettingUpdateRequest(
      {this.id,
      this.institutionId,
      this.personId,
      this.academicDateStart,
      this.academicDateEnd,
      this.languageId,
        this.transLateLanguage,
      this.contentLanguageIds,
      this.dateFormat,
      this.timeFormat,
      this.currencyId});

  AccountSettingUpdateRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transLateLanguage=json['translate_language'];
    institutionId = json['institution_id'];
    personId = json['person_id'];
    academicDateStart = json['academic_date_start'];
    academicDateEnd = json['academic_date_end'];
    languageId = json['language_id'];
    contentLanguageIds = json['content_language_ids'].cast<int>();
    dateFormat = json['date_format'];
    timeFormat = json['time_format'];
    currencyId = json['currency_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['translate_language']=this.transLateLanguage;
    data['institution_id'] = this.institutionId;
    data['person_id'] = this.personId;
    data['academic_date_start'] = this.academicDateStart;
    data['academic_date_end'] = this.academicDateEnd;
    data['language_id'] = this.languageId;
    data['content_language_ids'] = this.contentLanguageIds;
    data['date_format'] = this.dateFormat;
    data['time_format'] = this.timeFormat;
    data['currency_id'] = this.currencyId;
    return data;
  }
}

class PrivacySettingUpdateResponse {
  String statusCode;
  String message;
  PrivacySettingUpdateRequest rows;

  PrivacySettingUpdateResponse({this.statusCode, this.message, this.rows});

  PrivacySettingUpdateResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new PrivacySettingUpdateRequest.fromJson(json['rows'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    return data;
  }
}

class PrivacySettingUpdateRequest {
  int id;
  int institutionId;
  int personId;
  String networkType;
  List<String> postVisibleTo;
  List<String> postBy;
  List<String> goalsObjectiviesVisibleTo;
  List<String> ratingVisibleTo;
  List<String> ratingBy;
  List<String> profileVisibleTo;

  PrivacySettingUpdateRequest(
      {this.id,
      this.institutionId,
      this.personId,
      this.networkType,
      this.postVisibleTo,
      this.postBy,
      this.profileVisibleTo,
      this.goalsObjectiviesVisibleTo,
      this.ratingVisibleTo,
      this.ratingBy});

  PrivacySettingUpdateRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileVisibleTo = json['profile_visible_to'];
    institutionId = json['institution_id'];
    personId = json['person_id'];
    networkType = json['network_type'];
    postVisibleTo = json['post_visible_to'].cast<String>();
    postBy = json['post_by'].cast<String>();
    goalsObjectiviesVisibleTo =
        json['goals_objectivies_visible_to'].cast<String>();
    ratingVisibleTo = json['rating_visible_to'].cast<String>();
    ratingBy = json['rating_by'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_visible_to'] = this.profileVisibleTo;
    data['institution_id'] = this.institutionId;
    data['person_id'] = this.personId;
    data['network_type'] = this.networkType;
    data['post_visible_to'] = this.postVisibleTo;
    data['post_by'] = this.postBy;
    data['goals_objectivies_visible_to'] = this.goalsObjectiviesVisibleTo;
    data['rating_visible_to'] = this.ratingVisibleTo;
    data['rating_by'] = this.ratingBy;
    return data;
  }
}
