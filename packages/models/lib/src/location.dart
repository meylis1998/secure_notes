// location.dart

class Location {
  final int id;
  final String name;
  final String type;
  final String dimension;
  final List<String> residents;
  final String url;
  final DateTime created;

  Location({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
    required this.residents,
    required this.url,
    required this.created,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      dimension: json['dimension'] as String,
      residents: List<String>.from(json['residents'] as List<dynamic>),
      url: json['url'] as String,
      created: DateTime.parse(json['created'] as String),
    );
  }

  static List<Location> listFromJson(list) =>
      List<Location>.from(list.map((x) => Location.fromJson(x)));

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'dimension': dimension,
    'residents': residents,
    'url': url,
    'created': created.toIso8601String(),
  };
}
