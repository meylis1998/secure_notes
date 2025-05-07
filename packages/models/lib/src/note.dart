import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String body;

  Note({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  static List<Note> listFromJson(list) =>
      List<Note>.from(list.map((x) => Note.fromJson(x)));

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}
