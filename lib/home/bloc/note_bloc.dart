import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:notes_repo/notes_repo.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NotesRepo repository;

  NoteBloc({required this.repository}) : super(NoteInitial()) {
    // Remote note events
    on<LoadRemoteNotes>(_onLoadRemoteNotes);

    // Local note events
    // on<LoadLocalNotes>(_onLoadLocalNotes);
    // on<AddLocalNote>(_onAddLocalNote);
    // on<UpdateLocalNote>(_onUpdateLocalNote);
    // on<DeleteLocalNote>(_onDeleteLocalNote);
    // on<SaveRemoteNoteLocally>(_onSaveRemoteNoteLocally);
  }

  Future<void> _onLoadRemoteNotes(
    LoadRemoteNotes event,
    Emitter<NoteState> emit,
  ) async {
    emit(RemoteNotesLoading());
    try {
      final notes = await repository.getRemoteNotes();
      emit(RemoteNotesLoaded(notes));
    } catch (e) {
      emit(RemoteNotesError(e.toString()));
    }
  }

  // Future<void> _onLoadLocalNotes(
  //   LoadLocalNotes event,
  //   Emitter<NoteState> emit,
  // ) async {
  //   emit(LocalNotesLoading());
  //   try {
  //     final notes = await repository.getLocalNotes();
  //     emit(LocalNotesLoaded(notes));
  //   } catch (e) {
  //     emit(LocalNotesError(e.toString()));
  //   }
  // }

  // Future<void> _onAddLocalNote(
  //   AddLocalNote event,
  //   Emitter<NoteState> emit,
  // ) async {
  //   try {
  //     await repository.saveLocalNote(event.note);
  //     final notes = await repository.getLocalNotes();
  //     emit(LocalNotesLoaded(notes));
  //     emit(NoteActionSuccess('Note added successfully'));
  //   } catch (e) {
  //     emit(NoteActionFailure('Failed to add note: ${e.toString()}'));
  //   }
  // }

  // Future<void> _onUpdateLocalNote(
  //   UpdateLocalNote event,
  //   Emitter<NoteState> emit,
  // ) async {
  //   try {
  //     await repository.updateLocalNote(event.note);
  //     final notes = await repository.getLocalNotes();
  //     emit(LocalNotesLoaded(notes));
  //     emit(NoteActionSuccess('Note updated successfully'));
  //   } catch (e) {
  //     emit(NoteActionFailure('Failed to update note: ${e.toString()}'));
  //   }
  // }

  // Future<void> _onDeleteLocalNote(
  //   DeleteLocalNote event,
  //   Emitter<NoteState> emit,
  // ) async {
  //   try {
  //     await repository.deleteLocalNote(event.id);
  //     final notes = await repository.getLocalNotes();
  //     emit(LocalNotesLoaded(notes));
  //     emit(NoteActionSuccess('Note deleted successfully'));
  //   } catch (e) {
  //     emit(NoteActionFailure('Failed to delete note: ${e.toString()}'));
  //   }
  // }

  // Future<void> _onSaveRemoteNoteLocally(
  //   SaveRemoteNoteLocally event,
  //   Emitter<NoteState> emit,
  // ) async {
  //   try {
  //     await repository.saveLocalNote(event.note);
  //     emit(NoteActionSuccess('Remote note saved locally'));
  //     final notes = await repository.getLocalNotes();
  //     emit(LocalNotesLoaded(notes));
  //   } catch (e) {
  //     emit(NoteActionFailure('Failed to save remote note: ${e.toString()}'));
  //   }
  // }
}
