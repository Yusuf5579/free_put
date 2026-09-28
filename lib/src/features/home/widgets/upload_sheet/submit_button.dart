import 'package:flutter/material.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// Full-width button that shrinks into a spinner while the upload runs.
class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final active = onPressed != null || loading;
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          height: 54,
          width: loading ? 54 : constraints.maxWidth,
          decoration: BoxDecoration(
            color: active ? AppColors.ink : AppColors.line,
            borderRadius: BorderRadius.circular(27),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const StadiumBorder(),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: loading
                      ? const SizedBox.square(
                          key: ValueKey('loading'),
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Upload',
                          key: const ValueKey('label'),
                          maxLines: 1,
                          overflow: .clip,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: .w500,
                            color: active ? Colors.white : AppColors.slate,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
