import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/features/home/cubit/home_cubit.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecentFiles extends StatelessWidget {
  RecentFiles({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == HomeStatus.success) {
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () async {
                    try {
                      launchUrl(Uri.parse(state.data[index]['url']),
                          mode: LaunchMode.platformDefault);
                    } catch (e) {
                      print('Error on launch url $e');
                    }
                  },
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(16),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    tileColor: Colors.white,
                    title: Text(
                      state.data[index]['name'],
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
                    trailing: IconButton(
                        onPressed: () {}, icon: Icon(Icons.more_vert)),
                  ),
                ),
              );
            },
          );
        } else if (state.status == HomeStatus.failure) {
          return Center(
            child: Column(
              children: [
                Card(
                  child: Text(state.errorText ?? 'Xatolik yuzga keldi !'),
                ),
                TextButton(onPressed: () {}, child: Text('Qayta yuklash !'))
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
