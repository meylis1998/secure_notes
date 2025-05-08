import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:secure_notes/home/view/note_detail_view.dart';

import '../../widgets/note_list_item.dart';
import '../bloc/note_bloc.dart';
import 'add_note.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load initial data
    _loadNotes();
  }

  void _loadNotes() {
    context.read<NoteBloc>().add(LoadRemoteNotes());
    // context.read<NoteBloc>().add(LoadLocalNotes());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddNote() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNoteView()),
    ).then((_) {
      // Refresh local notes when returning from add note page
      context.read<NoteBloc>().add(LoadLocalNotes());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hey there,',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Secure Notes',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.lock, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.grey.shade100
                          : Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Tab bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TabBar(
                controller: _tabController,
                tabs: const [Tab(text: 'Notes'), Tab(text: 'Remote')],
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
                dividerHeight: 0,
              ),
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildLocalNotesTab(), _buildRemoteNotesTab()],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.grid_view), onPressed: () {}),
            const SizedBox(width: 48),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemoteNotesTab() {
    return BlocBuilder<NoteBloc, NoteState>(
      buildWhen:
          (previous, current) =>
              current is RemoteNotesLoading ||
              current is RemoteNotesLoaded ||
              current is RemoteNotesError,
      builder: (context, state) {
        if (state is RemoteNotesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RemoteNotesLoaded) {
          final notes = state.notes;
          return _buildNotesList(
            notes,
            onTap: (note) => _openNoteDetails(note),
            onSave: (note) => _saveRemoteNoteLocally(note),
          );
        } else if (state is RemoteNotesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<NoteBloc>().add(LoadRemoteNotes()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('No remote notes available'));
      },
    );
  }

  Widget _buildLocalNotesTab() {
    return BlocConsumer<NoteBloc, NoteState>(
      listenWhen:
          (previous, current) =>
              current is NoteActionSuccess || current is NoteActionFailure,
      listener: (context, state) {
        if (state is NoteActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is NoteActionFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      buildWhen:
          (previous, current) =>
              current is LocalNotesLoading ||
              current is LocalNotesLoaded ||
              current is LocalNotesError,
      builder: (context, state) {
        if (state is LocalNotesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LocalNotesLoaded) {
          final notes = state.notes;
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No secure notes yet.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _navigateToAddNote,
                    child: const Text('Add Note'),
                  ),
                ],
              ),
            );
          }
          return _buildNotesList(
            notes,
            onTap: (note) => _openNoteDetails(note, isLocal: true),
            onDelete: (note) => _deleteLocalNote(note),
          );
        } else if (state is LocalNotesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => context.read<NoteBloc>().add(LoadLocalNotes()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const Center(child: Text('No secure notes available'));
      },
    );
  }

  Widget _buildNotesList(
    List<Note> notes, {
    required Function(Note) onTap,
    Function(Note)? onSave,
    Function(Note)? onDelete,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadNotes();
        return Future.delayed(const Duration(milliseconds: 500));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return NoteListItem(
            note: note,
            onTap: () => onTap(note),
            onSave: onSave != null ? () => onSave(note) : null,
            onDelete: onDelete != null ? () => onDelete(note) : null,
          );
        },
      ),
    );
  }

  void _openNoteDetails(Note note, {bool isLocal = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailsView(note: note, isLocal: isLocal),
      ),
    ).then((_) {
      if (isLocal) {
        context.read<NoteBloc>().add(LoadLocalNotes());
      }
    });
  }

  void _saveRemoteNoteLocally(Note note) {
    context.read<NoteBloc>().add(SaveRemoteNoteLocally(note));
  }

  void _deleteLocalNote(Note note) {
    context.read<NoteBloc>().add(DeleteLocalNote(note.id));
  }
}
