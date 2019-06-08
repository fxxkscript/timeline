class Right {
  final Level level;
  final List<Feature> features;

  Right({this.level, this.features});

  factory Right.fromJson(Map<dynamic, dynamic> json) {
    return new Right(
        level: new Level.fromJson(json['level']),
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
