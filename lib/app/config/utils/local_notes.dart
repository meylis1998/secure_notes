import 'package:hive/hive.dart';
import 'package:models/models.dart';
import 'package:notes_data_src/notes_data_src.dart';

class LocalNotesHive implements LocalNotesDataSrc {
  final Box<Note> _box = Hive.box<Note>('secure_notes');

  @override
  Future<List<Note>> getNotes() async {
    return _box.values.toList();
  }

  @override
  Future<Note> addNote(Note note) async {
    await _box.add(note);
    return note;
  }

  @override
  Future<void> updateNote(Note note) async {
    final entries = _box.toMap();
    final key = entries.keys.firstWhere(
      (k) => entries[k]?.id == note.id,
      orElse: () => null,
    );
    if (key != null) {
      await _box.put(key, note);
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    final entries = _box.toMap();
    final key = entries.keys.firstWhere(
      (k) => entries[k]?.id == id,
      orElse: () => null,
    );
    if (key != null) {
      await _box.delete(key);
    }
  }

  @override
  Future<void> saveNotes(List<Note> notes) async {
    for (var note in notes) {
      await _box.add(note);
    }
  }
}
