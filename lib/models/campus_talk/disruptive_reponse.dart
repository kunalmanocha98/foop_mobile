class InviteDisruptiveUser {
  String? name;
  String? profileImage;
  String? personType;
  String? role;
  String? participantType;
  int? participantId;
  String? notification;
  List<Actions>? actions;

  InviteDisruptiveUser(
      {this.name,
        this.profileImage,
        this.personType,
        this.role,
        this.participantType,
        this.participantId,
        this.notification,
        this.actions});

  InviteDisruptiveUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profile_image'];
    personType = json['person_type'];
    role = json['role'];
    participantType = json['participant_type'];
    participantId = json['participant_id'];
    notification = json['notification'];
    if (json['actions'] != null) {
      actions = [];//Actions>();
      json['actions'].forEach((v) {
        actions!.add(new Actions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['person_type'] = this.personType;
    data['role'] = this.role;
    data['participant_type'] = this.participantType;
    data['participant_id'] = this.participantId;
    data['notification'] = this.notification;
    if (this.actions != null) {
      data['actions'] = this.actions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Actions {
  String? actionCode;
  String? actionText;

  Actions({this.actionCode, this.actionText});

  Actions.fromJson(Map<String, dynamic> json) {
    actionCode = json['action_code'];
    actionText = json['action_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_code'] = this.actionCode;
    data['action_text'] = this.actionText;
    return data;
  }
}
