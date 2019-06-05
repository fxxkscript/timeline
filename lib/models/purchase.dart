class Right {
  final Level level;

  Right({this.level});

  factory Right.fromJson(Map<dynamic, dynamic> json) {
    return new Right(level: new Level.fromJson(json['level']));
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
