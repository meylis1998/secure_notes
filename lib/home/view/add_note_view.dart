import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:secure_notes/app/theme/app_theme.dart';
import '../bloc/note_bloc.dart';

class AddNoteView extends StatefulWidget {
  const AddNoteView({super.key});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();
  bool _isSaving = false;

  Widget _buildTitleField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _titleCtrl,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Title of your note…',
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.white, fontSize: 24),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildBodyField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          controller: _bodyCtrl,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppTheme.white,
            height: 1.5,
            fontSize: 18,
          ),
          maxLines: null,
          decoration: InputDecoration(
            hintText: 'Your full note goes here…',
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.white,
              fontSize: 18,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  void _save() {
    if (_titleCtrl.text.trim().isEmpty || _bodyCtrl.text.trim().isEmpty) return;
    setState(() => _isSaving = true);
    final note = Note(
      userId: 1,
      id: 0,
      title: _titleCtrl.text,
      body: _bodyCtrl.text,
    );
    context.read<NoteBloc>().add(AddLocalNote(note));
    context.read<NoteBloc>().add(LoadLocalNotes());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Add note',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.white,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.black,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildTitleField(), _buildBodyField()],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: _isSaving ? null : _save,
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
          // primary: Colors.purpleAccent,
          backgroundColor: AppTheme.white,
        ),
        child: Text(
          '+',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.black, fontSize: 35),
        ),
      ),
    );
  }
}
