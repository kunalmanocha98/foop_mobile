class EventListResponse {
  String statusCode;
  String message;
  List<EventListItem> rows;
  int total;

  EventListResponse({this.statusCode, this.message, this.rows, this.total});

  EventListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//EventListItem>();
      json['rows'].forEach((v) {
        rows.add(new EventListItem.fromJson(v));
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
class EventViewResponse {
  String statusCode;
  String message;
  EventListItem rows;
  int total;

  EventViewResponse({this.statusCode, this.message, this.rows, this.total});

  EventViewResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new EventListItem.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class EventListItem {
  int id;
  int calEventsId;
  int standardEventsId;
  String eventOwnerType;
  int eventOwnerId;
  String calendarOwnerType;
  int calendarOwnerId;
  String eventRoleType;
  List<String> recipientType;
  String title;
  int userReminderTime;
  String subtitle;
  String eventImportanceType;
  String eventCategory;
  String eventImage;
  String eventDate;
  Null eventTimeZone;
  Null eventColorCode;
  Null eventIcon;
  int startTime;
  int endTime;
  Null reminderTime;
  Null reminderUnit;
  Null isFullDay;
  String eventStatus;
  Null eventAccessUrl;
  String calContextType;
  int calContextTypeId;
  Header header;
  String eventPrivacyType;
  List<String> eventTopics;
  List<String> eventLanguages;
  List<ParticipantList> participantList;
  int isModerator;
  bool isMute;

  EventListItem(
      {this.id,
        this.calEventsId,
        this.standardEventsId,
        this.calendarOwnerType,
        this.calendarOwnerId,
        this.eventRoleType,
        this.recipientType,
        this.title,
        this.subtitle,
        this.userReminderTime,
        this.eventImportanceType,
        this.eventCategory,
        this.eventImage,
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
        this.eventPrivacyType,
        this.eventTopics,
        this.eventLanguages,
        this.eventOwnerId,
        this.eventOwnerType,
        this.isModerator,
        this.isMute,
        this.participantList});

  EventListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    calEventsId = json['cal_events_id'];
    userReminderTime=json['user_reminder_time'];
    standardEventsId = json['standard_events_id'];
    calendarOwnerType = json['calendar_owner_type'];
    calendarOwnerId = json['calendar_owner_id'];
    eventRoleType = json['event_role_type'];
    recipientType = json['recipient_type'] !=null ?json['recipient_type'].cast<String>(): json['recipient_type'];
    title = json['title'];
    subtitle = json['subtitle'];
    eventImportanceType = json['event_importance_type'];
    eventCategory = json['event_category'];
    eventImage = json['event_image'];
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
    eventOwnerId = json['event_owner_id'];
    eventOwnerType = json['event_owner_type'];
    isModerator = json['is_moderator'];
    header =
    json['header'] != null ? new Header.fromJson(json['header']) : null;
    eventPrivacyType = json['event_privacy_type'];
    eventTopics = json['event_topics']!=null ? json['event_topics'].cast<String>() :json['event_topics'];
    eventLanguages =  json['event_languages']!=null ? json['event_languages'].cast<String>():  json['event_languages'];
    if (json['participant_list'] != null) {
      participantList = [];//ParticipantList>();
      json['participant_list'].forEach((v) {
        participantList.add(new ParticipantList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_reminder_time']=this.userReminderTime;
    data['cal_events_id'] = this.calEventsId;
    data['standard_events_id'] = this.standardEventsId;
    data['calendar_owner_type'] = this.calendarOwnerType;
    data['calendar_owner_id'] = this.calendarOwnerId;
    data['event_role_type'] = this.eventRoleType;
    data['recipient_type'] = this.recipientType;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['event_importance_type'] = this.eventImportanceType;
    data['event_category'] = this.eventCategory;
    data['event_image'] = this.eventImage;
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
    data['event_owner_type'] = this.eventOwnerType;
    data['event_owner_id'] = this.eventOwnerId;
    data['is_moderator'] = this.isModerator;
    if (this.header != null) {
      data['header'] = this.header.toJson();
    }
    data['event_privacy_type'] = this.eventPrivacyType;
    data['event_topics'] = this.eventTopics;
    data['event_languages'] = this.eventLanguages;
    if (this.participantList != null) {
      data['participant_list'] =
          this.participantList.map((v) => v.toJson()).toList();
    }
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
    rating = (json['rating'] is int)?double.parse(json['rating'].toString()):json['rating'];
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
  String role;
  bool isOnline;

  ParticipantList({this.name, this.profileImage, this.role, this.isOnline});

  ParticipantList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    profileImage = json['profile_image'];
    role = json['role'];
    isOnline = json['is_online'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['profile_image'] = this.profileImage;
    data['role'] = this.role;
    data['is_online'] = this.isOnline;
    return data;
  }
}