class TalkEventListRequest {
  String? eventOwnerType;
  int? eventOwnerId;
  String? listType;
  String? eventStatus;
  int? pageNumber;
  int? pageSize;

  TalkEventListRequest(
      {this.eventOwnerType,
        this.eventOwnerId,
        this.listType,
        this.eventStatus,
        this.pageNumber,
        this.pageSize});

  TalkEventListRequest.fromJson(Map<String, dynamic> json) {
    eventOwnerType = json['event_owner_type'];
    eventOwnerId = json['event_owner_id'];
    listType = json['list_type'];
    eventStatus = json['event_status'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_owner_type'] = this.eventOwnerType;
    data['event_owner_id'] = this.eventOwnerId;
    data['list_type'] = this.listType;
    data['event_status'] = this.eventStatus;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    return data;
  }
}


