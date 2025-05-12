import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:secure_notes/app/config/utils/random_color_generator.dart';
import 'package:secure_notes/app/theme/app_theme.dart';
import 'package:secure_notes/home/view/note_detail_view.dart';
import '../bloc/note_bloc.dart';
import 'add_note_view.dart';
import 'widgets/empty_state.dart';
import 'widgets/error_state.dart';
import 'widgets/notes_grid.dart';

/// Main HomeView widget with navigation between local and remote notes
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _searchController = TextEditingController();
  final Map<String, Color> _noteColors = {};
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() {
    context.read<NoteBloc>().add(LoadLocalNotes());

    context.read<NoteBloc>().add(LoadRemoteNotes());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddNoteView()),
    ).then((_) => context.read<NoteBloc>().add(LoadLocalNotes()));
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);
    _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      LocalNotesTab(noteColors: _noteColors, onAddNote: _navigateToAddNote),
      RemoteNotesTab(noteColors: _noteColors),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_selectedIndex]),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_download),
            label: 'Remote',
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying local notes with BlocConsumer
class LocalNotesTab extends StatelessWidget {
  final Map<String, Color> noteColors;
  final VoidCallback onAddNote;

  const LocalNotesTab({
    required this.noteColors,
    required this.onAddNote,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteBloc, NoteState>(
      listenWhen:
          (prev, curr) =>
              curr is NoteActionSuccess || curr is NoteActionFailure,
      listener: (context, state) {
        if (state is NoteActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is NoteActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      buildWhen:
          (prev, curr) =>
              curr is LocalNotesLoading ||
              curr is LocalNotesLoaded ||
              curr is LocalNotesError,
      builder: (context, state) {
        if (state is LocalNotesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LocalNotesLoaded) {
          final notes = state.notes;
          if (notes.isEmpty) {
            return EmptyState(
              message: 'No secure notes yet.',
              actionLabel: 'Add Note',
              onAction: onAddNote,
            );
          }
          return NotesGrid(
            notes: notes,
            noteColors: noteColors,
            onTap: (note) => _openNoteDetails(context, note, true),
            onDelete: (note) => _deleteLocalNote(context, note),
          );
        } else if (state is LocalNotesError) {
          return ErrorState(
            message: state.message,
            onRetry: () => context.read<NoteBloc>().add(LoadLocalNotes()),
          );
        }
        return const Center(child: Text('Click + to add notes'));
      },
    );
  }

  void _openNoteDetails(BuildContext context, Note note, bool isLocal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => NoteDetailsView(
              note: note,
              isLocal: isLocal,
              color: noteColors.putIfAbsent(
                note.id.toString(),
                getRandomPastelColor,
              ),
            ),
      ),
    ).then((_) {
      if (isLocal) context.read<NoteBloc>().add(LoadLocalNotes());
    });
  }

  void _deleteLocalNote(BuildContext context, Note note) {
    context.read<NoteBloc>().add(DeleteLocalNote(note.id));
  }
}

/// Widget for displaying remote notes with BlocBuilder
class RemoteNotesTab extends StatelessWidget {
  final Map<String, Color> noteColors;

  const RemoteNotesTab({required this.noteColors, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      buildWhen:
          (prev, curr) =>
              curr is RemoteNotesLoading ||
              curr is RemoteNotesLoaded ||
              curr is RemoteNotesError,
      builder: (context, state) {
        if (state is RemoteNotesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RemoteNotesLoaded) {
          return NotesGrid(
            notes: state.notes,
            noteColors: noteColors,
            onTap: (note) => _openNoteDetails(context, note),
          );
        } else if (state is RemoteNotesError) {
          return ErrorState(
            message: 'Error occurred',
            onRetry: () => context.read<NoteBloc>().add(LoadRemoteNotes()),
            retryButtonStyle: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.mainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            retryTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.white,
            ),
          );
        }
        return const Center(child: Text('No remote notes available'));
      },
    );
  }

  void _openNoteDetails(BuildContext context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => NoteDetailsView(
              note: note,
              color: noteColors.putIfAbsent(
                note.id.toString(),
                getRandomPastelColor,
              ),
            ),
      ),
    );
  }
}
