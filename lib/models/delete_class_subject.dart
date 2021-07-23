class DeleteClassSubjectPayload {
  String? id;
  String? personId;
  String? institutionId;
  String? actionType;

  DeleteClassSubjectPayload(
      {this.id, this.personId, this.institutionId, this.actionType});

  DeleteClassSubjectPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    institutionId = json['institution_id'];
    actionType = json['action_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['person_id'] = this.personId;
    data['institution_id'] = this.institutionId;
    data['action_type'] = this.actionType;
    return data;
  }
}
