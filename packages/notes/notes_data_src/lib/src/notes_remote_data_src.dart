import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:models/models.dart';
import 'package:notes_data_src/notes_data_src.dart';

class NotesRemoteDataSrc implements NotesDataSrc {
  final DioClientHandler _dioClientHandler;

  const NotesRemoteDataSrc({required DioClientHandler dioClientHandler})
    : _dioClientHandler = dioClientHandler;

  @override
  Future<List<Note>> getRemoteNotes() async {
    try {
      final response = await _dioClientHandler.get(path: '/posts');

      return Note.listFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
