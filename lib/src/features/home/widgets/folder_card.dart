import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderCard extends StatelessWidget {
  const FolderCard({
    super.key,
    required this.title,
    required this.fileCount,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String title;
  final int fileCount;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final metaStyle = GoogleFonts.inter(
      fontSize: 11,
      fontWeight: .w400,
      color: AppColors.slate,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 144,
        width: 171,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: .all(18),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: .center,
                  child: SvgPicture.asset(
                    Assets.icons.file,
                    colorFilter: ColorFilter.mode(foreground, BlendMode.srcIn),
                  ),
                ),
                Spacer(),
                IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
              ],
            ),
            SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: .w500,
                color: AppColors.ink,
              ),
            ),
            Spacer(),
            Row(
              spacing: 5,
              children: [
                Text('$fileCount', style: metaStyle),
                Text('•', style: metaStyle),
                Text('2 kun oldin', style: metaStyle),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
