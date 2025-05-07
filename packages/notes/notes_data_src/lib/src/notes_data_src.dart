import 'package:models/models.dart';

abstract class NotesDataSrc {
  Future<List<Note>> getNotes({required String token});
}
