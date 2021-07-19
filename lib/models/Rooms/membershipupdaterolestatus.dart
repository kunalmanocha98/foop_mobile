class MembershipRoleStatusPayload {
  int memberId;
  String memberType;
  int roomId;
  String action;
  bool isAdmin;

  MembershipRoleStatusPayload(
      {this.memberId, this.memberType, this.roomId, this.action, this.isAdmin});

  MembershipRoleStatusPayload.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    memberType = json['member_type'];
    roomId = json['room_id'];
    action = json['action'];
    isAdmin = json['is_admin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['member_type'] = this.memberType;
    data['room_id'] = this.roomId;
    data['action'] = this.action;
    data['is_admin'] = this.isAdmin;
    return data;
  }
}
