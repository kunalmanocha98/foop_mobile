class PollVotesListRequest {
  int postId;
  String option;
  int optionSequence;
  String objectType;
  int objectId;
  int pageSize;
  int pageNumber;

  PollVotesListRequest(
      {this.postId,
        this.option,
        this.optionSequence,
        this.objectType,
        this.objectId,
        this.pageSize,
        this.pageNumber});

  PollVotesListRequest.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    option = json['option'];
    optionSequence = json['option_sequence'];
    objectType = json['object_type'];
    objectId = json['object_id'];
    pageSize = json['page_size'];
    pageNumber = json['page_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['option'] = this.option;
    data['option_sequence'] = this.optionSequence;
    data['object_type'] = this.objectType;
    data['object_id'] = this.objectId;
    data['page_size'] = this.pageSize;
    data['page_number'] = this.pageNumber;
    return data;
  }
}

class PollVotesListResponse {
  String statusCode;
  String message;
  List<VotesListItem> rows;
  int total;

  PollVotesListResponse({this.statusCode, this.message, this.rows, this.total});

  PollVotesListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//VotesListItem>();
      json['rows'].forEach((v) {
        rows.add(new VotesListItem.fromJson(v));
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

class VotesListItem {
  String name;
  String profileImage;
  String subtitle;
  bool isObjectFollowing;
  int id;
  String type;

  VotesListItem({this.name, this.profileImage, this.subtitle, this.isObjectFollowing,this.id,this.type});

  VotesListItem.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profile_image'];
    subtitle = json['subtitle'];
    isObjectFollowing = json['is_object_following'];
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['subtitle'] = this.subtitle;
    data['is_object_following'] = this.isObjectFollowing;
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}