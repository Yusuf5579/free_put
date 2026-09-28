import 'package:flutter/material.dart';

class FolderSearchField extends StatelessWidget {
  const FolderSearchField({super.key, this.onChanged});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.black.withValues(alpha: .08)),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search for your file',
          hintStyle: TextStyle(color: Colors.black.withValues(alpha: .4)),
          prefixIcon: const Icon(Icons.search_rounded),
          border: InputBorder.none,
          contentPadding: const .symmetric(vertical: 17),
        ),
      ),
    );
  }
}
