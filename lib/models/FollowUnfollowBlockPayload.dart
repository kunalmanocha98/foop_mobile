class FollowUnfollowBlockPayload {
  String actionByObjectType;
  int actionByObjectId;
  String actionOnObjectType;
  int actionOnObjectId;
  String engageFlag;
  String actionDetails;

  FollowUnfollowBlockPayload(
      {this.actionByObjectType,
      this.actionByObjectId,
      this.actionOnObjectType,
      this.actionOnObjectId,
      this.engageFlag,
      this.actionDetails});

  FollowUnfollowBlockPayload.fromJson(Map<String, dynamic> json) {
    actionByObjectType = json['action_by_object_type'];
    actionByObjectId = json['action_by_object_id'];
    actionOnObjectType = json['action_on_object_type'];
    actionOnObjectId = json['action_on_object_id'];
    engageFlag = json['engage_flag'];
    actionDetails = json['action_details'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['action_by_object_type'] = this.actionByObjectType;
    data['action_by_object_id'] = this.actionByObjectId;
    data['action_on_object_type'] = this.actionOnObjectType;
    data['action_on_object_id'] = this.actionOnObjectId;
    data['engage_flag'] = this.engageFlag;
    data['action_details'] = this.actionDetails;
    return data;
  }
}
