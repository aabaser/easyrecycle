import "package:flutter/material.dart";

class ERTextField extends StatelessWidget {
  const ERTextField({
    super.key,
    this.controller,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.maxLines = 1,
    this.dense = false,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        isDense: dense,
        contentPadding: dense && maxLines == 1
            ? const EdgeInsets.symmetric(horizontal: 14, vertical: 12)
            : null,
        hintText: hintText,
        labelText: labelText,
        suffixIcon: suffixIcon,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
