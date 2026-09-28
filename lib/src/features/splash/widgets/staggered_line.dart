import 'package:flutter/material.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// A tagline line that fades and rises in, driven by [animation].
class StaggeredLine extends StatelessWidget {
  const StaggeredLine({super.key, required this.animation, required this.text});

  final Animation<double> animation;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: AppColors.slate,
            ),
          ),
        ),
      ),
    );
  }
}
