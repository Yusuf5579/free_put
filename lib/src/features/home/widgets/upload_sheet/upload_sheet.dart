import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:free_put/src/features/home/cubit/upload_cubit.dart';
import 'package:free_put/src/features/home/cubit/upload_state.dart';
import 'package:free_put/src/features/home/widgets/upload_sheet/drop_zone.dart';
import 'package:free_put/src/features/home/widgets/upload_sheet/submit_button.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadSheet extends StatelessWidget {
  const UploadSheet({super.key, required this.onUploaded});
  final VoidCallback onUploaded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: .fromLTRB(
        24,
        12,
        24,
        24 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: BlocBuilder<UploadCubit, UploadState>(
        builder: (context, state) {
          final loading = state.status == UploadStatus.loading;
          final picked = state.file != null && state.name != null;

          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              const _DragHandle(),
              SizedBox(height: 24),
              Text(
                'Upload a file',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: .w600,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'It shows up in Recent files once it’s stored.',
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.slate),
              ),
              SizedBox(height: 24),
              DropZone(
                name: picked ? state.name : null,
                onTap: loading
                    ? null
                    : () => context.read<UploadCubit>().fileTanlash(),
              ),
              _UploadError(visible: state.status == UploadStatus.failure),
              SizedBox(height: 20),
              SubmitButton(
                loading: loading,
                onPressed: picked && !loading
                    ? () => context.read<UploadCubit>().fileYuborish(
                        onError: () {},
                        onSuccess: () {
                          Navigator.pop(context);
                          onUploaded();
                        },
                      )
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 4,
        width: 36,
        decoration: BoxDecoration(
          color: AppColors.line,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _UploadError extends StatelessWidget {
  const _UploadError({required this.visible});
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      child: visible
          ? Padding(
              padding: .only(top: 12),
              child: Text(
                'Upload failed. Check your connection, then choose the file again.',
                style: GoogleFonts.inter(fontSize: 13, color: AppColors.error),
              ),
            )
          : SizedBox(width: double.infinity),
    );
  }
}
