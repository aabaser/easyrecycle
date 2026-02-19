import "package:flutter/material.dart";

import "er_text_field.dart";

class ERSearchBar extends StatelessWidget {
  const ERSearchBar({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.onSearchTap,
    this.dense = false,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchTap;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return ERTextField(
      controller: controller,
      hintText: hintText,
      dense: dense,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      suffixIcon: IconButton(
        icon: const Icon(Icons.search),
        onPressed: onSearchTap,
      ),
    );
  }
}
