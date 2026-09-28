import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:free_put/src/features/home/widgets/upload_sheet/dashed_border_painter.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dashed tap target that shows either an empty prompt or the picked file.
class DropZone extends StatelessWidget {
  const DropZone({super.key, required this.name, required this.onTap});
  final String? name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final picked = name != null;
    final radius = BorderRadius.circular(20);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: CustomPaint(
          painter: DashedBorderPainter(
            color: picked ? AppColors.sage : AppColors.line,
            radius: 20,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 132,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: picked
                  ? AppColors.mist.withValues(alpha: 0.35)
                  : Colors.transparent,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 0.96, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: picked
                  ? _PickedFile(key: ValueKey(name), name: name!)
                  : const _EmptyDrop(key: ValueKey('empty')),
            ),
          ),
        ),
      ),
    );
  }
}

class _FileGlyph extends StatelessWidget {
  const _FileGlyph();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: AppColors.mist,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: .center,
      child: SvgPicture.asset(
        Assets.icons.file,
        colorFilter: ColorFilter.mode(AppColors.sage, BlendMode.srcIn),
      ),
    );
  }
}

class _EmptyDrop extends StatelessWidget {
  const _EmptyDrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        _FileGlyph(),
        SizedBox(height: 12),
        Text(
          'Choose a file',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: .w500,
            color: AppColors.ink,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Documents, images or videos',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.slate),
        ),
      ],
    );
  }
}

class _PickedFile extends StatelessWidget {
  const _PickedFile({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: 20),
      child: Row(
        children: [
          _FileGlyph(),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: .w500,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tap to choose another',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.slate,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: AppColors.sage),
        ],
      ),
    );
  }
}
