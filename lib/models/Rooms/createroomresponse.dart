class CreateRoomResponse {
  String? statusCode;
  String? message;
  CreateRoomModel? rows;

  CreateRoomResponse({this.statusCode, this.message, this.rows});

  CreateRoomResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null
        ? new CreateRoomModel.fromJson(json['rows'])
        : null;
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

class CreateRoomModel {
  int? institutionId;
  String? roomCreatedByType;
  int? roomCreatedById;
  String? roomOwnerType;
  int? roomOwnerTypeId;
  String? roomName;
  String? roomDescription;
  bool? isPrivate;
  bool? isSharable;
  String? roomType;
  String? roomStatus;
  int? id;
  String? institutionName;
  int? institutionMembersCount;

  CreateRoomModel(
      {this.institutionId,
      this.roomCreatedByType,
      this.roomCreatedById,
      this.roomOwnerType,
      this.roomOwnerTypeId,
      this.roomName,
      this.roomDescription,
      this.isPrivate,
      this.isSharable,
      this.roomType,
      this.roomStatus,
      this.id,
      this.institutionName,
      this.institutionMembersCount});

  CreateRoomModel.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    roomCreatedByType = json['room_created_by_type'];
    roomCreatedById = json['room_created_by_id'];
    roomOwnerType = json['room_owner_type'];
    roomOwnerTypeId = json['room_owner_type_id'];
    roomName = json['room_name'];
    roomDescription = json['room_description'];
    isPrivate = json['is_private'];
    isSharable = json['is_sharable'];
    roomType = json['room_type'];
    roomStatus = json['room_status'];
    id = json['id'];
    institutionName = json['institution_name'];
    institutionMembersCount = json['institution_members_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['room_created_by_type'] = this.roomCreatedByType;
    data['room_created_by_id'] = this.roomCreatedById;
    data['room_owner_type'] = this.roomOwnerType;
    data['room_owner_type_id'] = this.roomOwnerTypeId;
    data['room_name'] = this.roomName;
    data['room_description'] = this.roomDescription;
    data['is_private'] = this.isPrivate;
    data['is_sharable'] = this.isSharable;
    data['room_type'] = this.roomType;
    data['room_status'] = this.roomStatus;
    data['id'] = this.id;
    data['institution_name'] = this.institutionName;
    data['institution_members_count'] = this.institutionMembersCount;
    return data;
  }
}
