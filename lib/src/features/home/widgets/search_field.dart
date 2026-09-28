import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Rounded search input; swaps the voice icon for dots while [loading].
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.loading,
    required this.onChanged,
  });

  final bool loading;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.2),
      borderRadius: BorderRadius.circular(50),
    );

    return TextField(
      cursorColor: AppColors.sage,
      style: GoogleFonts.inter(fontSize: 15, color: AppColors.ink),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Find files',
        hintStyle: GoogleFonts.inter(fontSize: 15, color: AppColors.slate),
        contentPadding: .symmetric(vertical: 16),
        prefixIconConstraints: BoxConstraints(maxHeight: 17),
        prefixIcon: Padding(
          padding: .only(left: 20, right: 10),
          child: SvgPicture.asset(Assets.icons.search),
        ),
        suffixIconConstraints: BoxConstraints(minHeight: 22),
        suffixIcon: loading
            ? Padding(
                padding: .only(right: 15),
                child: LoadingAnimationWidget.waveDots(
                  color: Colors.black,
                  size: 20,
                ),
              )
            : Padding(
                padding: .only(right: 20, left: 10),
                child: SvgPicture.asset(Assets.icons.voice),
              ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: border(AppColors.line),
        focusedBorder: border(AppColors.sage),
      ),
    );
  }
}
