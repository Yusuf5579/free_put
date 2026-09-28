import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:free_put/src/features/home/cubit/home_cubit.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

/// "N files" label shown next to the Recent files header.
class RecentFilesCount extends StatelessWidget {
  const RecentFilesCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Text(
          state.status == HomeStatus.success
              ? '${state.data.length} files'
              : '',
          key: ValueKey(state.data.length),
          style: GoogleFonts.inter(fontSize: 13, color: AppColors.slate),
        ),
      ),
    );
  }
}
