import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/features/files/cubit/folder_cubit.dart';
import 'package:free_put/src/features/files/cubit/folder_state.dart';
import 'package:free_put/src/features/files/screens/folder_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeFolders extends StatefulWidget {
  const HomeFolders({super.key});

  @override
  State<HomeFolders> createState() => _HomeFoldersState();
}

class _HomeFoldersState extends State<HomeFolders> {
  final List<Map<String, dynamic>> colors = [
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
        } else if (state.status == FolderStatus.success) {
          return state.fileTypes.isEmpty
              ? SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 15,
                    children: [
                      Text(
                        'Filelar yuklanmagan',
                        style: GoogleFonts.montserrat(fontSize: 20),
                      ),
                      LoadingAnimationWidget.bouncingBall(
                        color: Colors.black,
                        size: 30,
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: state.fileTypes.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    mainAxisExtent: 158,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FolderScreen(
                              filename: state.fileTypes.toList()[index],
                              files: state.files!,
                              colors: colors[index],
                            ),
                          ),
                        );
                      },
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
                                    color: colors[index]['back'],

                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: .center,
                                  child: SvgPicture.asset(
                                    Assets.icons.file,
                                    colorFilter: ColorFilter.mode(
                                      colors[index]['in'],
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.more_vert),
                                ),
                              ],
                            ),
                            SizedBox(height: 14),
                            Text(
                              state.fileTypes.toList()[index],
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: .w500,
                                color: Color(0xFF1A1C1B),
                              ),
                            ),
                            Spacer(),
                            Row(
                              spacing: 5,
                              children: [
                                Text(
                                  "${state.files!.length}",

                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: .w400,
                                    color: Color(0xFF44474A),
                                  ),
                                ),
                                Text(
                                  '•',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: .w400,
                                    color: Color(0xFF44474A),
                                  ),
                                ),
                                Text(
                                  '2 kun oldin',

                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: .w400,
                                    color: Color(0xFF44474A),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        } else {
          return Center(child: Text('Try again'));
        }
      },
    );
  }
}
