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
          color: AppTheme.white,
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteBloc, NoteState>(
      listener: (context, state) {
        if (state is NoteActionSuccess) {
          // first reload the list:
          context.read<NoteBloc>().add(LoadLocalNotes());
          // then pop back to HomeView
          Navigator.of(context).pop();
        }
        if (state is NoteActionFailure) {
          setState(() => _isSaving = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.transparent,
        extendBodyBehindAppBar: true,

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
          backgroundColor: AppTheme.transparent,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1F1F2E), Color(0xFF121214)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_buildTitleField(), _buildBodyField()],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _isSaving ? null : _save,
          backgroundColor: AppTheme.white,
          child: const Icon(Icons.add, color: AppTheme.black),
        ),
      ),
    );
  }
}
