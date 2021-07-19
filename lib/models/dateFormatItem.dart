class DateFormat {
  String statusCode;
  String message;
  List<DateFormatItem> rows;

  DateFormat({this.statusCode, this.message, this.rows});

  DateFormat.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//DateFormatItem>();
      json['rows'].forEach((v) {
        rows.add(new DateFormatItem.fromJson(v));
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

class DateFormatItem {
  int id;
  String code;
  String format;
  bool isSelected = false;

  DateFormatItem({this.id, this.code, this.format});

  DateFormatItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    format = json['format'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['format'] = this.format;
    return data;
  }
}
