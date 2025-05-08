part of 'note_bloc.dart';

abstract class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

class NoteInitial extends NoteState {}

class RemoteNotesLoading extends NoteState {}

class RemoteNotesLoaded extends NoteState {
  final List<Note> notes;

  const RemoteNotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class RemoteNotesError extends NoteState {
  final String message;

  const RemoteNotesError(this.message);

  @override
  List<Object> get props => [message];
}

class LocalNotesLoading extends NoteState {}

class LocalNotesLoaded extends NoteState {
  final List<Note> notes;

  const LocalNotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class LocalNotesError extends NoteState {
  final String message;

  const LocalNotesError(this.message);

  @override
  List<Object> get props => [message];
}

class NoteActionSuccess extends NoteState {
  final String message;

  const NoteActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class NoteActionFailure extends NoteState {
  final String message;

  const NoteActionFailure(this.message);

  @override
  List<Object> get props => [message];
}
