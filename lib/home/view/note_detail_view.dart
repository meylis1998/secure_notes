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

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _bodyController = TextEditingController(text: widget.note.body);
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
    final updated = widget.note.copyWith(
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
    );
    context.read<NoteBloc>().add(UpdateLocalNote(updated));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.black,
        title: Text(
          'Note details',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: BlocListener<NoteBloc, NoteState>(
            listener: (context, state) {
              if (state is NoteActionSuccess) {
                setState(() {
                  _isSaving = false;
                  _isEditing = false;
                });
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
              }
            },
            child: Column(
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
            ),
          ),
        ),
      ),
      floatingActionButton: widget.isLocal ? _buildFab() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      backgroundColor: AppTheme.white,
      onPressed: _isEditing ? _saveChanges : _toggleEditMode,
      child: Icon(_isEditing ? Icons.check : Icons.edit, color: AppTheme.black),
    );
  }

  Widget _buildReadOnly() {
    return Column(
      children: [
        Text(
          widget.note.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.note.body,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ),
      ],
    );
  }

  Widget _buildEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: 'Title of your note…',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white54,
              fontSize: 24,
            ),
            border: InputBorder.none,
          ),
        ),
        const Divider(color: AppTheme.white, thickness: 0.5, endIndent: 250),
        TextField(
          controller: _bodyController,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.white),
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Your full note goes here…',
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.white,
              fontSize: 25,
            ),
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.white,
              fontSize: 24,
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
