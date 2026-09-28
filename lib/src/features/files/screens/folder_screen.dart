import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/features/files/cubit/folder_cubit.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({
    super.key,
    required this.files,
    required this.colors,
    required this.filename,
  });
  final List files;
  final String filename;
  final Map colors;
  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  bool _grid = false;
  int _sort = 0;
  List sort = ['Newest', 'Name', 'Size'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FolderCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF7F9F8),
            appBar: AppBar(
              backgroundColor: const Color(0xFFF7F9F8),
              surfaceTintColor: Colors.transparent,

              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  iconSize: 20,
                ),
                icon: Icon(Icons.arrow_back),
              ),
              leadingWidth: 80,
              title: Text(
                'Curated spaces',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black.withOpacity(.55),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: IconButton(
                    onPressed: () {},
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    icon: Icon(Icons.more_vert),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                      child: Row(
                        children: [
                          Hero(
                            tag: widget.filename,
                            child: Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: widget.colors['back'],
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Icon(
                                Icons.folder_rounded,
                                color: widget.colors['in'],
                                size: 36,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.filename,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    height: 1.1,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.files.length} files  •  Updated 2 days ago',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black.withOpacity(.5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.black.withOpacity(.08),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for your file',
                            hintStyle: TextStyle(
                              color: Colors.black.withOpacity(.4),
                            ),
                            prefixIcon: const Icon(Icons.search_rounded),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: SizedBox(
                                height: 44,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: .horizontal,
                                  itemCount: sort.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      onTap: () {
                                        setState(() {
                                          _sort = index;
                                        });
                                      },
                                      child: Container(
                                        margin: .only(right: 10),
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          color: _sort == index
                                              ? Colors.black
                                              : Colors.white,
                                        ),
                                        padding: .only(
                                          top: 6,
                                          left: 15,
                                          bottom: 6,
                                          right: 15,
                                        ),
                                        alignment: .center,
                                        child: Text(
                                          sort[index],
                                          style: TextStyle(
                                            color: _sort == index
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _grid = !_grid),
                            icon: Icon(
                              _grid
                                  ? Icons.view_list_rounded
                                  : Icons.grid_view_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: .symmetric(horizontal: 20),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.files.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
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
                                  widget.files[index]['name'] ?? 'No name',
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
                              SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
