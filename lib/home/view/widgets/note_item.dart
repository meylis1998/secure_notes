import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../../app/config/utils/random_color_generator.dart';
import '../../bloc/note_bloc.dart';
import '../note_detail_view.dart';

class NoteItem extends StatelessWidget {
  const NoteItem({
    super.key,
    required Map<String, Color> noteColors,
    required this.context,
    required this.note,
    required this.isLocal,
  }) : _noteColors = noteColors;

  final Map<String, Color> _noteColors;
  final BuildContext context;
  final Note note;
  final bool isLocal;

  @override
  Widget build(BuildContext context) {
    final accent = _noteColors.putIfAbsent(
      note.id.toString(),
      getRandomPastelColor,
    );

    return GestureDetector(
      onTap:
          () => Navigator.of(context)
              .push(
                MaterialPageRoute(
                  builder:
                      (_) => NoteDetailsView(
                        note: note,
                        isLocal: isLocal,
                        accentColor: accent,
                      ),
                ),
              )
              .then((_) {
                if (isLocal) context.read<NoteBloc>().add(LoadLocalNotes());
              }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            // 4) Frosted-glass blur:
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                // 5) Semi-transparent + accent gradient:
                gradient: LinearGradient(
                  colors: [accent.withOpacity(0.20), accent.withOpacity(0.08)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _relativeDate(note),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.brightness_1,
                        size: 4,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 6),
                      const Spacer(),
                      const Icon(Icons.edit, color: Colors.white70, size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _relativeDate(Note note) {
  final now = DateTime.now();
  final created = DateTime.fromMillisecondsSinceEpoch(
    now.millisecondsSinceEpoch - (note.id * 86400000),
  );
  final diff = now.difference(created).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  return '${created.day}.${created.month}.${created.year}';
}
