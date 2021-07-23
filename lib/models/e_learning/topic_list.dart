class TopicListRequest {
  String? searchVal;
  int? pageNumber;
  int? pageSize;
  int? parentTopicId;

  TopicListRequest(
      {this.searchVal, this.pageNumber, this.pageSize, this.parentTopicId});

  TopicListRequest.fromJson(Map<String, dynamic> json) {
    searchVal = json['searchVal'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    parentTopicId = json['parent_topic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['searchVal'] = this.searchVal;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['parent_topic_id'] = this.parentTopicId;
    return data;
  }
}

class TopicListResponse {
  String? statusCode;
  String? message;
  List<TopicListItem>? rows;
  int? total;

  TopicListResponse({this.statusCode, this.message, this.rows, this.total});

  TopicListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//TopicListItem>();
      json['rows'].forEach((v) {
        rows!.add(new TopicListItem.fromJson(v));
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

class TopicListItem {
  String? topicName;
  String? topicCode;
  String? topicDescription;
  String? imageUrl;
  int? topicId;
  bool? isSelected;

  TopicListItem(
      {this.topicName,
        this.topicCode,
        this.topicDescription,
        this.imageUrl,
        this.isSelected,
        this.topicId});

  TopicListItem.fromJson(Map<String, dynamic> json) {
    topicName = json['topic_name'];
    topicCode = json['topic_code'];
    topicDescription = json['topic_description'];
    imageUrl = json['image_url'];
    topicId = json['topic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['topic_name'] = this.topicName;
    data['topic_code'] = this.topicCode;
    data['topic_description'] = this.topicDescription;
    data['image_url'] = this.imageUrl;
    data['topic_id'] = this.topicId;
    return data;
  }
}