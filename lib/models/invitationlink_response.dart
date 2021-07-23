class InvitationResponse {
  String? statusCode;
  String? message;
  Rows? rows;
  int? total;

  InvitationResponse({this.statusCode, this.message, this.rows, this.total});

  InvitationResponse.fromJson(Map<String, dynamic> json) {
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
  String? invitationCode;
  String? invitationLink;
  String? invitationText;
  Rows({this.invitationCode, this.invitationLink});

  Rows.fromJson(Map<String, dynamic> json) {
    invitationCode = json['invitation_code'];
    invitationLink = json['invitation_link'];
    invitationText = json['invitation_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invitation_code'] = this.invitationCode;
    data['invitation_link'] = this.invitationLink;
    data['invitation_message'] = this.invitationText;
    return data;
  }
}
