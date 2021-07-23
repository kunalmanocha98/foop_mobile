import 'package:oho_works_app/models/e_learning/topic_list.dart';



class LessonTopic {
  String? title;
  TopicListItem? topic;
  List<TopicListItem>? subtopic;

  LessonTopic({this.title, this.topic, this.subtopic});

  LessonTopic.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    topic =
    json['topic'] != null ? new TopicListItem.fromJson(json['topic']) : null;
    if (json['subtopic'] != null) {
      subtopic = [];//TopicListItem>();
      json['subtopic'].forEach((v) {
        subtopic!.add(new TopicListItem.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.topic != null) {
      data['topic'] = this.topic!.toJson();
    }
    if (this.subtopic != null) {
      data['subtopic'] = this.subtopic!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}