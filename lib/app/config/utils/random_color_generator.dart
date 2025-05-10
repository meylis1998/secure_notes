import 'dart:math';

import 'package:flutter/material.dart';

Color getRandomPastelColor() {
  final random = Random();
  return Color.fromARGB(
    255,
    200 + random.nextInt(56),
    200 + random.nextInt(56),
    200 + random.nextInt(56),
  );
}
