class States {
  String statusCode;
  String message;
  List<Rows> rows;
  int total;

  States({this.statusCode, this.message, this.rows, this.total});

  States.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows.add(new Rows.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Rows {
  int id;
  String country;
  Null createdByUserId;
  String createdDate;
  Null createdFromIp;
  String code;
  Null flagIconUrl;
  Null flagThumbnailUrl;
  Null flagUrl;
  String name;
  Null localLanguage;
  Null otherName;
  Null updatedByUserId;
  Null updatedFromIp;
  String updatedDate;

  Rows(
      {this.id,
        this.country,
        this.createdByUserId,
        this.createdDate,
        this.createdFromIp,
        this.code,
        this.flagIconUrl,
        this.flagThumbnailUrl,
        this.flagUrl,
        this.name,
        this.localLanguage,
        this.otherName,
        this.updatedByUserId,
        this.updatedFromIp,
        this.updatedDate});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    createdByUserId = json['created_by_user_id'];
    createdDate = json['created_date'];
    createdFromIp = json['created_from_ip'];
    code = json['code'];
    flagIconUrl = json['flag_icon_url'];
    flagThumbnailUrl = json['flag_thumbnail_url'];
    flagUrl = json['flag_url'];
    name = json['name'];
    localLanguage = json['local_language'];
    otherName = json['other_name'];
    updatedByUserId = json['updated_by_user_id'];
    updatedFromIp = json['updated_from_ip'];
    updatedDate = json['updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country'] = this.country;
    data['created_by_user_id'] = this.createdByUserId;
    data['created_date'] = this.createdDate;
    data['created_from_ip'] = this.createdFromIp;
    data['code'] = this.code;
    data['flag_icon_url'] = this.flagIconUrl;
    data['flag_thumbnail_url'] = this.flagThumbnailUrl;
    data['flag_url'] = this.flagUrl;
    data['name'] = this.name;
    data['local_language'] = this.localLanguage;
    data['other_name'] = this.otherName;
    data['updated_by_user_id'] = this.updatedByUserId;
    data['updated_from_ip'] = this.updatedFromIp;
    data['updated_date'] = this.updatedDate;
    return data;
  }
}
