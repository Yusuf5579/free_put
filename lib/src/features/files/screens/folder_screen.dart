import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:free_put/src/core/widgets/file_tile.dart';
import 'package:free_put/src/core/widgets/pill_tabs.dart';
import 'package:free_put/src/features/files/cubit/folder_cubit.dart';
import 'package:free_put/src/features/files/widgets/folder_app_bar.dart';
import 'package:free_put/src/features/files/widgets/folder_header.dart';
import 'package:free_put/src/features/files/widgets/folder_search_field.dart';

class FolderScreen extends StatefulWidget {
  const FolderScreen({
    super.key,
    required this.files,
    required this.colors,
    required this.filename,
  });

  final List files;
  final String filename;

  /// Folder icon colors: `'back'` for the tile, `'in'` for the glyph.
  final Map<String, Color> colors;

  @override
  State<FolderScreen> createState() => _FolderScreenState();
}

class _FolderScreenState extends State<FolderScreen> {
  static const _sortOptions = ['Newest', 'Name', 'Size'];
  bool _grid = false;
  int _sort = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FolderCubit(),
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        appBar: FolderAppBar(onBack: () => Navigator.pop(context)),
        body: Column(
          children: [
            Padding(
              padding: const .fromLTRB(20, 8, 20, 0),
              child: FolderHeader(
                title: widget.filename,
                fileCount: widget.files.length,
                background: widget.colors['back']!,
                foreground: widget.colors['in']!,
              ),
            ),
            const Padding(
              padding: .fromLTRB(20, 24, 20, 0),
              child: FolderSearchField(),
            ),
            Padding(
              padding: const .fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: PillTabs(
                      labels: _sortOptions,
                      selectedIndex: _sort,
                      onSelected: (index) => setState(() => _sort = index),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _grid = !_grid),
                    icon: Icon(
                      _grid ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: .symmetric(horizontal: 20),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.files.length,
                separatorBuilder: (_, _) => SizedBox(height: 10),
                itemBuilder: (context, index) =>
                    FileTile(name: widget.files[index]['name'] ?? 'No name'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
