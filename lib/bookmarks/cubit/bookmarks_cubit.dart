import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:models/models.dart';

class BookmarksCubit extends Cubit<List<Character>> {
  final Box<String> _box;

  /// Static helper: only single‐object JSON survives.
  static List<Character> _loadFrom(Box<String> box) {
    return box.values
        .map((jsonStr) {
          final decoded = jsonDecode(jsonStr);
          if (decoded is Map<String, dynamic>) {
            return Character.fromJson(decoded);
          }
          // skip any non-object entry
          return null;
        })
        .whereType<Character>()
        .toList();
  }

  /// Initialize _box, then call super with the initial list.
  BookmarksCubit(Box<String> box) : _box = box, super(_loadFrom(box));

  /// Toggle bookmark and re‐emit via the same loader
  void toggle(Character c) {
    final key = c.id.toString();
    if (_box.containsKey(key)) {
      _box.delete(key);
    } else {
      _box.put(key, jsonEncode(c.toJson()));
    }
    emit(_loadFrom(_box));
  }
}
