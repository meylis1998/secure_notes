import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../bloc/note_bloc.dart';

class NoteDetailsView extends StatefulWidget {
  final Note note;
  final bool isLocal;
  final Color color;

  const NoteDetailsView({
    super.key,
    required this.note,
    this.isLocal = false,
    required this.color,
  });

  @override
  State<NoteDetailsView> createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends State<NoteDetailsView> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  bool _isEditing = false;
  bool _isLocal = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _bodyController = TextEditingController(text: widget.note.body);
    _isLocal = widget.isLocal;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title and content cannot be empty'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final updatedNote = Note(
      id: widget.note.id,
      userId: widget.note.userId,
      title: _titleController.text,
      body: _bodyController.text,
    );

    context.read<NoteBloc>().add(UpdateLocalNote(updatedNote));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Note' : 'Note Details'),
        backgroundColor: widget.color,
        actions: [
          if (_isLocal)
            IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
              onPressed: _isEditing ? _saveChanges : _toggleEditMode,
            ),
        ],
      ),
      body: BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteActionSuccess) {
            setState(() {
              _isSaving = false;
              if (_isEditing) _isEditing = false;
            });
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is NoteActionFailure) {
            setState(() {
              _isSaving = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _isEditing ? _buildEditForm() : _buildReadOnlyView(widget.color),
              if (_isSaving)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16.0),
        TextFormField(
          controller: _bodyController,
          decoration: const InputDecoration(
            labelText: 'Content',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
          maxLines: 15,
          minLines: 5,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text('SAVE CHANGES'),
        ),
      ],
    );
  }

  Widget _buildReadOnlyView(Color backgroundColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // instead of widget.note.title
        Text(
          _titleController.text,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            // instead of widget.note.body
            child: Text(
              _bodyController.text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        // userId and id never change, so you can still use widget.note for those
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          color: backgroundColor.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('User ID: ${widget.note.userId}'),
                Text('Note ID: ${widget.note.id}'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
