import 'package:flutter/material.dart';

/// Campo de formulário reutilizável
class FormTextField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final int maxLines;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  final String? Function(String?)? validator;

  const FormTextField({
    super.key,
    required this.label,
    this.initialValue,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

/// Botão de ação reutilizável
class ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  const ActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(label),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
        label: Text(label),
      );
    }
  }
}
