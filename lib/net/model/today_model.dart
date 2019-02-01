class TodayResponse {
  bool error;
  List<String> category;
  Map<String, List<Today>> results = new Map<String, List<Today>>();

  TodayResponse({this.error, this.category, this.results});

  TodayResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    category = json['category'].cast<String>();
    Map<String, dynamic> mapResults = json['results'];
    for (MapEntry<String, dynamic> entry in mapResults.entries) {
      List<Today> list = new List<Today>();

      entry.value.forEach((v) {
        list.add(Today.fromJson(v));
      });
      results[entry.key] = list;
    }
  }
}

class Today {
  String sId;
  String createdAt;
  String desc;
  List<String> images;
  String publishedAt;
  String source;
  String type;
  String url;
  bool used;
  String who;

  Today(
      {this.sId,
      this.createdAt,
      this.desc,
      this.images,
      this.publishedAt,
      this.source,
      this.type,
      this.url,
      this.used,
      this.who});

  Today.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['createdAt'];
    desc = json['desc'];
    if (json['images'] != null) {
      images = json['images'].cast<String>();
    }
    publishedAt = json['publishedAt'];
    source = json['source'];
    type = json['type'];
    url = json['url'];
    used = json['used'];
    who = json['who'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['desc'] = this.desc;
    data['images'] = this.images;
    data['publishedAt'] = this.publishedAt;
    data['source'] = this.source;
    data['type'] = this.type;
    data['url'] = this.url;
    data['used'] = this.used;
    data['who'] = this.who;
    return data;
  }
}
