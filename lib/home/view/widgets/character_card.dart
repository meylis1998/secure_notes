// character_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:models/models.dart';

import '../../../app/theme/app_theme.dart';

class CharacterCard extends StatefulWidget {
  final Character character;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  _CharacterCardState createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: widget.character.image,
            width: 60.w,
            height: 60.h,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(widget.character.name),
        subtitle: Text(
          '${widget.character.status} • ${widget.character.species}',
        ),
        trailing: GestureDetector(
          onTap: () {
            widget.onFavoriteToggle();
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) {
              return FadeTransition(
                opacity: anim,
                child: ScaleTransition(
                  scale: Tween(begin: .5, end: 1.0).animate(anim),
                  child: child,
                ),
              );
            },

            layoutBuilder: (currentChild, previousChildren) {
              // Stack them for smooth crossfade
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
              );
            },
            child: Icon(
              widget.isFavorite
                  ? CupertinoIcons.star_fill
                  : CupertinoIcons.star,
              key: ValueKey(widget.isFavorite),
              color: widget.isFavorite ? AppTheme.mainColor : AppTheme.grey,
              size: 28.sp,
            ),
          ),
        ),
      ),
    );
  }
}
