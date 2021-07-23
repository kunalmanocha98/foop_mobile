class HostListRequest {
  int? pageNumber;
  int? pageSize;
  int? personId;

  HostListRequest({this.pageNumber, this.pageSize, this.personId});

  HostListRequest.fromJson(Map<String, dynamic> json) {
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    personId = json['person_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['person_id'] = this.personId;
    return data;
  }
}

class HostListResponse {
  String? statusCode;
  String? message;
  List<HostListItem>? rows;
  int? total;

  HostListResponse({this.statusCode, this.message, this.rows, this.total});

  HostListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//HostListItem>();
      json['rows'].forEach((v) {
        rows!.add(new HostListItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class HostListItem {
  String? eventOwnerType;
  int? eventOwnerId;
  String? eventOwnerName;
  String? eventOwnerImageUrl;
  String? privacyType;
  // Null topics;

  HostListItem(
      {this.eventOwnerType,
        this.eventOwnerId,
        this.eventOwnerName,
        this.eventOwnerImageUrl,
        this.privacyType,
        // this.topics
      });

  HostListItem.fromJson(Map<String, dynamic> json) {
    eventOwnerType = json['event_owner_type'];
    eventOwnerId = json['event_owner_id'];
    eventOwnerName = json['event_owner_name'];
    eventOwnerImageUrl = json['event_owner_image_url'];
    privacyType = json['privacy_type'];
    // topics = json['topics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_owner_type'] = this.eventOwnerType;
    data['event_owner_id'] = this.eventOwnerId;
    data['event_owner_name'] = this.eventOwnerName;
    data['event_owner_image_url'] = this.eventOwnerImageUrl;
    data['privacy_type'] = this.privacyType;
    // data['topics'] = this.topics;
    return data;
  }
}