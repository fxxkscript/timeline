class Right {
  final Level level;
  final List<Feature> features;
  final LevelGoods levelGoods;

  Right({this.level, this.features, this.levelGoods});

  factory Right.fromJson(Map<dynamic, dynamic> json) {
    return new Right(
        level: new Level.fromJson(json['level']),
        levelGoods: new LevelGoods.fromJson(json['levelGoods']),
        features: List<Feature>.from(
            json['features'].map((item) => new Feature.fromJSON(item))));
  }
}

class Level {
  final int id;
  final int level;
  final String name;
  final String icon;
  final String desc;

  Level({this.id, this.level, this.name, this.icon, this.desc});

  factory Level.fromJson(Map<dynamic, dynamic> json) {
    return new Level(
        id: json['id'],
        level: json['level'],
        name: json['name'],
        icon: json['icon'],
        desc: json['desc']);
  }
}

class LevelGoods {
  final String typeName;
  final String price;
  final int perUnit;
  final String perUnitName;
  final String perPrice;
  final int days;

  LevelGoods(
      {this.typeName, this.price, this.perUnit, this.perUnitName, this.perPrice, this.days});

  factory LevelGoods.fromJson(Map<dynamic, dynamic> json) {
    return new LevelGoods(
      typeName: json['typeName'],
      price: json['price'],
      perUnit: json['perUnit'],
      perUnitName: json['perUnitName'],
      perPrice: json['perPrice'],
      days: json['days'],
    );
  }
}


class Feature {
  final String name;
  final String icon;
  final String desc;

  Feature({this.name, this.icon, this.desc});

  factory Feature.fromJSON(Map<dynamic, dynamic> json) {
    return new Feature(
      name: json['name'],
      icon: json['icon'],
      desc: json['desc'],
    );
  }
}
