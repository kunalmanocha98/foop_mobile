class PostRecipientUpdatePayload {
  int? postId;
  String? postRecipientStatus;
  bool? isBookmarked;

  PostRecipientUpdatePayload(
      {this.postId, this.postRecipientStatus, this.isBookmarked});

  PostRecipientUpdatePayload.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    postRecipientStatus = json['post_recipient_status'];
    isBookmarked = json['is_bookmarked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['post_recipient_status'] = this.postRecipientStatus;
    data['is_bookmarked'] = this.isBookmarked;
    return data;
  }
}