class AccedemicList {
  String? statusCode;
  String? message;
  List<AccedemicItem>? rows;
  int? total;

  AccedemicList({this.statusCode, this.message, this.rows, this.total});

  AccedemicList.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//AccedemicItem>();
      json['rows'].forEach((v) {
        rows!.add(new AccedemicItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class AccedemicItem {
  int? id;
  int? type;
  String? yearName;
  String? dateStart;
  String? dateEnd;
  bool? isSelected;

  AccedemicItem(
      {this.id,
      this.type,
      this.yearName,
      this.dateStart,
      this.dateEnd,
      this.isSelected});

  AccedemicItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    yearName = json['year_name'];
    dateStart = json['date_start'];
    dateEnd = json['date_end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['year_name'] = this.yearName;
    data['date_start'] = this.dateStart;
    data['date_end'] = this.dateEnd;
    return data;
  }
}
