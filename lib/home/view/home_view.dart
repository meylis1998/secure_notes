import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:models/models.dart';
import 'package:secure_notes/app/theme/app_theme.dart';
import '../bloc/note_bloc.dart';
import 'add_note_view.dart';
import 'widgets/custom_error_widget.dart';
import 'widgets/note_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedTab = 0;
  final Map<String, Color> _noteColors = {};

  // Search controller and query
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(LoadLocalNotes());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    // Clear search when switching tabs
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppTheme.transparent,
      appBar: AppBar(
        backgroundColor: AppTheme.transparent,
        elevation: 0,
        title: Text(
          'Secure Notes',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.white,
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
          SafeArea(
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: AppTheme.white),
                    decoration: InputDecoration(
                      hintText: 'Search notes',
                      hintStyle: const TextStyle(color: Colors.white54),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white54,
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Notes list
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        backgroundColor: AppTheme.white,
        child: const Icon(Icons.add, color: AppTheme.black),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1F1F2E), Color(0xFF121214)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppTheme.transparent,
          elevation: 0,
          currentIndex: _selectedTab,
          onTap: _onNavTapped,
          selectedItemColor: AppTheme.white,
          unselectedItemColor: Colors.white54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_download),
              label: 'Remote',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        final bool isLocalTab = _selectedTab == 0;
        // Loading
        if (isLocalTab && state is LocalNotesLoading ||
            !isLocalTab && state is RemoteNotesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        // Error
        if (isLocalTab && state is LocalNotesError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context.read<NoteBloc>().add(LoadLocalNotes()),
          );
        }
        if (!isLocalTab && state is RemoteNotesError) {
          return CustomErrorWidget(
            message: 'Failed to load remote notes',
            onRetry: () => context.read<NoteBloc>().add(LoadRemoteNotes()),
          );
        }
        // Loaded
        if (state is LocalNotesLoaded || state is RemoteNotesLoaded) {
          final notes =
              state is LocalNotesLoaded
                  ? state.notes
                  : (state as RemoteNotesLoaded).notes;
          // Filter by search query
          final filtered =
              _searchQuery.isEmpty
                  ? notes
                  : notes.where((note) {
                    final q = _searchQuery.toLowerCase();
                    return note.title.toLowerCase().contains(q) ||
                        note.title.toLowerCase().contains(q);
                  }).toList();

          if (filtered.isEmpty) {
            return const Center(
              child: Text(
                'No notes found.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (ctx, i) => buildNoteItem(filtered[i], isLocalTab),
          );
        }
        // Initial/fallback
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildNoteItem(Note note, bool isLocal) {
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
          title: Text(
            'Delete Note',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${note.title}"?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontSize: 17,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'CANCEL',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: AppTheme.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<NoteBloc>().add(DeleteLocalNote(note.id));
              },
              child: Text(
                'DELETE',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.red,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
