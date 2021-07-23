class TypingPayload {
  String? conversationId;
  String? personId;
  bool? isTyping;

  TypingPayload({this.conversationId, this.personId, this.isTyping});

  TypingPayload.fromJson(Map<String, dynamic> json) {
    conversationId = json['conversationId'];
    personId = json['personId'];
    isTyping = json['isTyping'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['conversationId'] = this.conversationId;
    data['personId'] = this.personId;
    data['isTyping'] = this.isTyping;
    return data;
  }
}
