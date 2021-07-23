class FollowersFollowingCountEntity {
  String? statusCode;
  String? message;
  Rows? rows;

  FollowersFollowingCountEntity({this.statusCode, this.message, this.rows});

  FollowersFollowingCountEntity.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class Rows {
  int? followersCount;
  int? followingCount;
  int? roomsCount;
  int? cycleCount;
  int? postCount;

  Rows(
      {this.followersCount,
      this.followingCount,
      this.roomsCount,
      this.cycleCount,
      this.postCount});

  Rows.fromJson(Map<String, dynamic> json) {
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    roomsCount = json['rooms_count'];
    cycleCount = json['cycle_count'];
    postCount = json['post_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followers_count'] = this.followersCount;
    data['rooms_count'] = this.roomsCount;
    data['following_count'] = this.followingCount;
    data['cycle_count'] = this.cycleCount;
    data['post_count'] = this.postCount;
    return data;
  }
}
