import 'package:flutter/material.dart';

/// Folder icon (shared Hero with the home card) plus the title and file count.
class FolderHeader extends StatelessWidget {
  const FolderHeader({
    super.key,
    required this.title,
    required this.fileCount,
    required this.background,
    required this.foreground,
  });

  final String title;
  final int fileCount;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Hero(
          tag: title,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(Icons.folder_rounded, color: foreground, size: 36),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 34,
                  height: 1.1,
                  fontWeight: .w600,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$fileCount files  •  Updated 2 days ago',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: .5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
