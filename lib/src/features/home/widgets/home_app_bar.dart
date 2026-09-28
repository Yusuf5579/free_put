import 'package:flutter/material.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      titleSpacing: 20,
      actionsPadding: .only(right: 20),
      title: Row(
        children: [
          Image(image: AssetImage(Assets.images.logo.path), height: 26),
          SizedBox(width: 10),
          Text(
            'Aether',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: .w700,
              color: AppColors.ink,
            ),
          ),
          Text(
            '  /  Files',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.slate,
            ),
          ),
        ],
      ),
      actions: [
        CircleAvatar(
          radius: 16,
          backgroundImage: AssetImage(Assets.images.json.path),
        ),
      ],
    );
  }
}
