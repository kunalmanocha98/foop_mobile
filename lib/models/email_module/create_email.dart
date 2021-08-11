
class MailComposeRequest {
  int? personId;
  String? username;
  String? fromAddress;
  List<String>? toAddresses;
  List<String>? ccAddresses;
  List<String>? bccAddresses;
  String? emailSubject;
  String? emailText;
  String? to;
  String? cc;
  String? bcc;

  MailComposeRequest(
      {this.personId,
        this.username,
        this.fromAddress,
        this.toAddresses,
        this.ccAddresses,
        this.bccAddresses,
        this.emailSubject,
        this.to,
        this.cc,
        this.bcc,
        this.emailText});

  MailComposeRequest.fromJson(Map<String, dynamic> json) {
    personId = json['person_id'];
    username = json['username'];
    fromAddress = json['from_address'];
    toAddresses = json['to_addresses'].cast<String>();
    ccAddresses = json['cc_addresses'].cast<String>();
    bccAddresses = json['bcc_addresses'].cast<String>();
    emailSubject = json['email_subject'];
    emailText = json['email_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['person_id'] = this.personId;
    data['username'] = this.username;
    data['from_address'] = this.fromAddress;
    data['to_addresses'] = this.toAddresses;
    data['cc_addresses'] = this.ccAddresses;
    data['bcc_addresses'] = this.bccAddresses;
    data['email_subject'] = this.emailSubject;
    data['email_text'] = this.emailText;
    return data;
  }
}

class SaveEmailResponse {
  String? statusCode;
  String? message;
  int? total;


  SaveEmailResponse({this.statusCode, this.message, this.total});

  SaveEmailResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    return data;
  }
}

class SaveDraftResponse {
  String? statusCode;
  String? message;
  String? rows;
  int? total;

  SaveDraftResponse({this.statusCode, this.message, this.rows, this.total});

  SaveDraftResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['rows'] = this.rows;
    data['total'] = this.total;
    return data;
  }
}