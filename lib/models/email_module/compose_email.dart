class EmailCreateRequest {
  int? id;
  String? personId;
  String? username;
  String? fromAddress;
  String? toAddresses;
  String? ccAddresses;
  String? bccAddresses;
  String? emailSubject;
  String? emailText;
  String? originalMessageUid;
  String? files;
  String? folder;

  EmailCreateRequest(
      {this.personId,
        this.username,
        this.fromAddress,
        this.toAddresses,
        this.ccAddresses,
        this.bccAddresses,
        this.emailSubject,
        this.emailText,
        this.originalMessageUid,
        this.id,
        this.folder,
        this.files});

  EmailCreateRequest.fromJson(Map<String, dynamic> json) {
    personId = json['person_id'];
    username = json['username'];
    fromAddress = json['from_address'];
    toAddresses = json['to_addresses'];
    ccAddresses = json['cc_addresses'];
    bccAddresses = json['bcc_addresses'];
    emailSubject = json['email_subject'];
    emailText = json['email_text'];
    originalMessageUid = json['original_message_uid'];
    files = json['files'];
    id = json['id'];
    folder = json['folder'];
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
    data['original_message_uid'] = this.originalMessageUid;
    data['files'] = this.files;
    data['id'] = this.id;
    data['folder'] = this.folder;
    return data;
  }
}