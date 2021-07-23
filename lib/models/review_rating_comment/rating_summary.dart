class RatingSummaryResponse {
  String? statusCode;
  String? message;
  List<RatingSummaryItem>? rows;
  int? total;

  RatingSummaryResponse({this.statusCode, this.message, this.rows, this.total});

  RatingSummaryResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//RatingSummaryItem>();
      json['rows'].forEach((v) {
        rows!.add(new RatingSummaryItem.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class RatingSummaryItem {
  String? ratingSubjectType;
  String? ratingSubjectId;
  String? ratingContextType;
  String? ratingContextId;
  int? rating01;
  int? rating02;
  int? rating03;
  int? rating04;
  int? rating05;
  String? averageRating;
  int? totalRatedUsers;

  RatingSummaryItem(
      {this.ratingSubjectType,
        this.ratingSubjectId,
        this.ratingContextType,
        this.ratingContextId,
        this.rating01,
        this.rating02,
        this.rating03,
        this.rating04,
        this.rating05,
        this.totalRatedUsers,
        this.averageRating});

  RatingSummaryItem.fromJson(Map<String, dynamic> json) {
    ratingSubjectType = json['rating_subject_type'];
    ratingSubjectId = json['rating_subject_id'];
    ratingContextType = json['rating_context_type'];
    ratingContextId = json['rating_context_id'];
    rating01 = json['rating_01'];
    rating02 = json['rating_02'];
    rating03 = json['rating_03'];
    rating04 = json['rating_04'];
    rating05 = json['rating_05'];
    averageRating = json['average_rating'];
    totalRatedUsers = json['total_rated_users'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating_subject_type'] = this.ratingSubjectType;
    data['rating_subject_id'] = this.ratingSubjectId;
    data['rating_context_type'] = this.ratingContextType;
    data['rating_context_id'] = this.ratingContextId;
    data['rating_01'] = this.rating01;
    data['rating_02'] = this.rating02;
    data['rating_03'] = this.rating03;
    data['rating_04'] = this.rating04;
    data['rating_05'] = this.rating05;
    data['average_rating'] = this.averageRating;
    data['total_rated_users'] = this.totalRatedUsers;
    return data;
  }
}