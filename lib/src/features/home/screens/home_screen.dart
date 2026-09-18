import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/features/home/cubit/upload_cubit.dart';
import 'package:free_put/src/features/home/cubit/upload_state.dart';
import 'package:free_put/src/features/home/widgets/home_folders.dart';
import 'package:free_put/src/features/home/widgets/recent_files.dart';
import 'package:free_put/src/features/home/widgets/type_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const new({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9F9),
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Color(0xFFFFFFFF),
        actionsPadding: .only(right: 20),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(Assets.icons.search),
          ),
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(Assets.images.json.path),
          ),
        ],
        leadingWidth: 60,
        leading: Padding(
          padding: .only(left: 20),
          child: Image(image: AssetImage(Assets.images.logo.path)),
        ),
        title: Row(
          children: [
            Text(
              'Aether  ',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                color: Color(0xFF1A1C1B),
                fontWeight: .bold,
              ),
            ),
            Text(
              '/  Files',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Color(0xFF44474A),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: .symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                'WORKSPACE',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: .bold,
                  color: Color(0xFF4C635D),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Text(
                      'Good morning, Elena',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: .w500,
                        color: Color(0xFF1A1C1B),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    width: 109,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFCBE5DD),
                    ),
                    padding: .symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFF4C635D),
                        ),
                        SizedBox(
                          width: 70,
                          child: Text(
                            'Vault Synced',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: .w500,
                              color: Color(0xFF506761),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Find Files',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: .w400,
                    color: Color(0xFF44474A),
                  ),
                  prefixIconConstraints: BoxConstraints(maxHeight: 17),
                  prefixIcon: Padding(
                    padding: .only(left: 20, right: 5),
                    child: SvgPicture.asset(Assets.icons.search),
                  ),
                  suffixIcon: Padding(
                    padding: .only(right: 20, left: 5),

                    child: SvgPicture.asset(Assets.icons.voice),
                  ),
                  suffixIconConstraints: BoxConstraints(minHeight: 22),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(spacing: 10, children: [TypeButton()]),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Curated Spaces',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: .w500,
                      color: Color(0xFF1A1C1B),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View all',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: .w500,
                        color: Color(0xFF4C635D),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              HomeFolders(),
              SizedBox(height: 20),
              RecentFiles(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: .only(bottom: 25, right: 25),
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return BlocBuilder<UploadCubit, UploadState>(
                  builder: (context, state) {
                    return CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Stack(
                        children: [
                          Container(
                            height: state.status != UploadStatus.failure
                                ? 225
                                : 250,
                            width: 300,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.all(20),
                            alignment: .topCenter,
                            child: Column(
                              children: [
                                Text(
                                  'Upload File',
                                  style: GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: .w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 50,
                                  width: .infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      elevation: 0,
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        235,
                                        233,
                                        233,
                                      ).withValues(alpha: .4),
                                    ),

                                    onPressed: () {
                                      context.read<UploadCubit>().fileTanlash();
                                    },
                                    child: Text(
                                      state.status == UploadStatus.success
                                          ? state.name!
                                          : 'Choose a document or file',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: .w400,
                                        color: Color(0xFF44474A),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  height: 50,
                                  width: .infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      backgroundColor:
                                          CupertinoColors.activeBlue,
                                    ),
                                    onPressed:
                                        state.status != UploadStatus.success
                                        ? null
                                        : () {
                                            context
                                                .read<UploadCubit>()
                                                .fileYuborish();
                                            Navigator.pop(context);
                                            context.read<UploadCubit>().reset();
                                            Toastification().show(
                                              autoCloseDuration: Duration(
                                                seconds: 2,
                                              ),
                                              context: context,
                                              type: ToastificationType.success,
                                              title: Text(
                                                'Uploaded Successfully!',
                                              ),
                                            );
                                          },
                                    child: Text(
                                      'Upload',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: .w400,
                                        color:
                                            state.status == UploadStatus.success
                                            ? Colors.white
                                            : Color(0xFF44474A),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                state.status == UploadStatus.failure
                                    ? Text(
                                        'Error on uploading file try again !',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 5,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close, size: 16,),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(60),
          ),
          backgroundColor: Colors.black,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
