import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:secure_notes/app/config/utils/random_color_generator.dart';
import 'package:secure_notes/app/theme/app_theme.dart';
import '../bloc/note_bloc.dart';
import 'add_note_view.dart';
import 'note_detail_view.dart';

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
    // initially load local notes only
    context.read<NoteBloc>().add(LoadLocalNotes());
  }

  void _navigateToAddNote() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddNoteView()))
        .then((_) => context.read<NoteBloc>().add(LoadLocalNotes()));
  }

  void _onNavTapped(int index) {
    setState(() => _selectedTab = index);
    // load only the selected tab
    if (index == 0) {
      context.read<NoteBloc>().add(LoadLocalNotes());
    } else {
      context.read<NoteBloc>().add(LoadRemoteNotes());
    }
  }

  Widget _buildNoteTile(Note note, bool isLocal) {
    final color = _noteColors.putIfAbsent(
      note.id.toString(),
      getRandomPastelColor,
    );
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(
              MaterialPageRoute(
                builder:
                    (_) => NoteDetailsView(
                      note: note,
                      isLocal: isLocal,
                      accentColor: color,
                    ),
              ),
            )
            .then((_) {
              if (isLocal) context.read<NoteBloc>().add(LoadLocalNotes());
            });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  _relativeDate(note),
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(width: 6),
                Icon(Icons.brightness_1, size: 4, color: Colors.white70),
                const SizedBox(width: 6),
                Text(
                  isLocal ? 'Drafts' : 'folio',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const Spacer(),
                Icon(Icons.edit, color: Colors.white70, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildBody() {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        List<Note> notes = [];
        bool loading = false;

        if (_selectedTab == 0) {
          if (state is LocalNotesLoading) loading = true;
          if (state is LocalNotesLoaded) notes = state.notes;
        } else {
          if (state is RemoteNotesLoading) loading = true;
          if (state is RemoteNotesLoaded) notes = state.notes;
        }

        if (loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (notes.isEmpty) {
          return Center(
            child: Text(
              _selectedTab == 0
                  ? 'No secure notes yet.'
                  : 'No remote notes available.',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        return GridView.builder(
          // padding: const EdgeInsets.only(bottom: 80),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: notes.length,
          itemBuilder:
              (_, idx) => _buildNoteTile(notes[idx], _selectedTab == 0),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.black,
        elevation: 10,
        title: Text(
          'Secure Notes',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: AppTheme.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(child: _buildBody()),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1F1F1F),
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
}
