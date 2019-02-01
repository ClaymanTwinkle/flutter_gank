class CategoriesResponse {
  bool error;
  List<Category> results;

  CategoriesResponse({this.error, this.results});

  CategoriesResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['results'] != null) {
      results = new List<Category>();
      json['results'].forEach((v) {
        results.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String sId;
  String enName;
  String name;
  int rank;

  Category({this.sId, this.enName, this.name, this.rank});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    enName = json['en_name'];
    name = json['name'];
    rank = json['rank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['en_name'] = this.enName;
    data['name'] = this.name;
    data['rank'] = this.rank;
    return data;
  }
}



class SubCategoriesResponse {
  bool error;
  List<SubCategory> results;

  SubCategoriesResponse({this.error, this.results});

  SubCategoriesResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['results'] != null) {
      results = new List<SubCategory>();
      json['results'].forEach((v) {
        results.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  String sId;
  String createdAt;
  String icon;
  String id;
  String title;

  SubCategory({this.sId, this.createdAt, this.icon, this.id, this.title});

  SubCategory.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    createdAt = json['created_at'];
    icon = json['icon'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['created_at'] = this.createdAt;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}




class ArticleResponse {
  bool error;
  List<Article> results;

  ArticleResponse({this.error, this.results});

  ArticleResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['results'] != null) {
      results = new List<Article>();
      json['results'].forEach((v) {
        results.add(new Article.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Article {
  String sId;
  String content;
  String cover;
  int crawled;
  String createdAt;
  bool deleted;
  String publishedAt;
  String raw;
  Site site;
  String title;
  String uid;
  String url;

  Article(
      {this.sId,
        this.content,
        this.cover,
        this.crawled,
        this.createdAt,
        this.deleted,
        this.publishedAt,
        this.raw,
        this.site,
        this.title,
        this.uid,
        this.url});

  Article.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    content = json['content'];
    cover = json['cover'];
    crawled = json['crawled'];
    createdAt = json['created_at'];
    deleted = json['deleted'];
    publishedAt = json['published_at'];
    raw = json['raw'];
    site = json['site'] != null ? new Site.fromJson(json['site']) : null;
    title = json['title'];
    uid = json['uid'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['content'] = this.content;
    data['cover'] = this.cover;
    data['crawled'] = this.crawled;
    data['created_at'] = this.createdAt;
    data['deleted'] = this.deleted;
    data['published_at'] = this.publishedAt;
    data['raw'] = this.raw;
    if (this.site != null) {
      data['site'] = this.site.toJson();
    }
    data['title'] = this.title;
    data['uid'] = this.uid;
    data['url'] = this.url;
    return data;
  }
}

class Site {
  String catCn;
  String catEn;
  String desc;
  String feedId;
  String icon;
  String id;
  String name;
  int subscribers;
  String type;
  String url;

  Site(
      {this.catCn,
        this.catEn,
        this.desc,
        this.feedId,
        this.icon,
        this.id,
        this.name,
        this.subscribers,
        this.type,
        this.url});

  Site.fromJson(Map<String, dynamic> json) {
    catCn = json['cat_cn'];
    catEn = json['cat_en'];
    desc = json['desc'];
    feedId = json['feed_id'];
    icon = json['icon'];
    id = json['id'];
    name = json['name'];
    subscribers = json['subscribers'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_cn'] = this.catCn;
    data['cat_en'] = this.catEn;
    data['desc'] = this.desc;
    data['feed_id'] = this.feedId;
    data['icon'] = this.icon;
    data['id'] = this.id;
    data['name'] = this.name;
    data['subscribers'] = this.subscribers;
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}