import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/features/files/cubit/folder_cubit.dart';
import 'package:free_put/src/features/files/cubit/folder_state.dart';
import 'package:free_put/src/features/files/screens/folder_screen.dart';
import 'package:free_put/src/features/home/widgets/folder_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeFolders extends StatelessWidget {
  const HomeFolders({super.key});

  static const List<Map<String, Color>> _colors = [
    {'back': Color(0xFFCBE5DD), 'in': Color(0xFF506761)},
    {'back': Color(0xFFE9E8E6), 'in': Color(0xFF091015)},
    {'back': Color(0xFFCBE7F5), 'in': Color(0xFF304A56)},
    {'back': Color(0xFFE9E8E6), 'in': Color(0xFF44474A)},
    {'back': Color(0xFFCBE7F5), 'in': Color(0xFF304A56)},
    {'back': Color(0xFFCBE5DD), 'in': Color(0xFF506761)},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderCubit, FolderState>(
      builder: (context, state) {
        if (state.status == FolderStatus.loading) {
          return SizedBox(
            width: double.infinity,
            height: 200,
            child: Center(
              child: LoadingAnimationWidget.stretchedDots(
                color: Colors.black,
                size: 40,
              ),
            ),
          );
        }
        if (state.status != FolderStatus.success) {
          return Center(child: Text('Try again'));
        }
        if (state.fileTypes.isEmpty) return const _NoFolders();

        final types = state.fileTypes.toList();
        return GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: types.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            mainAxisExtent: 158,
          ),
          itemBuilder: (context, index) {
            final colors = _colors[index];
            return FolderCard(
              title: types[index],
              fileCount: state.files!.length,
              background: colors['back']!,
              foreground: colors['in']!,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderScreen(
                    filename: types[index],
                    files: state.files!,
                    colors: colors,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _NoFolders extends StatelessWidget {
  const _NoFolders();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: .center,
        mainAxisSize: .min,
        spacing: 15,
        children: [
          Text(
            'Filelar yuklanmagan',
            style: GoogleFonts.montserrat(fontSize: 20),
          ),
          LoadingAnimationWidget.bouncingBall(color: Colors.black, size: 30),
        ],
      ),
    );
  }
}
