class SyncContactsMain {
  List<SyncContactsEntity> syncContactsEntity;

  SyncContactsMain({this.syncContactsEntity});

  SyncContactsMain.fromJson(Map<String, dynamic> json) {
    if (json['syncContactsEntity'] != null) {
      syncContactsEntity = [];//SyncContactsEntity>();
      json['syncContactsEntity'].forEach((v) {
        syncContactsEntity.add(new SyncContactsEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.syncContactsEntity != null) {
      data['syncContactsEntity'] =
          this.syncContactsEntity.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SyncContactsEntity {
  String addressBookOwnerType;
  String addressBookOwnerId;
  String contactFirstName;
  String contactMiddleName;
  String contactLastName;
  String contactReferenceId;
  String contactAddMethod;
  String contactNickName;
  String contactAddressLine01;
  String contactAddressLine02;
  String contactAddressLine03;
  String contactCountry;
  String contactState;
  String contactCity;
  String contactTitle;
  String contactGender;
  String contactOrganization;
  List<CommunicationDetails> communicationDetails;

  SyncContactsEntity(
      {this.addressBookOwnerType,
      this.addressBookOwnerId,
      this.contactFirstName,
      this.contactMiddleName,
      this.contactLastName,
      this.contactReferenceId,
      this.contactAddMethod,
      this.contactNickName,
      this.contactAddressLine01,
      this.contactAddressLine02,
      this.contactAddressLine03,
      this.contactCountry,
      this.contactState,
      this.contactCity,
      this.contactTitle,
      this.contactGender,
      this.contactOrganization,
      this.communicationDetails});

  SyncContactsEntity.fromJson(Map<String, dynamic> json) {
    addressBookOwnerType = json['address_book_owner_type'];
    addressBookOwnerId = json['address_book_owner_id'];
    contactFirstName = json['contact_first_name'];
    contactMiddleName = json['contact_middle_name'];
    contactLastName = json['contact_last_name'];
    contactReferenceId = json['contact_reference_id'];
    contactAddMethod = json['contact_add_method'];
    contactNickName = json['contact_nick_name'];
    contactAddressLine01 = json['contact_address_line_01'];
    contactAddressLine02 = json['contact_address_line_02'];
    contactAddressLine03 = json['contact_address_line_03'];
    contactCountry = json['contact_country'];
    contactState = json['contact_state'];
    contactCity = json['contact_city'];
    contactTitle = json['contact_title'];
    contactGender = json['contact_gender'];
    contactOrganization = json['contact_organization'];
    if (json['communication_details'] != null) {
      communicationDetails = [];//CommunicationDetails>();
      json['communication_details'].forEach((v) {
        communicationDetails.add(new CommunicationDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address_book_owner_type'] = this.addressBookOwnerType;
    data['address_book_owner_id'] = this.addressBookOwnerId;
    data['contact_first_name'] = this.contactFirstName;
    data['contact_middle_name'] = this.contactMiddleName;
    data['contact_last_name'] = this.contactLastName;
    data['contact_reference_id'] = this.contactReferenceId;
    data['contact_add_method'] = this.contactAddMethod;
    data['contact_nick_name'] = this.contactNickName;
    data['contact_address_line_01'] = this.contactAddressLine01;
    data['contact_address_line_02'] = this.contactAddressLine02;
    data['contact_address_line_03'] = this.contactAddressLine03;
    data['contact_country'] = this.contactCountry;
    data['contact_state'] = this.contactState;
    data['contact_city'] = this.contactCity;
    data['contact_title'] = this.contactTitle;
    data['contact_gender'] = this.contactGender;
    data['contact_organization'] = this.contactOrganization;
    if (this.communicationDetails != null) {
      data['communication_details'] =
          this.communicationDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommunicationDetails {
  String communicationMedium;
  String communicationType;
  String communicationDetail;
  String isPrimary;

  CommunicationDetails(
      {this.communicationMedium,
      this.communicationType,
      this.communicationDetail,
      this.isPrimary});

  CommunicationDetails.fromJson(Map<String, dynamic> json) {
    communicationMedium = json['communication_medium'];
    communicationType = json['communication_type'];
    communicationDetail = json['communication_detail'];
    isPrimary = json['is_primary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['communication_medium'] = this.communicationMedium;
    data['communication_type'] = this.communicationType;
    data['communication_detail'] = this.communicationDetail;
    data['is_primary'] = this.isPrimary;
    return data;
  }
}
