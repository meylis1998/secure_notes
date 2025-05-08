import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:models/models.dart';

class NoteListItem extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback? onSave;
  final VoidCallback? onDelete;

  const NoteListItem({
    super.key,
    required this.note,
    required this.onTap,
    this.onSave,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.blue.shade100,
      Colors.green.shade100,
      Colors.amber.shade100,
      Colors.pink.shade100,
      Colors.purple.shade100,
    ];
    final colorIndex = note.userId % colors.length;
    final cardColor = colors[colorIndex];

    if (onDelete != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) => onDelete!(),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: _buildCard(context, cardColor),
        ),
      );
    } else {
      // For remote notes, no slidable
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: _buildCard(context, cardColor),
      );
    }
  }

  Widget _buildCard(BuildContext context, Color cardColor) {
    return Card(
      color: cardColor,
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onSave != null)
                    IconButton(
                      icon: const Icon(Icons.save_alt),
                      onPressed: onSave,
                      tooltip: 'Save locally',
                    ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                note.body,
                style: TextStyle(fontSize: 14.0, color: Colors.grey[800]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User ID: ${note.userId}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                  ),
                  Text(
                    'ID: ${note.id}',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
