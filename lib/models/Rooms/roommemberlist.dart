class RoomMemberListResponse {
  String statusCode;
  String message;
  List<RoomMemberListItem> rows;
  int total;

  RoomMemberListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  RoomMemberListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//RoomMemberListItem>();
      json['rows'].forEach((v) {
        rows.add(new RoomMemberListItem.fromJson(v));
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

class RoomMemberListItem {
  String memberType;
  int memberId;
  String memberRoleType;
  String membershipStatus;
  String firstName;
  String lastName;
  String profileImage;
  bool isFollower;
  bool isFollowing;
  String institutionRole;

  RoomMemberListItem(
      {this.memberType,
      this.memberId,
      this.memberRoleType,
      this.membershipStatus,
      this.firstName,
      this.lastName,
      this.profileImage,
      this.isFollower,
      this.isFollowing,
        this.institutionRole});

  RoomMemberListItem.fromJson(Map<String, dynamic> json) {
    memberType = json['member_type'];
    memberId = json['member_id'];
    memberRoleType = json['member_role_type'];
    membershipStatus = json['membership_status'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profileImage = json['profile_image'];
    isFollower = json['is_follower'];
    isFollowing = json['is_following'];
    institutionRole = json['institution_role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_type'] = this.memberType;
    data['member_id'] = this.memberId;
    data['member_role_type'] = this.memberRoleType;
    data['membership_status'] = this.membershipStatus;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_image'] = this.profileImage;
    data['is_follower'] = this.isFollower;
    data['is_following'] = this.isFollowing;
    data['institution_role'] = this.institutionRole;
    return data;
  }
}
