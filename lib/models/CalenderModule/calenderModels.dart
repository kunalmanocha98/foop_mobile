class CalenderEventListRequest {
  String eventOwnerType;
  String searchVal;
  int eventOwnerId;
  String eventDate;
  int pageNumber;
  int pageSize;
  String listType;

  CalenderEventListRequest(
      {this.eventOwnerType, this.eventOwnerId, this.eventDate,this.pageNumber,this.pageSize});

  CalenderEventListRequest.fromJson(Map<String, dynamic> json) {
    eventOwnerType = json['event_owner_type'];
    eventOwnerId = json['event_owner_id'];
    eventDate = json['event_date'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
    listType = json['list_type'];
    searchVal=json['search_val'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event_owner_type'] = this.eventOwnerType;
    data['event_owner_id'] = this.eventOwnerId;
    data['list_type'] = this.listType;
    data['event_date'] = this.eventDate;
    data['page_size'] = this.pageSize;
    data['page_number'] = this.pageNumber;
    data['search_val']=this.searchVal;
    return data;
  }
}


class CalenderEventListResponse {
  String statusCode;
  String message;
  List<CalenderEventItem> rows;
  int total;

  CalenderEventListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  CalenderEventListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//CalenderEventItem>();
      json['rows'].forEach((v) {
        rows.add(new CalenderEventItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class CalenderEventItem {
  int id;
  int calEventsId;
  int standardEventsId;
  String calendarOwnerType;
  int calendarOwnerId;
  String eventRoleType;
  String title;
  String subtitle;
  Null eventImportanceType;
  Null eventCategory;
  Null eventImage;
  EventLocation eventLocation;
  String eventDate;
  Null eventTimeZone;
  Null eventColorCode;
  Null eventIcon;
  String startTime;
  String endTime;
  Null reminderTime;
  Null reminderUnit;
  bool isFullDay;
  String eventStatus;
  Null eventAccessUrl;
  String calContextType;
  int calContextTypeId;
  Header header;
  List<ParticipantList> participantList;
  List<String> recipientType;

  CalenderEventItem(
      {this.id,
        this.calEventsId,
        this.standardEventsId,
        this.calendarOwnerType,
        this.calendarOwnerId,
        this.eventRoleType,
        this.title,
        this.subtitle,
        this.eventImportanceType,
        this.eventCategory,
        this.eventImage,
        this.eventLocation,
        this.eventDate,
        this.eventTimeZone,
        this.eventColorCode,
        this.eventIcon,
        this.startTime,
        this.endTime,
        this.reminderTime,
        this.reminderUnit,
        this.isFullDay,
        this.eventStatus,
        this.eventAccessUrl,
        this.calContextType,
        this.calContextTypeId,
        this.header,
        this.recipientType,
        this.participantList});

  CalenderEventItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    calEventsId = json['cal_events_id'];
    standardEventsId = json['standard_events_id'];
    calendarOwnerType = json['calendar_owner_type'];
    calendarOwnerId = json['calendar_owner_id'];
    eventRoleType = json['event_role_type'];
    title = json['title'];
    subtitle = json['subtitle'];
    eventImportanceType = json['event_importance_type'];
    eventCategory = json['event_category'];
    eventImage = json['event_image'];
    eventLocation = json['event_location'] != null ?EventLocation.fromJson(json['event_location']) : null;
    eventDate = json['event_date'];
    eventTimeZone = json['event_time_zone'];
    eventColorCode = json['event_color_code'];
    eventIcon = json['event_icon'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    reminderTime = json['reminder_time'];
    reminderUnit = json['reminder_unit'];
    isFullDay = json['is_full_day'];
    eventStatus = json['event_status'];
    eventAccessUrl = json['event_access_url'];
    calContextType = json['cal_context_type'];
    calContextTypeId = json['cal_context_type_id'];
    header = json['header'] != null ? new Header.fromJson(json['header']) : null;
    if (json['participant_list'] != null) {
      participantList = [];//ParticipantList>();
      json['participant_list'].forEach((v) {
        participantList.add(new ParticipantList.fromJson(v));
      });
    }
    recipientType = json['recipient_type'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cal_events_id'] = this.calEventsId;
    data['standard_events_id'] = this.standardEventsId;
    data['calendar_owner_type'] = this.calendarOwnerType;
    data['calendar_owner_id'] = this.calendarOwnerId;
    data['event_role_type'] = this.eventRoleType;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['event_importance_type'] = this.eventImportanceType;
    data['event_category'] = this.eventCategory;
    data['event_image'] = this.eventImage;
    if(this.eventLocation !=null){
      data['event_location'] = this.eventLocation.toJson();
    }
    data['event_date'] = this.eventDate;
    data['event_time_zone'] = this.eventTimeZone;
    data['event_color_code'] = this.eventColorCode;
    data['event_icon'] = this.eventIcon;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['reminder_time'] = this.reminderTime;
    data['reminder_unit'] = this.reminderUnit;
    data['is_full_day'] = this.isFullDay;
    data['event_status'] = this.eventStatus;
    data['event_access_url'] = this.eventAccessUrl;
    data['cal_context_type'] = this.calContextType;
    data['cal_context_type_id'] = this.calContextTypeId;
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    if (this.participantList != null) {
      data['participant_list'] = this.participantList.map((v) => v.toJson()).toList();
    }
    data['recipient_type'] = this.recipientType;
    return data;
  }
}

class EventLocation {
  String lat;
  String long;
  String address;
  String city;
  String state;
  String country;
  String pincode;

  EventLocation(
      {this.lat,
        this.long,
        this.address,
        this.city,
        this.state,
        this.country,
        this.pincode});

  EventLocation.fromJson(Map<String, dynamic> json) {
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

class Header {
  String title;
  List<Action> action;
  String avatar;
  double rating;
  String subtitle1;
  bool isVerified;

  Header(
      {this.title,
        this.action,
        this.avatar,
        this.rating,
        this.subtitle1,
        this.isVerified});

  Header.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['action'] != null) {
      action = [];//Action>();
      json['action'].forEach((v) {
        action.add(new Action.fromJson(v));
      });
    }
    avatar = json['avatar'];
    rating = json['rating'];
    subtitle1 = json['subtitle1'];
    isVerified = json['is_verified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.action != null) {
      data['action'] = this.action.map((v) => v.toJson()).toList();
    }
    data['avatar'] = this.avatar;
    data['rating'] = this.rating;
    data['subtitle1'] = this.subtitle1;
    data['is_verified'] = this.isVerified;
    return data;
  }
}

class Action {
  String type;
  bool value;

  Action({this.type, this.value});

  Action.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class ParticipantList {
  String name;
  String profileImage;

  ParticipantList({this.name, this.profileImage});

  ParticipantList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    return data;
  }
}