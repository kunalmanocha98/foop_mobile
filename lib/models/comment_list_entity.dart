class CommentsListEntity {
  String statusCode;
  String message;
  List<CommentsItem> rows;
  int total;

  CommentsListEntity({this.statusCode, this.message, this.rows,this.total});

  CommentsListEntity.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    total = json['total'];
    if (json['rows'] != null) {
      rows = [];//CommentsItem>();
      json['rows'].forEach((v) {
        rows.add(new CommentsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['total'] = this.total;
    if (this.rows != null) {
      data['rows'] = this.rows.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommentsItem {
  int ratingId;
  int ratingNoteId;
  String ratingSubjectType;
  String ratingSubjectId;
  String ratingGiven;
  String noteCreatedByType;
  String notesCreatedByName;
  String noteCreatedById;
  String noteSubjectType;
  String noteSubjectId;
  Null replyToNoteId;
  String noteContent;
  List<String> noteFormat;
  bool makeAnonymous;
  String createdDate;
  Null mediaUrl;
  Null mediaThumbnailUrl;
  int averageRating;

  CommentsItem(
      {this.ratingId,
      this.ratingNoteId,
      this.ratingSubjectType,
      this.ratingSubjectId,
      this.ratingGiven,
      this.noteCreatedByType,
      this.notesCreatedByName,
      this.noteCreatedById,
      this.noteSubjectType,
      this.noteSubjectId,
      this.replyToNoteId,
      this.noteContent,
      this.noteFormat,
      this.makeAnonymous,
      this.createdDate,
      this.mediaUrl,
      this.mediaThumbnailUrl,
      this.averageRating});

  CommentsItem.fromJson(Map<String, dynamic> json) {
    ratingId = json['rating_id'];
    ratingNoteId = json['rating_note_id'];
    ratingSubjectType = json['rating_subject_type'];
    ratingSubjectId = json['rating_subject_id'];
    ratingGiven = json['rating_given'];
    noteCreatedByType = json['note_created_by_type'];
    notesCreatedByName = json['notes_created_by_name'];
    noteCreatedById = json['note_created_by_id'];
    noteSubjectType = json['note_subject_type'];
    noteSubjectId = json['note_subject_id'];
    replyToNoteId = json['reply_to_note_id'];
    noteContent = json['note_content'];
    noteFormat = json['note_format'].cast<String>();
    makeAnonymous = json['make_anonymous'];
    createdDate = json['created_date'];
    mediaUrl = json['media_url'];
    mediaThumbnailUrl = json['media_thumbnail_url'];
    averageRating = json['average_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_id'] = this.ratingId;
    data['rating_note_id'] = this.ratingNoteId;
    data['rating_subject_type'] = this.ratingSubjectType;
    data['rating_subject_id'] = this.ratingSubjectId;
    data['rating_given'] = this.ratingGiven;
    data['note_created_by_type'] = this.noteCreatedByType;
    data['notes_created_by_name'] = this.notesCreatedByName;
    data['note_created_by_id'] = this.noteCreatedById;
    data['note_subject_type'] = this.noteSubjectType;
    data['note_subject_id'] = this.noteSubjectId;
    data['reply_to_note_id'] = this.replyToNoteId;
    data['note_content'] = this.noteContent;
    data['note_format'] = this.noteFormat;
    data['make_anonymous'] = this.makeAnonymous;
    data['created_date'] = this.createdDate;
    data['media_url'] = this.mediaUrl;
    data['media_thumbnail_url'] = this.mediaThumbnailUrl;
    data['average_rating'] = this.averageRating;
    return data;
  }
}
