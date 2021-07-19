class ScratchCardEntity {
  int allPersonsId;
  String scratchCardContext;
  String scratchCardSubContext;
  int scratchCardContextId;
  int scratchCardSubContextId;
  String photoIdUrl;
  ScratchCardEntity(
      {this.allPersonsId,
        this.scratchCardContext,
        this.scratchCardSubContext,
        this.scratchCardContextId,
        this.photoIdUrl,
        this.scratchCardSubContextId});

  ScratchCardEntity.fromJson(Map<String, dynamic> json) {
    allPersonsId = json['all_persons_id'];
    photoIdUrl = json['photo_id_url'];
    scratchCardContext = json['scratch_card_context'];
    scratchCardSubContext = json['scratch_card_sub_context'];
    scratchCardContextId = json['scratch_card_context_id'];
    scratchCardSubContextId = json['scratch_card_sub_context_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['all_persons_id'] = this.allPersonsId;
    data['photo_id_url']=this.photoIdUrl;
    data['scratch_card_context'] = this.scratchCardContext;
    data['scratch_card_sub_context'] = this.scratchCardSubContext;
    data['scratch_card_context_id'] = this.scratchCardContextId;
    data['scratch_card_sub_context_id'] = this.scratchCardSubContextId;
    return data;
  }
}
