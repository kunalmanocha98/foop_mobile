class RequestListResponse {
  String? statusCode;
  String? message;
  List<RequestListItem>? rows;

  RequestListResponse({this.statusCode, this.message, this.rows});

  RequestListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//RequestListItem>();
      json['rows'].forEach((v) {
        rows!.add(new RequestListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestListItem {
  int? id;
  String? name;
  String? profileImage;
  String? requestedByType;
  int? requestedById;

  RequestListItem(
      {this.id,
        this.name,
        this.profileImage,
        this.requestedByType,
        this.requestedById});

  RequestListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImage = json['profile_image'];
    requestedByType = json['requested_by_type'];
    requestedById = json['requested_by_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['requested_by_type'] = this.requestedByType;
    data['requested_by_id'] = this.requestedById;
    return data;
  }
}