import 'package:flutter/material.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// White rounded row showing a file's icon and name.
class FileTile extends StatelessWidget {
  const FileTile({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(16),
      ),
      contentPadding: .symmetric(horizontal: 10),
      tileColor: Colors.white,
      title: Text(
        name,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: .w500,
          color: AppColors.ink,
        ),
      ),
      leading: Image(image: AssetImage(Assets.images.pdf.path), height: 40),
    );
  }
}
