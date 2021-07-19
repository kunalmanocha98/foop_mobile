class InviteUserPayload {
  String inviteContextType;
  int inviteContextTypeId;
  String invitedByType;
  int invitedById;
  Null invitationRecipientListUrl;
  List<InvitationRecipientList> invitationRecipientList;
  Null inviteExtraMessage;

  InviteUserPayload(
      {this.inviteContextType,
        this.inviteContextTypeId,
        this.invitedByType,
        this.invitedById,
        this.invitationRecipientListUrl,
        this.invitationRecipientList,
        this.inviteExtraMessage});

  InviteUserPayload.fromJson(Map<String, dynamic> json) {
    inviteContextType = json['invite_context_type'];
    inviteContextTypeId = json['invite_context_type_id'];
    invitedByType = json['invited_by_type'];
    invitedById = json['invited_by_id'];
    invitationRecipientListUrl = json['invitation_recipient_list_url'];
    if (json['invitation_recipient_list'] != null) {
      invitationRecipientList = [];
      json['invitation_recipient_list'].forEach((v) {
        invitationRecipientList.add(new InvitationRecipientList.fromJson(v));
      });
    }
    inviteExtraMessage = json['invite_extra_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invite_context_type'] = this.inviteContextType;
    data['invite_context_type_id'] = this.inviteContextTypeId;
    data['invited_by_type'] = this.invitedByType;
    data['invited_by_id'] = this.invitedById;
    data['invitation_recipient_list_url'] = this.invitationRecipientListUrl;
    if (this.invitationRecipientList != null) {
      data['invitation_recipient_list'] =
          this.invitationRecipientList.map((v) => v.toJson()).toList();
    }
    data['invite_extra_message'] = this.inviteExtraMessage;
    return data;
  }
}

class InvitationRecipientList {
  String name;
  String mobileNumber;
  String emailId;
  Null personId;

  InvitationRecipientList(
      {this.name, this.mobileNumber, this.emailId, this.personId});

  InvitationRecipientList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobileNumber = json['mobile_number'];
    emailId = json['email_id'];
    personId = json['person_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['email_id'] = this.emailId;
    data['person_id'] = this.personId;
    return data;
  }
}
