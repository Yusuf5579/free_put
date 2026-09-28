import 'package:flutter/material.dart';
import 'package:free_put/src/core/utils/app_colors.dart';

class FolderAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FolderAppBar({super.key, required this.onBack, this.onMore});

  final VoidCallback onBack;
  final VoidCallback? onMore;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.canvas,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 80,
      leading: IconButton(
        onPressed: onBack,
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          iconSize: 20,
        ),
        icon: Icon(Icons.arrow_back),
      ),
      title: Text(
        'Curated spaces',
        style: TextStyle(
          fontSize: 15,
          color: Colors.black.withValues(alpha: .55),
        ),
      ),
      actions: [
        Padding(
          padding: const .only(right: 16),
          child: IconButton(
            onPressed: onMore ?? () {},
            style: IconButton.styleFrom(backgroundColor: Colors.white),
            icon: Icon(Icons.more_vert),
          ),
        ),
      ],
    );
  }
}
