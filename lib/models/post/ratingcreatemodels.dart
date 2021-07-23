class CreateRatingPayload {
  int? ratingNoteId;
  String? ratingSubjectType;
  int? ratingSubjectId;
  String? ratingContextType;
  int? ratingContextId;
  int? ratingGivenById;
  String? ratingGiven;

  CreateRatingPayload(
      {this.ratingNoteId,
        this.ratingSubjectType,
        this.ratingSubjectId,
        this.ratingContextType,
        this.ratingContextId,
        this.ratingGivenById,
        this.ratingGiven});

  CreateRatingPayload.fromJson(Map<String, dynamic> json) {
    ratingNoteId = json['rating_note_id'];
    ratingSubjectType = json['rating_subject_type'];
    ratingSubjectId = json['rating_subject_id'];
    ratingContextType = json['rating_context_type'];
    ratingContextId = json['rating_context_id'];
    ratingGivenById = json['rating_given_by_id'];
    ratingGiven = json['rating_given'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_note_id'] = this.ratingNoteId;
    data['rating_subject_type'] = this.ratingSubjectType;
    data['rating_subject_id'] = this.ratingSubjectId;
    data['rating_context_type'] = this.ratingContextType;
    data['rating_context_id'] = this.ratingContextId;
    data['rating_given_by_id'] = this.ratingGivenById;
    data['rating_given'] = this.ratingGiven;
    return data;
  }
}