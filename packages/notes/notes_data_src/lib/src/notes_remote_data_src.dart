import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:models/models.dart';

class NotesRemoteDataSrc {
  final DioClientHandler _dioClientHandler;

  const NotesRemoteDataSrc({required DioClientHandler dioClientHandler})
    : _dioClientHandler = dioClientHandler;

  Future<List<Note>> getRemoteNotes() async {
    try {
      final response = await _dioClientHandler.get(path: '/posts');

      return Note.listFromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}
