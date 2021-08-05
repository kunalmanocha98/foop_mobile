class GlobalUserListResponse {
  String? statusCode;
  String? message;
  List<GlobalUserListItem>? rows;
  int? total;

  GlobalUserListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  GlobalUserListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(new GlobalUserListItem.fromJson(v));
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

class GlobalUserListItem {
  int? id;
  String? title;
  String? subtitle;
  String? avatar;
  String? email;

  GlobalUserListItem({this.id, this.title, this.subtitle, this.avatar, this.email});

  GlobalUserListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    subtitle = json['subtitle'];
    avatar = json['avatar'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    return data;
  }
}
