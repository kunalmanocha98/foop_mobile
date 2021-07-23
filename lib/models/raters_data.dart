class RatersData {
  String? statusCode;
  String? message;
  List<RatersItem>? rows;
  int? total;

  RatersData({this.statusCode, this.message, this.rows, this.total});

  RatersData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//RatersItem>();
      json['rows'].forEach((v) {
        rows!.add(new RatersItem.fromJson(v));
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

class RatersItem {
  int? id;
  String? type;
  String? name;
  String? profileImage;
  String? subtitle;
  bool? isObjectFollowing;

  RatersItem(
      {this.id,
        this.type,
        this.name,
        this.profileImage,
        this.subtitle,
        this.isObjectFollowing});

  RatersItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    profileImage = json['profile_image'];
    subtitle = json['subtitle'];
    isObjectFollowing = json['is_object_following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['subtitle'] = this.subtitle;
    data['is_object_following'] = this.isObjectFollowing;
    return data;
  }
}
