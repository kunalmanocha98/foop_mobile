class CountryCodeResponse {
  String statusCode;
  String message;
  List<ContruCodeItem> rows;
  int total;

  CountryCodeResponse({this.statusCode, this.message, this.rows, this.total});

  CountryCodeResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//ContruCodeItem>();
      json['rows'].forEach((v) {
        rows.add(new ContruCodeItem.fromJson(v));
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

class ContruCodeItem {
  String code;
  String flagIconUrl;
  String flagThumbnailUrl;
  Null flagUrl;
  int isdCode;
  String name;
  String localLanguage;
  String dialCode;

  ContruCodeItem(
      {this.code,
        this.flagIconUrl,
        this.flagThumbnailUrl,
        this.flagUrl,
        this.isdCode,
        this.name,
        this.localLanguage,
        this.dialCode});

  ContruCodeItem.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    flagIconUrl = json['flag_icon_url'];
    flagThumbnailUrl = json['flag_thumbnail_url'];
    flagUrl = json['flag_url'];
    isdCode = json['isd_code'];
    name = json['name'];
    localLanguage = json['local_language'];
    dialCode = json['dial_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['flag_icon_url'] = this.flagIconUrl;
    data['flag_thumbnail_url'] = this.flagThumbnailUrl;
    data['flag_url'] = this.flagUrl;
    data['isd_code'] = this.isdCode;
    data['name'] = this.name;
    data['local_language'] = this.localLanguage;
    data['dial_code'] = this.dialCode;
    return data;
  }
}
