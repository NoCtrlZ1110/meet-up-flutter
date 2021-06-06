// @dart=2.9
class NearbyLocation {
  String next;
  List<Items> items;

  NearbyLocation({this.next, this.items});

  NearbyLocation.fromJson(Map<String, dynamic> json) {
    next = json['next'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['next'] = this.next;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  List<double> position;
  int distance;
  String title;
  double averageRating;
  Category category;
  String icon;
  String vicinity;
  List<Null> having;
  String type;
  String href;
  String id;
  List<Tags> tags;

  Items(
      {this.position,
      this.distance,
      this.title,
      this.averageRating,
      this.category,
      this.icon,
      this.vicinity,
      this.having,
      this.type,
      this.href,
      this.id,
      this.tags});

  Items.fromJson(Map<String, dynamic> json) {
    position = json['position'].cast<double>();
    distance = json['distance'];
    title = json['title'];
    averageRating = json['averageRating'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    icon = json['icon'];
    vicinity = json['vicinity'];
    // if (json['having'] != null) {
    //   having = new List<Null>();
    //   json['having'].forEach((v) {
    //     having.add(new Null.fromJson(v));
    //   });
    // }
    type = json['type'];
    href = json['href'];
    id = json['id'];
    if (json['tags'] != null) {
      tags = new List<Tags>();
      json['tags'].forEach((v) {
        tags.add(new Tags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this.position;
    data['distance'] = this.distance;
    data['title'] = this.title;
    data['averageRating'] = this.averageRating;
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    data['icon'] = this.icon;
    data['vicinity'] = this.vicinity;
    if (this.having != null) {
      data['having'] = this.having.map((dynamic v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['href'] = this.href;
    data['id'] = this.id;
    if (this.tags != null) {
      data['tags'] = this.tags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String id;
  String title;
  String href;
  String type;
  String system;

  Category({this.id, this.title, this.href, this.type, this.system});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    href = json['href'];
    type = json['type'];
    system = json['system'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['href'] = this.href;
    data['type'] = this.type;
    data['system'] = this.system;
    return data;
  }
}

class Tags {
  String id;
  String title;
  String group;

  Tags({this.id, this.title, this.group});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['group'] = this.group;
    return data;
  }
}
