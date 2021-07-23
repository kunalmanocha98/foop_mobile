class EventCreateRequest {
  String? eventOwnerType;
  int? eventOwnerId;
  String? eventName;
  String? eventDescription;
  String? eventDate;
  int? startTime;
  int? endTime;
  int? standardEventsId;
  String? eventCategory;
  String? eventOrganizerType;
  int? eventOrganizerId;
  String? calContextType;
  String? eventStatus;
  int? calContextTypeId;
  List<String?>? recipientType;
  List<RecipientDetails>? recipientDetails;
  bool? isPaidEvent;
  int? paidAmount;
  String? paidCurrency;
  List<InvolvedPeopleList>? involvedPeopleList;
  List<EventLocation>? eventLocation;
  String? eventPrivacyType;
  List<String?>? eventTopics;
  List<String>? eventLanguages;
  int? eventId;

  EventCreateRequest(
      {this.eventOwnerType,
        this.eventOwnerId,
        this.eventName,
        this.eventDescription,
        this.eventDate,
        this.startTime,
        this.endTime,
        this.standardEventsId,
        this.eventCategory,
        this.eventOrganizerType,
        this.eventOrganizerId,
        this.calContextType,
        this.eventStatus,
        this.calContextTypeId,
        this.recipientType,
        this.recipientDetails,
        this.isPaidEvent,
        this.paidAmount,
        this.paidCurrency,
        this.involvedPeopleList,
        this.eventPrivacyType,
        this.eventTopics,
        this.eventId,
        this.eventLanguages,
        this.eventLocation});

  EventCreateRequest.fromJson(Map<String, dynamic> json) {
    eventOwnerType = json['event_owner_type'];
    eventOwnerId = json['event_owner_id'];
    eventName = json['event_name'];
    eventDescription = json['event_description'];
    eventDate = json['event_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    standardEventsId = json['standard_events_id'];
    eventCategory = json['event_category'];
    eventOrganizerType = json['event_organizer_type'];
    eventOrganizerId = json['event_organizer_id'];
    calContextType = json['cal_context_type'];
    eventStatus = json['event_status'];
    eventId = json['event_id'];
    calContextTypeId = json['cal_context_type_id'];
    eventPrivacyType = json['event_privacy_type'];
    eventTopics = json['event_topics'].cast<String>();
    recipientType = json['recipient_type'].cast<String>();
    eventLanguages = json['event_languages'].cast<String>();
    if (json['recipient_details'] != null) {
      recipientDetails = [];//RecipientDetails>();
      json['recipient_details'].forEach((v) {
        recipientDetails!.add(new RecipientDetails.fromJson(v));
      });
    }
    isPaidEvent = json['is_paid_event'];
    paidAmount = json['paid_amount'];
    paidCurrency = json['paid_currency'];
    if (json['involved_people_list'] != null) {
      involvedPeopleList = [];//InvolvedPeopleList>();
      json['involved_people_list'].forEach((v) {
        involvedPeopleList!.add(new InvolvedPeopleList.fromJson(v));
      });
    }
    if (json['event_location'] != null) {
      eventLocation = [];//EventLocation>();
      json['event_location'].forEach((v) {
        eventLocation!.add(new EventLocation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_owner_type'] = this.eventOwnerType;
    data['event_owner_id'] = this.eventOwnerId;
    data['event_name'] = this.eventName;
    data['event_description'] = this.eventDescription;
    data['event_date'] = this.eventDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['standard_events_id'] = this.standardEventsId;
    data['event_category'] = this.eventCategory;
    data['event_organizer_type'] = this.eventOrganizerType;
    data['event_organizer_id'] = this.eventOrganizerId;
    data['cal_context_type'] = this.calContextType;
    data['event_status'] = this.eventStatus;
    data['cal_context_type_id'] = this.calContextTypeId;
    data['recipient_type'] = this.recipientType;
    data['event_privacy_type'] = this.eventPrivacyType;
    data['event_topics'] = this.eventTopics;
    data['event_languages'] = this.eventLanguages;
    data['event_id'] = this.eventId;
    if (this.recipientDetails != null) {
      data['recipient_details'] =
          this.recipientDetails!.map((v) => v.toJson()).toList();
    }
    data['is_paid_event'] = this.isPaidEvent;
    data['paid_amount'] = this.paidAmount;
    data['paid_currency'] = this.paidCurrency;
    if (this.involvedPeopleList != null) {
      data['involved_people_list'] =
          this.involvedPeopleList!.map((v) => v.toJson()).toList();
    }
    if (this.eventLocation != null) {
      data['event_location'] =
          this.eventLocation!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecipientDetails {
  String? type;
  int? id;

  RecipientDetails({this.type, this.id});

  RecipientDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class InvolvedPeopleList {
  String? memberType;
  int? memberId;
  String? roleType;

  InvolvedPeopleList({this.memberType, this.memberId, this.roleType});

  InvolvedPeopleList.fromJson(Map<String, dynamic> json) {
    memberType = json['member_type'];
    memberId = json['member_id'];
    roleType = json['role_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member_type'] = this.memberType;
    data['member_id'] = this.memberId;
    data['role_type'] = this.roleType;
    return data;
  }
}

class EventLocation {
  String? type;
  Address? address;
  String? other;

  EventLocation({this.type, this.address, this.other});

  EventLocation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    address =
    json['address'] != null ? new Address.fromJson(json['address']) : null;
    other = json['other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.address != null) {
      data['address'] = this.address!.toJson();
    }
    data['other'] = this.other;
    return data;
  }
}

class Address {
  String? lat;
  String? long;
  String? address;
  String? city;
  String? state;
  String? country;
  String? pincode;

  Address(
      {this.lat,
        this.long,
        this.address,
        this.city,
        this.state,
        this.country,
        this.pincode});

  Address.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    return data;
  }
}

class CreateEventResponse {
  String? statusCode;
  String? message;
  int? total;
  Rows? rows;

  CreateEventResponse({this.statusCode, this.message,this.rows, this.total});

  CreateEventResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    rows = json['rows'] != null ? new Rows.fromJson(json['rows']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    return data;
  }
}

class Rows {
  int? id;

  Rows({this.id});

  Rows.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}