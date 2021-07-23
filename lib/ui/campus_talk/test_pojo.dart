import 'package:oho_works_app/models/campus_talk/participant_list.dart';

class NewParticipant {
  String? statusCode;
  String? message;
  ParticipantListItem? rows;
  int? total;

  NewParticipant({this.statusCode, this.message, this.rows, this.total});

  NewParticipant.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new ParticipantListItem.fromJson(json['rows']) : null;
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

