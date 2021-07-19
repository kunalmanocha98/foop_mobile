import 'package:oho_works_app/models/post/postcreate.dart';

class CreateAnswerPayload {
  int postId;
  String answerByType;
  int answerById;
  String answerDetails;
  int id;
  String answerStatus;
  AnswerOtherDetails answerOtherDetails;

  CreateAnswerPayload(
      {this.postId, this.answerByType, this.answerById, this.answerDetails,this.id,this.answerOtherDetails,this.answerStatus});

  CreateAnswerPayload.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    answerByType = json['answer_by_type'];
    answerById = json['answer_by_id'];
    answerDetails = json['answer_details'];
    id = json['id'];
    answerStatus = json['answer_status'];
    answerOtherDetails = json['answer_other_details'] != null
        ? new AnswerOtherDetails.fromJson(json['answer_other_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['answer_by_type'] = this.answerByType;
    data['answer_by_id'] = this.answerById;
    data['answer_details'] = this.answerDetails;
    data['id'] = this.id;
    data['answer_status'] = this.answerStatus;
    if (this.answerOtherDetails != null) {
      data['answer_other_details'] = this.answerOtherDetails.toJson();
    }
    return data;
  }
}

class AnswerOtherDetails {
  String marks;
  List<MediaDetails> mediaDetails;

  AnswerOtherDetails({this.mediaDetails, this.marks});

  AnswerOtherDetails.fromJson(Map<String, dynamic> json) {
    if (json['media_urls'] != null) {
      mediaDetails = [];//MediaDetails>();
      json['media_urls'].forEach((v) {
        mediaDetails.add(new MediaDetails.fromJson(v));
      });
    }
    marks = json['marks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaDetails != null) {
      data['media_urls'] = this.mediaDetails.map((v) => v.toJson()).toList();
    }
    data['marks'] = this.marks;
    return data;
  }
}

class CreateAnswerResponse {
  String statusCode;
  String message;
  CreateAnswerPayload rows;
  int total;

  CreateAnswerResponse({this.statusCode, this.message, this.rows, this.total});

  CreateAnswerResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    rows = json['rows'] != null ? new CreateAnswerPayload.fromJson(json['rows']) : null;
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


class AnswerListRequest {
  int postId;
  int pageNumber;
  int pageSize;

  AnswerListRequest({this.postId, this.pageNumber, this.pageSize});

  AnswerListRequest.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    pageNumber = json['page_number'];
    pageSize = json['page_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this.postId;
    data['page_number'] = this.pageNumber;
    data['page_size'] = this.pageSize;
    return data;
  }
}

class AnswerListResponse {
  String statusCode;
  String message;
  List<AnswersListItem> rows;
  int total;

  AnswerListResponse({this.statusCode, this.message, this.rows, this.total});

  AnswerListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//AnswersListItem>();
      json['rows'].forEach((v) {
        rows.add(new AnswersListItem.fromJson(v));
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

class AnswersListItem {
  int id;
  int postId;
  String answerByType;
  int answerById;
  int answerDatetime;
  String answerDetails;
  String answerByName;
  String answerByImageUrl;
  String answerStatus;
  RatingDetails ratingDetails;
  AnswerOtherDetails answerOtherDetails;

  AnswersListItem(
      {this.id,
        this.postId,
        this.answerByType,
        this.answerById,
        this.answerDatetime,
        this.answerDetails,
        this.answerByName,
        this.answerByImageUrl,
        this.ratingDetails,
        this.answerOtherDetails,
        this.answerStatus});

  AnswersListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postId = json['post_id'];
    answerByType = json['answer_by_type'];
    answerById = json['answer_by_id'];
    answerDatetime = json['answer_datetime'];
    answerDetails = json['answer_details'];
    answerByName = json['answer_by_name'];
    answerByImageUrl = json['answer_by_image_url'];
    answerStatus = json['answer_status'];
    ratingDetails = json['rating_details'] != null
        ? new RatingDetails.fromJson(json['rating_details'])
        : null;
    answerOtherDetails = json['answer_other_details'] != null
        ? new AnswerOtherDetails.fromJson(json['answer_other_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['post_id'] = this.postId;
    data['answer_by_type'] = this.answerByType;
    data['answer_by_id'] = this.answerById;
    data['answer_datetime'] = this.answerDatetime;
    data['answer_details'] = this.answerDetails;
    data['answer_by_name'] = this.answerByName;
    data['answer_by_image_url'] = this.answerByImageUrl;
    data['answer_status'] = this.answerStatus;
    if (this.ratingDetails != null) {
      data['rating_details'] = this.ratingDetails.toJson();
    }
    if (this.answerOtherDetails != null) {
      data['answer_other_details'] = this.answerOtherDetails.toJson();
    }
    return data;
  }
}
class RatingDetails {
  double rating;
  String comment;

  RatingDetails({this.rating, this.comment});

  RatingDetails.fromJson(Map<String, dynamic> json) {
    rating = double.parse(json['rating'].toString());
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    return data;
  }
}