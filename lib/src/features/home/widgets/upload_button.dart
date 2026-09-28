import 'package:flutter/material.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pill that collapses to a circle once the list is scrolled, and whose
/// plus turns into a close mark while the upload sheet is open.
class UploadButton extends StatelessWidget {
  const UploadButton({
    super.key,
    required this.expanded,
    required this.open,
    required this.onPressed,
  });

  final bool expanded;
  final bool open;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 280);
    return Semantics(
      button: true,
      label: 'Upload a file',
      child: Material(
        color: AppColors.ink,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: AnimatedSize(
            duration: duration,
            curve: Curves.easeOutCubic,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: .symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    AnimatedRotation(
                      turns: open ? 0.125 : 0,
                      duration: duration,
                      curve: Curves.easeOutBack,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                    if (expanded) ...[
                      SizedBox(width: 8),
                      Padding(
                        padding: .only(right: 6),
                        child: Text(
                          'Upload',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: .w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
