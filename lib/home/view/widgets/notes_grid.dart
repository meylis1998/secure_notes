import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:secure_notes/home/bloc/note_bloc.dart';

import '../../../app/config/utils/random_color_generator.dart';
import '../../../widgets/note_list_item.dart';

class NotesGrid extends StatelessWidget {
  final List<Note> notes;
  final Map<String, Color> noteColors;
  final void Function(Note) onTap;
  final void Function(Note)? onDelete;

  const NotesGrid({
    required this.notes,
    required this.noteColors,
    required this.onTap,
    this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<NoteBloc>().add(LoadRemoteNotes());
        return Future.delayed(const Duration(milliseconds: 500));
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (_, idx) {
          final note = notes[idx];
          return NoteListItem(
            note: note,
            onTap: () => onTap(note),
            onDelete: onDelete != null ? () => onDelete!(note) : null,
            color: noteColors.putIfAbsent(
              note.id.toString(),
              getRandomPastelColor,
            ),
          );
        },
      ),
    );
  }
}
