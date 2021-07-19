class NotesListResponse {
  String statusCode;
  String message;
  List<NotesListItem> rows;
  int total;

  NotesListResponse({this.statusCode, this.message, this.rows, this.total});

  NotesListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//NotesListItem>();
      json['rows'].forEach((v) {
        rows.add(new NotesListItem.fromJson(v));
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

class NotesListItem {
  int note_id;
  int id;
  String noteType;
  String noteCreatedByType;
  String notesCreatedByName;
  String noteCreatedById;
  String noteSubjectType;
  String noteSubjectId;
  Null replyToNoteId;
  String noteContent;
  List<String> noteFormat;
  bool hasAttachment;
  bool makeAnonymous;
  String createdDate;
  String notesCreatedByProfile;
  Null mediaUrl;
  Null mediaThumbnailUrl;
  Null otherImageUrls;
  Null fileName;
  String postRate;
  int commRateCount;

  NotesListItem(
      {this.id,
        this.note_id,
        this.noteType,
        this.noteCreatedByType,
        this.notesCreatedByName,
        this.noteCreatedById,
        this.noteSubjectType,
        this.noteSubjectId,
        this.replyToNoteId,
        this.noteContent,
        this.noteFormat,
        this.hasAttachment,
        this.makeAnonymous,
        this.createdDate,
        this.mediaUrl,
        this.mediaThumbnailUrl,
        this.otherImageUrls,
        this.fileName,
        this.postRate,
        this.commRateCount,
      this.notesCreatedByProfile});

  NotesListItem.fromJson(Map<String, dynamic> json) {
    note_id = json['note_id'];
    id = json['id'];
    noteType = json['note_type'];
    noteCreatedByType = json['note_created_by_type'];
    notesCreatedByName = json['notes_created_by_name'];
    noteCreatedById = json['note_created_by_id'];
    noteSubjectType = json['note_subject_type'];
    noteSubjectId = json['note_subject_id'];
    replyToNoteId = json['reply_to_note_id'];
    noteContent = json['note_content'];
    noteFormat = json['note_format'].cast<String>();
    hasAttachment = json['has_attachment'];
    makeAnonymous = json['make_anonymous'];
    createdDate = json['created_date'];
    mediaUrl = json['media_url'];
    mediaThumbnailUrl = json['media_thumbnail_url'];
    otherImageUrls = json['other_image_urls'];
    fileName = json['file_name'];
    notesCreatedByProfile = json['notes_created_by_profile'];
    postRate = json['post_rate'];
    commRateCount = json['comm_rate_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['note_type'] = this.noteType;
    data['note_created_by_type'] = this.noteCreatedByType;
    data['notes_created_by_name'] = this.notesCreatedByName;
    data['note_created_by_id'] = this.noteCreatedById;
    data['note_subject_type'] = this.noteSubjectType;
    data['note_subject_id'] = this.noteSubjectId;
    data['reply_to_note_id'] = this.replyToNoteId;
    data['note_content'] = this.noteContent;
    data['note_format'] = this.noteFormat;
    data['has_attachment'] = this.hasAttachment;
    data['make_anonymous'] = this.makeAnonymous;
    data['created_date'] = this.createdDate;
    data['media_url'] = this.mediaUrl;
    data['media_thumbnail_url'] = this.mediaThumbnailUrl;
    data['other_image_urls'] = this.otherImageUrls;
    data['file_name'] = this.fileName;
    data['notes_created_by_profile'] = this.notesCreatedByProfile;
    data['post_rate'] = this.postRate;
    data['comm_rate_count'] = this.commRateCount;
    data['note_id'] = this.note_id;
    return data;
  }
}