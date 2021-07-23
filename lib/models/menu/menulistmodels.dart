class MenuListResponse {
  List<MenuListItem>? rows;


  MenuListResponse({this.rows});

  MenuListResponse.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      rows =  [];
      json['rows'].forEach((v) {
        rows!.add(new MenuListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuListItem {
  String? title;
  String? code;
  String? imageUrl;
  String? tag;
  String? description;
  bool? isTagVisivle;
  bool? isLoading = false;

  MenuListItem(
      {this.title,
      this.code,
      this.imageUrl,
      this.tag,
      this.isTagVisivle,
        this.description,
      this.isLoading});

  MenuListItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    code = json['code'];
    imageUrl = json['imageUrl'];
    tag = json['tag'];
    description = json['description'];
    isTagVisivle = json['isTagVisivle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['code'] = this.code;
    data['imageUrl'] = this.imageUrl;
    data['tag'] = this.tag;
    data['isTagVisivle'] = this.isTagVisivle;
    data['description'] = this.description;
    return data;
  }
}

class MenuListResponseNew {
  List<MenuListItemNew>? rows;

  MenuListResponseNew({this.rows});

  MenuListResponseNew.fromJson(Map<String, dynamic> json) {
    if (json['rows'] != null) {
      rows = [];//MenuListItemNew>();
      json['rows'].forEach((v) {
        rows!.add(new MenuListItemNew.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MenuListItemNew {
  String? title;
  List<Data>? data;

  MenuListItemNew({this.title, this.data});

  MenuListItemNew.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['data'] != null) {
      data =  [];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? title;
  String? code;
  String? imageUrl;
  String? tag;
  String? description;
  bool? isTagVisivle;

  Data(
      {this.title,
        this.code,
        this.imageUrl,
        this.tag,
        this.description,
        this.isTagVisivle});

  Data.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    code = json['code'];
    imageUrl = json['imageUrl'];
    tag = json['tag'];
    description = json['description'];
    isTagVisivle = json['isTagVisivle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['code'] = this.code;
    data['imageUrl'] = this.imageUrl;
    data['tag'] = this.tag;
    data['description'] = this.description;
    data['isTagVisivle'] = this.isTagVisivle;
    return data;
  }
}
