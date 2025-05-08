part of 'note_bloc.dart';

abstract class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class LoadRemoteNotes extends NoteEvent {}

class LoadLocalNotes extends NoteEvent {}

class AddLocalNote extends NoteEvent {
  final Note note;

  const AddLocalNote(this.note);

  @override
  List<Object> get props => [note];
}

class UpdateLocalNote extends NoteEvent {
  final Note note;

  const UpdateLocalNote(this.note);

  @override
  List<Object> get props => [note];
}

class DeleteLocalNote extends NoteEvent {
  final int id;

  const DeleteLocalNote(this.id);

  @override
  List<Object> get props => [id];
}

class SaveRemoteNoteLocally extends NoteEvent {
  final Note note;

  const SaveRemoteNoteLocally(this.note);

  @override
  List<Object> get props => [note];
}
