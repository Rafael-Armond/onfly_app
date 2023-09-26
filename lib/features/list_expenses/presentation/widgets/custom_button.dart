import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.callback,
  });

  final String text;
  final Color color;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        padding: const EdgeInsets.all(8.0),
        textStyle: const TextStyle(fontSize: 16),
      ),
      onPressed: callback,
      child: Text(text),
    );
  }
}
