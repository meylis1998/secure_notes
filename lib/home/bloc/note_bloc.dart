import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:notes_data_src/notes_data_src.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotesRemoteDataSrc remoteDataSrc;
  final LocalNotesDataSrc localNotesDataSrc;

  NoteBloc({required this.remoteDataSrc, required this.localNotesDataSrc})
    : super(NoteInitial()) {
    // Remote note events
    on<LoadRemoteNotes>(_onLoadRemoteNotes);

    // Local note events
    on<LoadLocalNotes>(_onLoadLocalNotes);
    on<AddLocalNote>(_onAddLocalNote);
    on<UpdateLocalNote>(_onUpdateLocalNote);
    on<DeleteLocalNote>(_onDeleteLocalNote);
    on<SaveRemoteNoteLocally>(_onSaveRemoteNoteLocally);
  }

  Future<void> _onLoadRemoteNotes(
    LoadRemoteNotes event,
    Emitter<NoteState> emit,
  ) async {
    emit(RemoteNotesLoading());
    try {
      final notes = await remoteDataSrc.getRemoteNotes();
      emit(RemoteNotesLoaded(notes));
    } catch (e) {
      emit(RemoteNotesError(e.toString()));
    }
  }

  Future<void> _onLoadLocalNotes(
    LoadLocalNotes event,
    Emitter<NoteState> emit,
  ) async {
    emit(LocalNotesLoading());
    try {
      final notes = await localNotesDataSrc.getNotes();
      // sort newest first:
      notes.sort((a, b) => b.id.compareTo(a.id));
      emit(LocalNotesLoaded(notes));
    } catch (e) {
      emit(LocalNotesError(e.toString()));
    }
  }

  Future<void> _onAddLocalNote(
    AddLocalNote event,
    Emitter<NoteState> emit,
  ) async {
    emit(LocalNotesLoading());
    try {
      await localNotesDataSrc.addNote(event.note);
      final notes = await localNotesDataSrc.getNotes();
      emit(LocalNotesLoaded(notes));
      emit(NoteActionSuccess('Note added successfully'));
    } catch (e) {
      emit(NoteActionFailure('Failed to add note: $e'));
    }
  }

  Future<void> _onUpdateLocalNote(
    UpdateLocalNote event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await localNotesDataSrc.updateNote(event.note);

      emit(NoteActionSuccess('Note updated successfully'));

      add(LoadLocalNotes());
    } catch (e) {
      emit(NoteActionFailure('Failed to update note: $e'));
    }
  }

  Future<void> _onDeleteLocalNote(
    DeleteLocalNote event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await localNotesDataSrc.deleteNote(event.id);

      emit(NoteActionSuccess('Note deleted successfully'));

      add(LoadLocalNotes());
    } catch (e) {
      emit(NoteActionFailure('Failed to delete note: ${e.toString()}'));
    }
  }

  Future<void> _onSaveRemoteNoteLocally(
    SaveRemoteNoteLocally event,
    Emitter<NoteState> emit,
  ) async {
    try {
      await localNotesDataSrc.saveNotes([event.note]);
      emit(NoteActionSuccess('Remote note saved locally'));
      final notes = await localNotesDataSrc.getNotes();
      emit(LocalNotesLoaded(notes));
    } catch (e) {
      emit(NoteActionFailure('Failed to save remote note: ${e.toString()}'));
    }
  }
}
