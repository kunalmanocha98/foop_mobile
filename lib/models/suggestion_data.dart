class SuggestionData {
  String? statusCode;
  String? message;
  List<Rows>? rows;
  int? total;

  SuggestionData({this.statusCode, this.message, this.rows, this.total});

  SuggestionData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
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

class Rows {
  int? id;
  String? title;
  String? subtitle;
  String? avatar;
  bool? isFollowed;

  Rows({this.id, this.title, this.subtitle, this.avatar, this.isFollowed});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    avatar = json['avatar'];
    isFollowed = json['is_followed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['avatar'] = this.avatar;
    data['is_followed'] = this.isFollowed;
    return data;
  }
}
