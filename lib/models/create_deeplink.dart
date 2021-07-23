class CreateUrlPayload {
  int? shareItemId;
  String? shareById;
  String? shareItemType;
  String? shareMedium;
  Null slugUrl;
  Null targetAudience;
  String? deepLinkType;

  CreateUrlPayload(
      {this.shareItemId,
        this.shareById,
        this.shareItemType,
        this.shareMedium,
        this.slugUrl,
        this.targetAudience,
        this.deepLinkType});

  CreateUrlPayload.fromJson(Map<String, dynamic> json) {
    shareItemId = json['share_item_id'];
    shareById = json['share_by_id'];
    shareItemType = json['share_item_type'];
    shareMedium = json['share_medium'];
    slugUrl = json['slug_url'];
    targetAudience = json['target_audience'];
    deepLinkType = json['deep_link_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['share_item_id'] = this.shareItemId;
    data['share_by_id'] = this.shareById;
    data['share_item_type'] = this.shareItemType;
    data['share_medium'] = this.shareMedium;
    data['slug_url'] = this.slugUrl;
    data['target_audience'] = this.targetAudience;
    data['deep_link_type'] = this.deepLinkType;
    return data;
  }
}
