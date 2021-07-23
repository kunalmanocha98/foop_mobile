class CreateRoomPayload {
  int? institutionId;
  String? roomCreatedByType;
  int? roomCreatedById;
  String? roomOwnerType;
  int? roomOwnerTypeId;
  String? roomName;
  String? roomDescription;
  bool? isPrivate;
  bool? isSharable;
  String? roomStatus;
  String? roomType;
  int? id;
  String? roomProfileImageUrl;
  String? roomPrivacyType;
  List<String?>? roomTopics;

  CreateRoomPayload(
      {this.institutionId,
      this.roomCreatedByType,
      this.roomCreatedById,
      this.roomOwnerType,
      this.roomOwnerTypeId,
      this.roomName,
      this.roomDescription,
      this.isPrivate,
      this.isSharable,
      this.roomStatus,
      this.roomType,
      this.id,
        this.roomPrivacyType, this.roomTopics,
      this.roomProfileImageUrl});

  CreateRoomPayload.fromJson(Map<String, dynamic> json) {
    institutionId = json['institution_id'];
    roomCreatedByType = json['room_created_by_type'];
    roomCreatedById = json['room_created_by_id'];
    roomOwnerType = json['room_owner_type'];
    roomOwnerTypeId = json['room_owner_type_id'];
    roomName = json['room_name'];
    roomDescription = json['room_description'];
    isPrivate = json['is_private'];
    isSharable = json['is_sharable'];
    roomStatus = json['room_status'];
    roomType = json['room_type'];
    id = json['id'];
    roomProfileImageUrl = json['room_profile_image_url'];
    roomPrivacyType = json['room_privacy_type'];
    roomTopics = json['room_topics'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['institution_id'] = this.institutionId;
    data['room_created_by_type'] = this.roomCreatedByType;
    data['room_created_by_id'] = this.roomCreatedById;
    data['room_owner_type'] = this.roomOwnerType;
    data['room_owner_type_id'] = this.roomOwnerTypeId;
    data['room_name'] = this.roomName;
    data['room_description'] = this.roomDescription;
    data['is_private'] = this.isPrivate;
    data['is_sharable'] = this.isSharable;
    data['room_status'] = this.roomStatus;
    data['room_type'] = this.roomType;
    data['id'] = this.id;
    data['room_profile_image_url'] = this.roomProfileImageUrl;
    data['room_privacy_type'] = this.roomPrivacyType;
    data['room_topics'] = this.roomTopics;
    return data;
  }
}
