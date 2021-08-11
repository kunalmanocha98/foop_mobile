class EmailUserListRequest {
  String? ownerType;
  int? ownerId;
  String? emailIdStatus;
  int? pageNumber;
  int? pageSize;
  String? searchVal;

  EmailUserListRequest(
      {this.ownerType,
        this.ownerId,
        this.emailIdStatus,
        this.pageNumber,
        this.pageSize,
        this.searchVal});

  EmailUserListRequest.fromJson(Map<String, dynamic> json) {
    ownerType = json['owner_type'];
    ownerId = json['owner_id'];
    emailIdStatus = json['email_id_status'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    searchVal = json['search_val'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_type'] = this.ownerType;
    data['owner_id'] = this.ownerId;
    data['email_id_status'] = this.emailIdStatus;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    data['search_val'] = this.searchVal;
    return data;
  }
}



class EmailUserListResponse {
  String? statusCode;
  String? message;
  List<EmailUserListItem>? rows;
  int? total;

  EmailUserListResponse({this.statusCode, this.message, this.rows, this.total});

  EmailUserListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows!.add(new EmailUserListItem.fromJson(v));
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

class EmailUserListItem {
  String? emailId;
  int? id;
  int? customerServicesId;
  int? customerEmailDetailsId;
  int? emailIdCreatedOn;
  String? emailIdStatus;
  int? emailDeletedDate;
  String? avtar;
  String? title;
  int? personId;
  String? subtitle;

  EmailUserListItem(
      {this.emailId,
        this.id,
        this.customerServicesId,
        this.customerEmailDetailsId,
        this.emailIdCreatedOn,
        this.emailIdStatus,
        this.emailDeletedDate,
        this.avtar,
        this.title,
        this.personId,
        this.subtitle});

  EmailUserListItem.fromJson(Map<String, dynamic> json) {
    emailId = json['email_id'];
    id = json['id'];
    customerServicesId = json['customer_services_id'];
    customerEmailDetailsId = json['customer_email_details_id'];
    emailIdCreatedOn = json['email_id_created_on'];
    emailIdStatus = json['email_id_status'];
    emailDeletedDate = json['email_deleted_date'];
    avtar = json['avtar'];
    title = json['title'];
    personId = json['person_id'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_id'] = this.emailId;
    data['id'] = this.id;
    data['customer_services_id'] = this.customerServicesId;
    data['customer_email_details_id'] = this.customerEmailDetailsId;
    data['email_id_created_on'] = this.emailIdCreatedOn;
    data['email_id_status'] = this.emailIdStatus;
    data['email_deleted_date'] = this.emailDeletedDate;
    data['avtar'] = this.avtar;
    data['title'] = this.title;
    data['person_id'] = this.personId;
    data['subtitle'] = this.subtitle;
    return data;
  }
}
