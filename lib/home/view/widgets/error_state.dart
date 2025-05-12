import 'package:flutter/material.dart';

/// Widget for error state with retry button
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final ButtonStyle? retryButtonStyle;
  final TextStyle? retryTextStyle;

  const ErrorState({
    required this.message,
    required this.onRetry,
    this.retryButtonStyle,
    this.retryTextStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            style: retryButtonStyle,
            child: Text('Retry', style: retryTextStyle),
          ),
        ],
      ),
    );
  }
}
