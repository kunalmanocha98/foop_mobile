class BuddyServiceListRequest {
  String ownerType;
  int ownerId;

  BuddyServiceListRequest({this.ownerType, this.ownerId});

  BuddyServiceListRequest.fromJson(Map<String, dynamic> json) {
    ownerType = json['owner_type'];
    ownerId = json['owner_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['owner_type'] = this.ownerType;
    data['owner_id'] = this.ownerId;
    return data;
  }
}

class BuddyServiceListResponse {
  String statusCode;
  String message;
  List<BuddyServiceListItem> rows;
  int total;

  BuddyServiceListResponse(
      {this.statusCode, this.message, this.rows, this.total});

  BuddyServiceListResponse.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['rows'] != null) {
      rows = [];//BuddyServiceListItem>();
      json['rows'].forEach((v) {
        rows.add(new BuddyServiceListItem.fromJson(v));
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

class BuddyServiceListItem {
  String cardName;
  String moneyVal;
  String imageUrl;
  String quote;
  String quote2;
  Null quote3;
  String heading;
  Null heading2;
  String coins;

  BuddyServiceListItem(
      {this.cardName,
        this.moneyVal,
        this.imageUrl,
        this.quote,
        this.quote2,
        this.quote3,
        this.heading,
        this.coins,
        this.heading2});

  BuddyServiceListItem.fromJson(Map<String, dynamic> json) {
    cardName = json['card_name'];
    moneyVal = json['money_val'];
    imageUrl = json['image_url'];
    quote = json['quote'];
    quote2 = json['quote_2'];
    quote3 = json['quote_3'];
    heading = json['heading'];
    heading2 = json['heading_2'];
    coins = json['coins'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['card_name'] = this.cardName;
    data['money_val'] = this.moneyVal;
    data['image_url'] = this.imageUrl;
    data['quote'] = this.quote;
    data['quote_2'] = this.quote2;
    data['quote_3'] = this.quote3;
    data['heading'] = this.heading;
    data['heading_2'] = this.heading2;
    data['coins'] = this.coins;
    return data;
  }
}