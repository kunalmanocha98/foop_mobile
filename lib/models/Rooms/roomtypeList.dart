class RoomTypeListRequest {
  int? institutionId;
  String? searchVal;
  int? pageSize;
  int? pageNumber;

  RoomTypeListRequest(
      {this.institutionId, this.searchVal, this.pageSize, this.pageNumber});

  RoomTypeListRequest.fromJson(Map<String, dynamic> json) {
    institutionId = json['business_id'];
    searchVal = json['searchVal'];
    pageSize = json['page_size'];
    pageNumber = json['page_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.institutionId;
    data['searchVal'] = this.searchVal;
    data['page_size'] = this.pageSize;
    data['page_number'] = this.pageNumber;
    return data;
  }
}

class RoomTypeListResponse {
  String? statusCode;
  String? message;
  List<RoomTypeListItem>? rows;
  int? total;

  RoomTypeListResponse({this.statusCode, this.message, this.rows, this.total});

  RoomTypeListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//RoomTypeListItem>();
      json['rows'].forEach((v) {
        rows!.add(new RoomTypeListItem.fromJson(v));
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

class RoomTypeListItem {
  String? name;
  String? code;
  String? description;
  int? roomTypeId;

  RoomTypeListItem({this.name, this.code, this.description, this.roomTypeId});

  RoomTypeListItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    description = json['description'];
    roomTypeId = json['room_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['description'] = this.description;
    data['room_type_id'] = this.roomTypeId;
    return data;
  }
}