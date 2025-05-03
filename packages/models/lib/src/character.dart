class Character {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final NamedAPIResource origin;
  final NamedAPIResource location;
  final String image;
  final List<String> episode;
  final String url;
  final DateTime created;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as int,
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      type: json['type'] as String,
      gender: json['gender'] as String,
      origin: NamedAPIResource.fromJson(json['origin'] as Map<String, dynamic>),
      location: NamedAPIResource.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
      image: json['image'] as String,
      episode: (json['episode'] as List<dynamic>).cast<String>(),
      url: json['url'] as String,
      created: DateTime.parse(json['created'] as String),
    );
  }

  static List<Character> listFromJson(list) =>
      List<Character>.from(list.map((x) => Character.fromJson(x)));

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
    'species': species,
    'type': type,
    'gender': gender,
    'origin': origin.toJson(),
    'location': location.toJson(),
    'image': image,
    'episode': episode,
    'url': url,
    'created': created.toIso8601String(),
  };
}

class NamedAPIResource {
  final String name;
  final String url;

  NamedAPIResource({required this.name, required this.url});

  factory NamedAPIResource.fromJson(Map<String, dynamic> json) {
    return NamedAPIResource(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'url': url};
}
