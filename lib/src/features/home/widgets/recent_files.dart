import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/features/home/cubit/home_cubit.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';
import 'package:free_put/src/features/video/screens/video_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({super.key});

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('files').snapshots(),
        builder: (context, snap) {
          // * xolatlarni ozi handle

          if (snap.connectionState == ConnectionState.waiting) {
            return CupertinoActivityIndicator(
              color: Colors.black,
            );
          } else if (snap.hasData == true) {
            print('Snap data ${snap.data?.docs}');

            return snap.data?.docs != null && snap.data!.docs.isEmpty
                ? SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Center(child: Text('Malumotlar yoq')),
                  )
                : BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snap.data?.docs.length,
                        itemBuilder: (context, index) {
                          final fayl = snap.data?.docs[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              onTap: () async {
                                if (fayl != null &&
                                    fayl['name']
                                        .toString()
                                        .toLowerCase()
                                        .endsWith('.mp4')) {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (context) => VideoScreen(
                                              url: fayl['url'],
                                              videoTitle: fayl['name'])));
                                } else {
                                  launchUrl(Uri.parse(fayl?['url']),
                                      mode: LaunchMode.inAppBrowserView);
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                      motion: ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                          flex: 2,
                                          onPressed: (context) async {
                                            await SharePlus.instance.share(
                                                ShareParams(
                                                    uri: Uri.parse(
                                                        fayl!['url'])));
                                          },
                                          backgroundColor:
                                              CupertinoColors.activeOrange,
                                          foregroundColor: Colors.white,
                                          icon: CupertinoIcons.share,
                                          label: 'Share',
                                        ),
                                        state.status == HomeStatus.loading
                                            ? Container(
                                                width: 80,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 40,
                                                    vertical: 40),
                                                decoration: BoxDecoration(
                                                    color: CupertinoColors
                                                        .systemRed,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight: Radius
                                                                .circular(20),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    20))),
                                                child: Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                  color: Colors.white,
                                                )))
                                            : SlidableAction(
                                                flex: 2,
                                                autoClose: false,
                                                onPressed: (context) {
                                                  context
                                                      .read<HomeCubit>()
                                                      .deleteFile(
                                                          snap.data!.docs[index]
                                                              .id,
                                                          fayl!['fileId']);
                                                },
                                                backgroundColor:
                                                    CupertinoColors.systemRed,
                                                foregroundColor: Colors.white,
                                                icon: CupertinoIcons.delete,
                                                label: 'Delete',
                                              ),
                                      ]),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(16),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10),
                                    tileColor: Colors.white,
                                    title: Text(
                                      fayl?['name'] ?? 'No name',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1A1C1B),
                                      ),
                                    ),
                                    leading: Image(
                                      image: AssetImage(Assets.images.pdf.path),
                                      height: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
          } else {
            return Center(
              child: Text(snap.error.toString()),
            );
          }
        });
  }
}
