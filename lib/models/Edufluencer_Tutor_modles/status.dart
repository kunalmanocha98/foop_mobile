class EdufluencerStatusResponse {
  String? statusCode;
  String? message;
  EdufluencerStatus? rows;
  int? total;

  EdufluencerStatusResponse(
      {this.statusCode, this.message, this.rows, this.total});

  EdufluencerStatusResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new EdufluencerStatus.fromJson(json['rows']) : null;
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.toJson();
    }
    data['total'] = this.total;
    return data;
  }
}

class EdufluencerStatus {
  int? id;
  int? myStudentCount;
  int? myEdufluencerTutorCount;
  bool? isEdufluencer;

  EdufluencerStatus(
      {this.id,
        this.myStudentCount,
        this.myEdufluencerTutorCount,
        this.isEdufluencer});

  EdufluencerStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    myStudentCount = json['my_student_count'];
    myEdufluencerTutorCount = json['my_edufluencer_tutor_count'];
    isEdufluencer = json['is_edufluencer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['my_student_count'] = this.myStudentCount;
    data['my_edufluencer_tutor_count'] = this.myEdufluencerTutorCount;
    data['is_edufluencer'] = this.isEdufluencer;
    return data;
  }
}