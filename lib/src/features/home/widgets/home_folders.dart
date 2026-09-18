import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeFolders extends StatelessWidget {
  HomeFolders({super.key});
  final List<Map<String, dynamic>> sections = [
    {
      'file': Color(0xFF506761),
      'fileBack': Color(0xFFCBE5DD),
      'title': 'Design Systems 2025',
      'count': '34 items',
      'time': '2h ago',
    },
    {
      'file': Color(0xFF091015),
      'fileBack': Color(0xFFE9E8E6),
      'title': 'Quarterly Financials',
      'count': '12 items',
      'time': 'Yesterday',
    },
    {
      'file': Color(0xFF304A56),
      'fileBack': Color(0xFFCBE7F5),
      'title': 'Branding & Guidelines',
      'count': '48 items',
      'time': '3d ago',
    },
    {
      'file': Color(0xFF44474A),
      'fileBack': Color(0xFFE9E8E6),
      'title': 'Client Pitches',
      'count': '8 items',
      'time': '1w ago',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        mainAxisExtent: 158,
      ),
      itemBuilder: (context, index) {
        return Container(
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
                      color: sections[index]['fileBack'],

                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: .center,
                    child: SvgPicture.asset(
                      Assets.icons.file,
                      colorFilter: ColorFilter.mode(
                        sections[index]['file'],
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  Spacer(),
                  IconButton(onPressed: () {
                    
                  }, icon: Icon(Icons.more_vert))
                ],
              ),
              SizedBox(height: 14),
              Text(
                sections[index]['title'],

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
                    sections[index]['count'],

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
            ],
          ),
        );
      },
    );
  }
}
