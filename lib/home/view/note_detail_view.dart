import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:secure_notes/app/theme/app_theme.dart';
import '../bloc/note_bloc.dart';

class NoteDetailsView extends StatefulWidget {
  final Note note;
  final bool isLocal;
  final Color accentColor;

  const NoteDetailsView({
    super.key,
    required this.note,
    this.isLocal = false,
    required this.accentColor,
  });

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  bool _isEditing = false;
  bool _isSaving = false;
  late Note _currentNote;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
    _titleController = TextEditingController(text: _currentNote.title);
    _bodyController = TextEditingController(text: _currentNote.body);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _toggleEditMode() => setState(() => _isEditing = !_isEditing);

  void _saveChanges() {
    if (_titleController.text.trim().isEmpty ||
        _bodyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Both title and content are required.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    setState(() => _isSaving = true);
    final updated = _currentNote.copyWith(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );
    context.read<NoteBloc>().add(UpdateLocalNote(updated));
  }

  void _deleteNote() {
    // Show confirmation dialog before deleting
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text(
            'Are you sure you want to delete this note? This cannot be undone.',
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
                context.read<NoteBloc>().add(DeleteLocalNote(_currentNote.id));
                // Navigate back after deletion
                Navigator.of(context).pop();
              },
              child: const Text('DELETE', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        backgroundColor: Colors.transparent,

        title: Text(
          'Note details',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions:
            widget.isLocal
                ? [
                  // Only show delete button for local notes
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.delete,
                      color: Colors.white,
                    ),
                    onPressed: _deleteNote,
                  ),
                ]
                : null,
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
            child: BlocConsumer<NoteBloc, NoteState>(
              listenWhen:
                  (previous, current) =>
                      current is NoteActionSuccess ||
                      current is NoteActionFailure ||
                      (current is LocalNotesLoaded && _isSaving),
              listener: (context, state) {
                if (state is NoteActionSuccess) {
                  // Don't navigate back, just show success message
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                } else if (state is NoteActionFailure) {
                  setState(() => _isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                } else if (state is LocalNotesLoaded && _isSaving) {
                  // When notes are reloaded after saving, find our updated note
                  final updatedNote = state.notes.firstWhere(
                    (note) => note.id == _currentNote.id,
                    orElse: () => _currentNote,
                  );

                  // Update our local state with the updated note
                  setState(() {
                    _currentNote = updatedNote;
                    _isSaving = false;
                    _isEditing = false;
                  });
                }
              },
              buildWhen:
                  (previous, current) =>
                      current is LocalNotesLoaded ||
                      (current is LocalNotesLoading && !_isSaving),
              builder: (context, state) {
                if (state is LocalNotesLoading && _isSaving) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: AnimatedCrossFade(
                          firstChild: _buildReadOnly(),
                          secondChild: _buildEditor(),
                          crossFadeState:
                              _isEditing
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: widget.isLocal ? _buildFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      backgroundColor: AppTheme.white,
      onPressed: _isEditing ? _saveChanges : _toggleEditMode,
      child:
          _isSaving
              ? const CircularProgressIndicator(color: AppTheme.black)
              : Icon(
                _isEditing ? Icons.check : Icons.edit,
                color: AppTheme.black,
              ),
    );
  }

  Widget _buildReadOnly() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _currentNote.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _currentNote.body,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.white, fontSize: 20),
        ),
      ],
    );
  }

  Widget _buildEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          autofocus: true,
          controller: _titleController,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Title of your note…',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white54,
              fontSize: 23,
            ),
            border: InputBorder.none,
          ),
        ),
        const Divider(color: AppTheme.white, thickness: 0.5, endIndent: 200),
        TextField(
          controller: _bodyController,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.white, fontSize: 20),
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Your full note goes here…',
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.white,
              fontSize: 20,
            ),
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.white,
              fontSize: 20,
            ),
            border: InputBorder.none,
          ),
        ),
      ],
    );
  }
}

// Helper extension to create copyWith on Note model
extension NoteCopy on Note {
  Note copyWith({String? title, String? body}) => Note(
    userId: userId,
    id: id,
    title: title ?? this.title,
    body: body ?? this.body,
  );
}
