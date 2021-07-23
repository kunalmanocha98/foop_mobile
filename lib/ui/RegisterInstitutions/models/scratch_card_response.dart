class ScratchCardResult {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;

  ScratchCardResult({this.statusCode, this.message, this.rows, this.total});

  ScratchCardResult.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class Rows {
  int? id;
  int? scratchCardDetailsId;
  String? scratchCardRewardType;
  int? allPersonsId;
  String? scratchCardContext;
  String? scratchCardSubContext;
  int? scratchCardContextId;
  int? scratchCardSubContextId;
  String? scratchCardReceivedDate;
  String? scratchCardStatus;
  String? scratchCardValue;

  Rows(
      {this.id,
        this.scratchCardDetailsId,
        this.scratchCardRewardType,
        this.allPersonsId,
        this.scratchCardContext,
        this.scratchCardSubContext,
        this.scratchCardContextId,
        this.scratchCardSubContextId,
        this.scratchCardReceivedDate,
        this.scratchCardStatus,
        this.scratchCardValue});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    scratchCardDetailsId = json['scratch_card_details_id'];
    scratchCardRewardType = json['scratch_card_reward_type'];
    allPersonsId = json['all_persons_id'];
    scratchCardContext = json['scratch_card_context'];
    scratchCardSubContext = json['scratch_card_sub_context'];
    scratchCardContextId = json['scratch_card_context_id'];
    scratchCardSubContextId = json['scratch_card_sub_context_id'];
    scratchCardReceivedDate = json['scratch_card_received_date'];
    scratchCardStatus = json['scratch_card_status'];
    scratchCardValue = json['scratch_card_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['scratch_card_details_id'] = this.scratchCardDetailsId;
    data['scratch_card_reward_type'] = this.scratchCardRewardType;
    data['all_persons_id'] = this.allPersonsId;
    data['scratch_card_context'] = this.scratchCardContext;
    data['scratch_card_sub_context'] = this.scratchCardSubContext;
    data['scratch_card_context_id'] = this.scratchCardContextId;
    data['scratch_card_sub_context_id'] = this.scratchCardSubContextId;
    data['scratch_card_received_date'] = this.scratchCardReceivedDate;
    data['scratch_card_status'] = this.scratchCardStatus;
    data['scratch_card_value'] = this.scratchCardValue;
    return data;
  }
}
