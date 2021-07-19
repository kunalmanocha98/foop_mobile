class DeepLinkingPayload {
  int userId;
  int postId;
  String userType;
  String id;
  String type;
  int institutionUserId;
  int institutionId;
  int personId;
  String profileImage;

  DeepLinkingPayload({this.userId, this.userType,this.id,this.type,this.institutionId,this.institutionUserId,this.profileImage,this.personId});

  DeepLinkingPayload.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    type = json['type'];
    postId = json['postId'];
    userType = json['userType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['type'] = this.type;
    data['postId'] = this.postId;
    data['userType'] = this.userType;
    return data;
  }
}
