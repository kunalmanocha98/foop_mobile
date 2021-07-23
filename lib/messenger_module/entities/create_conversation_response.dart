import 'add_conversation_payload.dart';

class CreateConversationResponse {
  String? statusCode;
  String? message;
  List<AddConversationPayload>? rows;

  CreateConversationResponse({this.statusCode, this.message, this.rows});

  CreateConversationResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//AddConversationPayload>();
      json['rows'].forEach((v) {
        rows!.add(new AddConversationPayload.fromJson(v));
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

