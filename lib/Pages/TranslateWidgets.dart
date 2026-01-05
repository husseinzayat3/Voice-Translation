import 'package:flutter/material.dart';

class TranslateHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Translate');
  }
}

class TranslateInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  TranslateInputField({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
    );
  }
}

class TranslateButton extends StatelessWidget {
  final VoidCallback onPressed;

  TranslateButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Translate'),
    );
  }
}
