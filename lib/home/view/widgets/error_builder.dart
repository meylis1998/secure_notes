// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, this.error});

  final error;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Error: $error'));
  }
}
