import 'package:models/models.dart';
import 'package:notes_data_src/notes_data_src.dart';

class NotesRepo {
  final NotesDataSrc _dataSrc;

  const NotesRepo({required NotesDataSrc dataSrc}) : _dataSrc = dataSrc;

  Future<List<Note>> getRemoteNotes() async {
    return _dataSrc.getRemoteNotes();
  }
}
