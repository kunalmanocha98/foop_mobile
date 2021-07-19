class MemberAddPayload {
  int roomId;
  int roomInstitutionId;
  bool isAddAllMembers;
  List<MembersItem> members;

  MemberAddPayload(
      {this.roomId,
      this.roomInstitutionId,
      this.isAddAllMembers,
      this.members});

  MemberAddPayload.fromJson(Map<String, dynamic> json) {
    roomId = json['room_id'];
    roomInstitutionId = json['room_institution_id'];
    isAddAllMembers = json['is_add_all_members'];
    if (json['members'] != null) {
      members = [];//MembersItem>();
      json['members'].forEach((v) {
        members.add(new MembersItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['room_id'] = this.roomId;
    data['room_institution_id'] = this.roomInstitutionId;
    data['is_add_all_members'] = this.isAddAllMembers;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MembersItem {
  int memberId;
  String memberType;
  String addMethod;
  String profileImage;
  String memberName;
  String roleType;

  MembersItem({this.memberId, this.memberType, this.addMethod,this.profileImage,this.memberName,this.roleType});

  MembersItem.fromJson(Map<String, dynamic> json) {
    memberId = json['member_id'];
    memberType = json['member_type'];
    addMethod = json['add_method'];
    roleType = json['role_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_id'] = this.memberId;
    data['member_type'] = this.memberType;
    data['add_method'] = this.addMethod;
    data['role_type'] = this.roleType;
    return data;
  }
}
