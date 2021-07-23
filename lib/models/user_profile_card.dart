class UserProfileCard {
  int? id;
  String? cardData;

  UserProfileCard({
    this.cardData,
    this.id,
  });

  UserProfileCard.fromJson(Map<String, dynamic> json) {
    cardData = json['cardData'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardData'] = this.cardData;
    data['_id'] = this.id;
    return data;
  }
}
