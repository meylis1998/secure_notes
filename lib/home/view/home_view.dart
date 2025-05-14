import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:models/models.dart';
import 'package:secure_notes/app/theme/app_theme.dart';
import '../bloc/note_bloc.dart';
import 'add_note_view.dart';
import 'widgets/note_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedTab = 0;
  final Map<String, Color> _noteColors = {};

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(LoadLocalNotes());
  }

  void _navigateToAddNote() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddNoteView()))
        .then((_) => context.read<NoteBloc>().add(LoadLocalNotes()));
  }

  void _onNavTapped(int index) {
    setState(() => _selectedTab = index);
    context.read<NoteBloc>().add(
      index == 0 ? LoadLocalNotes() : LoadRemoteNotes(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1) Let the gradient paint behind status bar & AppBar:
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Secure Notes',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1F1F2E), Color(0xFF121214)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        backgroundColor: AppTheme.white,
        child: const Icon(Icons.add, color: AppTheme.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1F1F1F).withOpacity(0.8),
        currentIndex: _selectedTab,
        onTap: _onNavTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
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

  Widget _buildBody() {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        final notes = <Note>[];
        var loading = false;
        if (_selectedTab == 0) {
          loading = state is LocalNotesLoading;
          if (state is LocalNotesLoaded) notes.addAll(state.notes);
        } else {
          loading = state is RemoteNotesLoading;
          if (state is RemoteNotesLoaded) notes.addAll(state.notes);
        }

        if (loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (notes.isEmpty) {
          return Center(
            child: Text(
              _selectedTab == 0
                  ? 'No secure notes yet.'
                  : 'No remote notes available.',
              style: const TextStyle(color: Colors.white70),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 16),
          itemCount: notes.length,
          itemBuilder: (_, i) {
            final note = notes[i];
            final isLocal = _selectedTab == 0;
            return isLocal
                ? _buildNoteItem(note, isLocal)
                : NoteItem(
                  noteColors: _noteColors,
                  context: context,
                  note: note,
                  isLocal: isLocal,
                );
          },
        );
      },
    );
  }

  Widget _buildNoteItem(Note note, bool isLocal) {
    return Slidable(
      key: ValueKey(note.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _showDeleteConfirmation(context, note),
            backgroundColor: AppTheme.red,
            foregroundColor: AppTheme.white,
            borderRadius: BorderRadius.circular(10),
            icon: CupertinoIcons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: NoteItem(
        noteColors: _noteColors,
        context: context,
        note: note,
        isLocal: isLocal,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Delete Note',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${note.title}"?',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                // Add the delete event
                context.read<NoteBloc>().add(DeleteLocalNote(note.id));
              },
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
