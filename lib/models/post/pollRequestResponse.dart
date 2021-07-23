import 'package:oho_works_app/models/post/postcreate.dart';

class PollAnswerRequest {
  String? responseByType;
  int? responseById;
  String? option;
  int? optionSequence;
  int? postId;

  PollAnswerRequest(
      {this.responseByType,
        this.responseById,
        this.option,
        this.optionSequence,
        this.postId});

  PollAnswerRequest.fromJson(Map<String, dynamic> json) {
    responseByType = json['response_by_type'];
    responseById = json['response_by_id'];
    option = json['option'];
    optionSequence = json['option_sequence'];
    postId = json['post_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_by_type'] = this.responseByType;
    data['response_by_id'] = this.responseById;
    data['option'] = this.option;
    data['option_sequence'] = this.optionSequence;
    data['post_id'] = this.postId;
    return data;
  }
}



class PollVoteResponse {
  String? statusCode;
  String? message;
  OtherPollRequest? rows;
  int? total;

  PollVoteResponse({this.statusCode, this.message, this.rows, this.total});

  PollVoteResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new OtherPollRequest.fromJson(json['rows']) : null;
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