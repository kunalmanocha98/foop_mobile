class RoomTopicRequest {
  int pageNumber;
  int pageSize;
  String searchVal;

  RoomTopicRequest({this.pageNumber, this.pageSize, this.searchVal});

  RoomTopicRequest.fromJson(Map<String, dynamic> json) {
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    searchVal = json['searchVal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['searchVal'] = this.searchVal;
    return data;
  }
}

class RoomTopicListResponse {
  String statusCode;
  String message;
  List<RoomTopicItem> rows;
  int total;

  RoomTopicListResponse({this.statusCode, this.message, this.rows, this.total});

  RoomTopicListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//RoomTopicItem>();
      json['rows'].forEach((v) {
        rows.add(new RoomTopicItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class RoomTopicItem {
  String topicName;
  String topicCode;
  String topicDescription;
  String imageUrl;
  int roomTopicsId;
  bool isSelected;

  RoomTopicItem(
      {this.topicName,
        this.topicCode,
        this.topicDescription,
        this.imageUrl,
        this.isSelected,
        this.roomTopicsId});

  RoomTopicItem.fromJson(Map<String, dynamic> json) {
    topicName = json['topic_name'];
    topicCode = json['topic_code'];
    topicDescription = json['topic_description'];
    imageUrl = json['image_url'];
    roomTopicsId = json['room_topics_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic_name'] = this.topicName;
    data['topic_code'] = this.topicCode;
    data['topic_description'] = this.topicDescription;
    data['image_url'] = this.imageUrl;
    data['room_topics_id'] = this.roomTopicsId;
    return data;
  }
}