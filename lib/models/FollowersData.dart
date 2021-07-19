class FollowersData {
  String statusCode;
  String message;
  List<FollowersItem> rows;
  int total;

  FollowersData({this.statusCode, this.message, this.rows, this.total});

  FollowersData.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//FollowersItem>();
      json['rows'].forEach((v) {
        rows.add(new FollowersItem.fromJson(v));
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

class FollowersItem {
  int id;
  String name;
  String email;
  String imageUrl;
  String mobile;
  String slug;
  String url;
  bool isObjectFollowing;
  String listType;
String suggestedType;
  String startingOfSuggestion;
bool isSuggested;
String subtitle;
String institutionRole;
  FollowersItem(
      {this.id,
      this.name,
      this.email,
      this.imageUrl,
      this.mobile,
      this.slug,
      this.url,
        this.startingOfSuggestion,
        this.isSuggested,
        this.suggestedType,
      this.isObjectFollowing,
        this.subtitle,
        this.institutionRole,
      this.listType});

  FollowersItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    startingOfSuggestion=json['suggestion_start'];
    suggestedType=json['suggested_type'];
    imageUrl = json['image_url'];
    mobile = json['mobile'];
    slug = json['slug'];
    url = json['url'];
    isObjectFollowing = json['is_object_following'];
    listType = json['list_type'];
    subtitle = json['subtitle'];
    institutionRole = json['institution_role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['suggested_type']=this.suggestedType;
    data['name'] = this.name;
    data['suggestion_start']=this.startingOfSuggestion;
    data['email'] = this.email;
    data['image_url'] = this.imageUrl;
    data['mobile'] = this.mobile;
    data['slug'] = this.slug;
    data['url'] = this.url;
    data['is_object_following'] = this.isObjectFollowing;
    data['list_type'] = this.listType;
    data['subtitle'] = this.subtitle;
    data['institution_role'] = this.institutionRole;
    return data;
  }
}
