// bookmarks_view.dart

import 'package:flutter/material.dart';

enum SortOption { name, status }

class LocalNotes extends StatefulWidget {
  const LocalNotes({super.key});
  @override
  State<LocalNotes> createState() => _LocalNotesState();
}

class _LocalNotesState extends State<LocalNotes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('Local Notes')));
  }
}
