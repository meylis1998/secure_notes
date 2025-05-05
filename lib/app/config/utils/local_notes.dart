import 'package:hive/hive.dart';
import 'package:models/models.dart';

class LocalNotesHive {
  final Box<Note> _box = Hive.box<Note>('secure_notes');

  List<Note> getAll() => _box.values.toList();
  Future<void> add(Note note) => _box.add(note);
  Future<void> update(int key, Note note) => _box.put(key, note);
  Future<void> delete(int key) => _box.delete(key);
}
