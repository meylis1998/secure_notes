// bookmarks_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import '../../home/view/widgets/character_card.dart';
import '../cubit/bookmarks_cubit.dart';

enum SortOption { name, status }

class BookmarksView extends StatefulWidget {
  const BookmarksView({super.key});
  @override
  State<BookmarksView> createState() => _BookmarksViewState();
}

class _BookmarksViewState extends State<BookmarksView> {
  final _listKey = GlobalKey<AnimatedListState>();
  late List<Character> _chars;
  SortOption _sortBy = SortOption.name;

  @override
  void initState() {
    super.initState();
    // start with whatever is already bookmarked
    _chars = List.from(context.read<BookmarksCubit>().state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          PopupMenuButton<SortOption>(
            initialValue: _sortBy,
            onSelected:
                (opt) => setState(() {
                  _sortBy = opt;
                  _applySort();
                }),
            itemBuilder:
                (_) => const [
                  PopupMenuItem(value: SortOption.name, child: Text('By name')),
                  PopupMenuItem(
                    value: SortOption.status,
                    child: Text('By status'),
                  ),
                ],
          ),
        ],
      ),
      body: BlocListener<BookmarksCubit, List<Character>>(
        listener: (context, newList) {
          // handle removals
          for (var oldChar in List<Character>.from(_chars)) {
            if (!newList.any((c) => c.id == oldChar.id)) {
              final index = _chars.indexWhere((c) => c.id == oldChar.id);
              final removedItem = _chars.removeAt(index);
              _listKey.currentState?.removeItem(
                index,
                (ctx, anim) => SizeTransition(
                  sizeFactor: anim,
                  child: CharacterCard(
                    character: removedItem,
                    isFavorite: false,
                    onFavoriteToggle: () {},
                  ),
                ),
                duration: const Duration(milliseconds: 300),
              );
            }
          }
          // handle insertions
          for (var newChar in newList) {
            if (!_chars.any((c) => c.id == newChar.id)) {
              final insertIndex = newList.indexWhere((c) => c.id == newChar.id);
              _chars.insert(insertIndex, newChar);
              _listKey.currentState?.insertItem(
                insertIndex,
                duration: const Duration(milliseconds: 300),
              );
            }
          }
        },
        child:
            _chars.isEmpty
                ? const Center(child: Text('No bookmarked item'))
                : AnimatedList(
                  key: _listKey,
                  initialItemCount: _chars.length,
                  itemBuilder: (ctx, index, anim) {
                    final character = _chars[index];
                    return SizeTransition(
                      sizeFactor: anim,
                      child: CharacterCard(
                        character: character,
                        isFavorite: true,
                        onFavoriteToggle: () {
                          // trigger the cubit, which fires the listener above
                          context.read<BookmarksCubit>().toggle(character);
                        },
                      ),
                    );
                  },
                ),
      ),
    );
  }

  void _applySort() {
    setState(() {
      _chars.sort((a, b) {
        switch (_sortBy) {
          case SortOption.name:
            return a.name.compareTo(b.name);
          case SortOption.status:
            return a.status.compareTo(b.status);
        }
      });
    });
  }
}
