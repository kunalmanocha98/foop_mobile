class NewConversationEvent {
  int id;
  int standardEventsId;
  String eventOwnerType;
  int eventOwnerId;
  String eventRoleType;
  int isModerator;
  List<String> recipientType;
  String title;
  String subtitle;
  String eventImportanceType;
  String eventCategory;
  String eventImage;

  String eventDate;
  String eventTimeZone;
  String eventColorCode;
  String eventIcon;
  int startTime;
  String endTime;
  String reminderUnit;
  String isFullDay;
  String eventStatus;
  String eventAccessUrl;
  String calContextType;
  int calContextTypeId;

  String eventPrivacyType;
  List<String> eventTopics;
  List<String> eventLanguages;
  String conversationId;


  NewConversationEvent(
      {this.id,
        this.standardEventsId,
        this.eventOwnerType,
        this.eventOwnerId,
        this.eventRoleType,
        this.isModerator,
        this.recipientType,
        this.title,
        this.subtitle,
        this.eventImportanceType,
        this.eventCategory,
        this.eventImage,

        this.eventDate,
        this.eventTimeZone,
        this.eventColorCode,
        this.eventIcon,
        this.startTime,
        this.endTime,
        this.reminderUnit,
        this.isFullDay,
        this.eventStatus,
        this.eventAccessUrl,
        this.calContextType,
        this.calContextTypeId,

        this.eventPrivacyType,
        this.eventTopics,
        this.eventLanguages,
        this.conversationId,
       });

  NewConversationEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    standardEventsId = json['standard_events_id'];
    eventOwnerType = json['event_owner_type'];
    eventOwnerId = json['event_owner_id'];
    eventRoleType = json['event_role_type'];
    isModerator = json['is_moderator'];
    recipientType = json['recipient_type'].cast<String>();
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
    reminderUnit = json['reminder_unit'];
    isFullDay = json['is_full_day'];
    eventStatus = json['event_status'];
    eventAccessUrl = json['event_access_url'];
    calContextType = json['cal_context_type'];
    calContextTypeId = json['cal_context_type_id'];

    eventPrivacyType = json['event_privacy_type'];
    eventTopics = json['event_topics'].cast<String>();

    conversationId = json['conversation_id'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['standard_events_id'] = this.standardEventsId;
    data['event_owner_type'] = this.eventOwnerType;
    data['event_owner_id'] = this.eventOwnerId;
    data['event_role_type'] = this.eventRoleType;
    data['is_moderator'] = this.isModerator;
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
    data['reminder_unit'] = this.reminderUnit;
    data['is_full_day'] = this.isFullDay;
    data['event_status'] = this.eventStatus;
    data['event_access_url'] = this.eventAccessUrl;
    data['cal_context_type'] = this.calContextType;
    data['cal_context_type_id'] = this.calContextTypeId;

    data['event_privacy_type'] = this.eventPrivacyType;
    data['event_topics'] = this.eventTopics;

    data['conversation_id'] = this.conversationId;

    return data;
  }
}




