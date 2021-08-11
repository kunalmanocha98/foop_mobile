class DomainCreateRequest {
  String? domainName;
  String? ownerType;
  int? ownerId;
  String? customerServicesId;

  DomainCreateRequest(
      {this.domainName, this.ownerType, this.ownerId, this.customerServicesId});

  DomainCreateRequest.fromJson(Map<String, dynamic> json) {
    domainName = json['domain_name'];
    ownerType = json['owner_type'];
    ownerId = json['owner_id'];
    customerServicesId = json['customer_services_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['domain_name'] = this.domainName;
    data['owner_type'] = this.ownerType;
    data['owner_id'] = this.ownerId;
    data['customer_services_id'] = this.customerServicesId;
    return data;
  }
}

class DomainCreateResponse {
  String? statusCode;
  String? message;
  int? total;

  DomainCreateResponse({this.statusCode, this.message, this.total});

  DomainCreateResponse.fromJson(Map<String, dynamic> json) {
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


class DomainListResponse {
  String? statusCode;
  String? message;
  List<DomainListItem>? rows;
  int? total;

  DomainListResponse({this.statusCode, this.message, this.rows, this.total});

  DomainListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(new DomainListItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class DomainListItem {
  int? id;
  String? domainName;
  String? type;
  int? totalEmails;
  int? totalEmailsUsed;
  int? totalFreeEmails;
  String? domainStatus;

  DomainListItem(
      {this.id,
        this.domainName,
        this.type,
        this.totalEmails,
        this.totalEmailsUsed,
        this.totalFreeEmails,
        this.domainStatus});

  DomainListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    domainName = json['domain_name'];
    type = json['type'];
    totalEmails = json['total_emails'];
    totalEmailsUsed = json['total_emails_used'];
    totalFreeEmails = json['total_free_emails'];
    domainStatus = json['domain_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['domain_name'] = this.domainName;
    data['type'] = this.type;
    data['total_emails'] = this.totalEmails;
    data['total_emails_used'] = this.totalEmailsUsed;
    data['total_free_emails'] = this.totalFreeEmails;
    data['domain_status'] = this.domainStatus;
    return data;
  }
}