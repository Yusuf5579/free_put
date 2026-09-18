import 'package:flutter/material.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:google_fonts/google_fonts.dart';

class RecentFiles extends StatelessWidget {
  RecentFiles({super.key});

  final List<Map<String, dynamic>> sections = [
    {
      'image': Assets.images.pdf.path,
      'title': 'Brand_Identity_Spec_v3.pdf',
      'name': 'Marcus',
      'time': '32m ago',
      'storage': '14.2 MB',
    },
    {
      'image': Assets.images.json.path,
      'title': 'Design_Tokens_Export.json',
      'name': 'Code',
      'time': 'Yesterday',
      'storage': '120 KB',
    },
    {
      'image': Assets.images.video.path,
      'title': 'Q3_Earnings_Presentation.key',
      'name': 'Keynote',
      'time': '32m ago',
      'storage': '42.0 MB',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: sections.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: .only(bottom: 10),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(16),
            ),
            contentPadding: .symmetric(vertical: 0, horizontal: 10),
            tileColor: Colors.white,
            title: Text(
              sections[index]['title'],
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: .w500,
                color: Color(0xFF1A1C1B),
              ),
            ),
            subtitle: Row(
              spacing: 5,
              children: [
                Text(
                  sections[index]['name'],

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
                  sections[index]['storage'],

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
                  sections[index]['time'],

                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: .w400,
                    color: Color(0xFF44474A),
                  ),
                ),
              ],
            ),
            leading: Image(image: AssetImage(sections[index]['image'],), height: 40,),
            trailing: IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
          ),
        );
      },
    );
  }
}
