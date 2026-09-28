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
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({super.key});

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles>
    with TickerProviderStateMixin {
  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('files').snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator(color: Colors.black);
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
                                      videoTitle: fayl['name'],
                                    ),
                                  ),
                                );
                              } else {
                                launchUrl(
                                  Uri.parse(fayl?['url']),
                                  mode: LaunchMode.inAppBrowserView,
                                );
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(20),
                              child: Slidable(
                                startActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      padding: .zero,
                                      backgroundColor:
                                          CupertinoColors.systemGreen,
                                      foregroundColor: Colors.white,
                                      icon: CupertinoIcons.pencil,
                                      label: 'Edit',
                                      autoClose: false,
                                      onPressed: (slidableContext) {
                                        textController.text =
                                            snap.data!.docs[index]['name'];
                                        final homeCubit = context
                                            .read<HomeCubit>();
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return BlocProvider.value(
                                              value: homeCubit,
                                              child: BlocBuilder<HomeCubit, HomeState>(
                                                builder: (context, state) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                      bottom: MediaQuery.of(
                                                        context,
                                                      ).viewInsets.bottom,
                                                    ),
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                              topLeft:
                                                                  Radius.circular(
                                                                    30,
                                                                  ),
                                                              topRight:
                                                                  Radius.circular(
                                                                    30,
                                                                  ),
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 24.0,
                                                            vertical: 16.0,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        crossAxisAlignment:
                                                            .start,
                                                        children: [
                                                          Center(
                                                            child: Container(
                                                              width: 40,
                                                              height: 4,
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      2.0,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 24.0,
                                                          ),
                                                          const Text(
                                                            'Edit Name',
                                                            style: TextStyle(
                                                              fontSize: 22.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 6.0,
                                                          ),
                                                          Text(
                                                            'Fill the field and tap update button',
                                                            style: TextStyle(
                                                              fontSize: 14.0,
                                                              color: Colors
                                                                  .grey
                                                                  .shade600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 24.0,
                                                          ),
                                                          TextField(
                                                            controller:
                                                                textController,
                                                            style:
                                                                const TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                ),
                                                            decoration: InputDecoration(
                                                              hintText:
                                                                  'New name',
                                                              hintStyle: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                              ),
                                                              filled: true,
                                                              fillColor:
                                                                  const Color(
                                                                    0xFFAFAFAF,
                                                                  ).withOpacity(
                                                                    0.08,
                                                                  ),
                                                              contentPadding:
                                                                  const EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        20.0,
                                                                    vertical:
                                                                        18.0,
                                                                  ),
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16.0,
                                                                    ),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      16.0,
                                                                    ),
                                                                borderSide:
                                                                    const BorderSide(
                                                                      color: Color(
                                                                        0xFF2D3142,
                                                                      ),
                                                                      width:
                                                                          1.5,
                                                                    ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 28.0,
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                double.infinity,
                                                            height: 56.0,
                                                            child: ElevatedButton(
                                                              onPressed: () async {
                                                                final cubit =
                                                                    homeCubit;

                                                                await cubit.editFile(
                                                                  snap
                                                                      .data!
                                                                      .docs[index]
                                                                      .id,
                                                                  textController
                                                                      .text,
                                                                );

                                                                if (cubit
                                                                        .state
                                                                        .status ==
                                                                    HomeStatus
                                                                        .success) {
                                                                  Slidable.of(
                                                                    slidableContext,
                                                                  )?.close();
                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                  toastification.show(
                                                                    context:
                                                                        context,
                                                                    title: Text(
                                                                      "Updated Successfully!",
                                                                    ),
                                                                    type: ToastificationType
                                                                        .success,
                                                                    autoCloseDuration:
                                                                        Duration(
                                                                          seconds:
                                                                              3,
                                                                        ),
                                                                  );
                                                                } else if (cubit
                                                                        .state
                                                                        .status ==
                                                                    HomeStatus
                                                                        .failure) {
                                                                  Slidable.of(
                                                                    slidableContext,
                                                                  )?.close();

                                                                  Navigator.pop(
                                                                    context,
                                                                  );
                                                                  toastification.show(
                                                                    context:
                                                                        context,
                                                                    title: Text(
                                                                      "Something went wrong",
                                                                    ),
                                                                    type: ToastificationType
                                                                        .error,
                                                                    autoCloseDuration:
                                                                        Duration(
                                                                          seconds:
                                                                              3,
                                                                        ),
                                                                  );
                                                                }
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        28.0,
                                                                      ),
                                                                ),
                                                              ),
                                                              child:
                                                                  state.status ==
                                                                      HomeStatus
                                                                          .loading
                                                                  ? CupertinoActivityIndicator(
                                                                      color: Colors
                                                                          .white,
                                                                    )
                                                                  : Text(
                                                                      'Update',
                                                                      style: TextStyle(
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                      ),
                                                                    ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 16.0,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        );
                                        print('STATUS${state.status}');
                                      },
                                    ),
                                  ],
                                ),
                                endActionPane: ActionPane(
                                  motion: ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      flex: 2,
                                      onPressed: (slidableContext) async {
                                        await SharePlus.instance.share(
                                          ShareParams(
                                            uri: Uri.parse(fayl!['url']),
                                          ),
                                        );
                                      },
                                      backgroundColor:
                                          CupertinoColors.activeOrange,
                                      foregroundColor: Colors.white,
                                      icon: CupertinoIcons.share,
                                      label: 'Share',
                                    ),
                                    state.status == HomeStatus.loading
                                        ? Container(
                                            height: .infinity,
                                            width: 80,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 40,
                                              vertical: 40,
                                            ),
                                            decoration: BoxDecoration(
                                              color: CupertinoColors.systemRed,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                bottomRight: Radius.circular(
                                                  20,
                                                ),
                                              ),
                                            ),
                                            child: Center(
                                              child: CupertinoActivityIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : SlidableAction(
                                            flex: 2,
                                            autoClose: false,
                                            onPressed: (slidableContext) async {
                                              final cubit = context
                                                  .read<HomeCubit>();
                                              await cubit.deleteFile(
                                                snap.data!.docs[index].id,
                                                fayl!['fileId'],
                                              );
                                              print(
                                                "STATUS${cubit.state.status}",
                                              );

                                              if (cubit.state.status ==
                                                  HomeStatus.success) {
                                                print("Before toast");
                                                toastification.show(
                                                  context: context,
                                                  title: Text(
                                                    "Deleted Successfully!",
                                                  ),
                                                  type: ToastificationType
                                                      .success,
                                                  autoCloseDuration: Duration(
                                                    seconds: 3,
                                                  ),
                                                );
                                                print("After toast");
                                              } else if (cubit.state.status ==
                                                  HomeStatus.failure) {
                                                toastification.show(
                                                  context: context,
                                                  title: Text(
                                                    "Something went wrong",
                                                  ),
                                                  type:
                                                      ToastificationType.error,
                                                  autoCloseDuration: Duration(
                                                    seconds: 3,
                                                  ),
                                                );
                                              }
                                            },
                                            backgroundColor:
                                                CupertinoColors.systemRed,
                                            foregroundColor: Colors.white,
                                            icon: CupertinoIcons.delete,
                                            label: 'Delete',
                                          ),
                                  ],
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadiusGeometry.circular(
                                      16,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 10,
                                  ),
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
          return Center(child: Text(snap.error.toString()));
        }
      },
    );
  }
}
