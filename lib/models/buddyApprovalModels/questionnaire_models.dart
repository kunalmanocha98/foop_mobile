class QuestionnaireListRequest {
  int approvedPersonId;
  int approvedPersonInstitutionId;

  QuestionnaireListRequest(
      {this.approvedPersonId, this.approvedPersonInstitutionId});

  QuestionnaireListRequest.fromJson(Map<String, dynamic> json) {
    approvedPersonId = json['approved_person_id'];
    approvedPersonInstitutionId = json['approved_person_institution_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['approved_person_id'] = this.approvedPersonId;
    data['approved_person_institution_id'] = this.approvedPersonInstitutionId;
    return data;
  }
}

class QuestionnaireListResponse {
  String statusCode;
  String message;
  List<QuestionsItem> rows;
  int total;

  QuestionnaireListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  QuestionnaireListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//QuestionsItem>();
      json['rows'].forEach((v) {
        rows.add(new QuestionsItem.fromJson(v));
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

class QuestionsItem {
  int id;
  String question;
  List<String> questionnaireOptions;
  int buddyApprovalId;
  String questionType;

  QuestionsItem(
      {this.id,
        this.question,
        this.questionnaireOptions,
        this.buddyApprovalId,
      this.questionType});

  QuestionsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    questionnaireOptions = json['questionnaire_options'].cast<String>();
    buddyApprovalId = json['buddy_approval_id'];
    questionType = json['question_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['questionnaire_options'] = this.questionnaireOptions;
    data['buddy_approval_id'] = this.buddyApprovalId;
    data['question_type'] = this.questionType;
    return data;
  }
}