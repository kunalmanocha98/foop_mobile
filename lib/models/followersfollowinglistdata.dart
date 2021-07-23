class FollowersListItemEntity {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;
  FollowersListItemEntity({this.statusCode, this.message, this.rows,  this.total,});

  FollowersListItemEntity.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total']=this.total;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class Rows {
  List<Persons>? persons;
  List<Null>? institutions;
  List<Null>? classes;
  List<Null>? sections;

  Rows({this.persons, this.institutions, this.classes, this.sections});

  Rows.fromJson(Map<String, dynamic> json) {
    if (json['persons'] != null) {
      persons = [];//Persons>();
      json['persons'].forEach((v) {
        persons!.add(new Persons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.persons != null) {
      data['persons'] = this.persons!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Persons {
  int? id;
  String? name;
  String? email;
  String? imageUrl;
  String? mobile;
  String? slug;

  bool? isObjectFollowing;

  Persons(
      {this.name,
      this.email,
      this.imageUrl,
      this.mobile,
      this.slug,
      this.id,
      this.isObjectFollowing});

  Persons.fromJson(Map<String, dynamic> json) {
    isObjectFollowing = json['is_object_following'];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    imageUrl = json['image_url'];
    mobile = json['mobile'];
    slug = json['slug'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_object_following'] = this.isObjectFollowing;
    data['name'] = this.name;
    data['email'] = this.email;
    data['image_url'] = this.imageUrl;
    data['mobile'] = this.mobile;
    data['slug'] = this.slug;
    return data;
  }
}
