import 'dart:convert';
import 'dart:io';

import 'package:models/models.dart';
import 'package:path_provider/path_provider.dart';

import '../encryption_service.dart';

class LocalNotesDataSrc {
  final EncryptionService _encryptionService;
  static const String _fileName = 'secure_notes.json';

  LocalNotesDataSrc({required EncryptionService encryptionService})
    : _encryptionService = encryptionService;

  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<List<Note>> getNotes() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }

      final String encryptedContent = await file.readAsString();
      final String decryptedContent = _encryptionService.decrypt(
        encryptedContent,
      );

      final List<dynamic> jsonList = json.decode(decryptedContent);
      return jsonList.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveNotes(List<Note> notes) async {
    final file = await _localFile;
    final String jsonContent = json.encode(
      notes.map((note) => note.toJson()).toList(),
    );
    final String encryptedContent = _encryptionService.encrypt(jsonContent);

    await file.writeAsString(encryptedContent);
  }

  Future<Note> addNote(Note note) async {
    final notes = await getNotes();

    final int newId =
        notes.isEmpty
            ? 1
            : notes.map((n) => n.id).reduce((max, id) => id > max ? id : max) +
                1;

    final newNote = Note(
      id: note.id == 0 ? newId : note.id,
      userId: note.userId,
      title: note.title,
      body: note.body,
    );

    notes.add(newNote);
    await saveNotes(notes);
    return newNote;
  }

  Future<void> deleteNote(int id) async {
    final notes = await getNotes();
    notes.removeWhere((note) => note.id == id);
    await saveNotes(notes);
  }

  Future<void> updateNote(Note updatedNote) async {
    final notes = await getNotes();
    final index = notes.indexWhere((note) => note.id == updatedNote.id);

    if (index != -1) {
      notes[index] = updatedNote;
      await saveNotes(notes);
    }
  }
}
