import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:free_put/src/features/files/cubit/folder_cubit.dart';
import 'package:free_put/src/features/home/cubit/home_cubit.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';
import 'package:free_put/src/features/home/cubit/search/search_cubit.dart';
import 'package:free_put/src/features/home/cubit/search/search_state.dart';
import 'package:free_put/src/features/home/cubit/upload_cubit.dart';
import 'package:free_put/src/features/home/cubit/upload_state.dart';
import 'package:free_put/src/features/home/widgets/greeting.dart';
import 'package:free_put/src/features/home/widgets/home_app_bar.dart';
import 'package:free_put/src/features/home/widgets/home_folders.dart';
import 'package:free_put/src/features/home/widgets/recent_file_tile.dart';
import 'package:free_put/src/features/home/widgets/recent_files.dart';
import 'package:free_put/src/features/home/widgets/recent_files_count.dart';
import 'package:free_put/src/features/home/widgets/search_field.dart';
import 'package:free_put/src/features/home/widgets/section_header.dart';
import 'package:free_put/src/features/home/widgets/sync_badge.dart';
import 'package:free_put/src/features/home/widgets/type_button.dart';
import 'package:free_put/src/features/home/widgets/upload_button.dart';
import 'package:free_put/src/features/home/widgets/upload_sheet/upload_sheet.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provided above the Scaffold so the upload button can refresh the list.
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _scroll = ScrollController();
  final _fabExpanded = ValueNotifier(true);
  final _sheetOpen = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      final expanded = _scroll.offset < 40;
      if (expanded != _fabExpanded.value) _fabExpanded.value = expanded;
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    _fabExpanded.dispose();
    _sheetOpen.dispose();
    super.dispose();
  }

  Future<void> _openUploadSheet() async {
    final uploadCubit = context.read<UploadCubit>();
    if (uploadCubit.state.status == UploadStatus.failure) uploadCubit.reset();

    _sheetOpen.value = true;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UploadSheet(
        onUploaded: () {
          toastification.show(
            context: context,
            type: ToastificationType.success,
            autoCloseDuration: const Duration(seconds: 3),
            title: const Text('File uploaded'),
          );
        },
      ),
    );
    _sheetOpen.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: const HomeAppBar(),
      body: BlocProvider(
        create: (context) => SearchCubit(),
        child: RefreshIndicator(
          onRefresh: () => context.read<FolderCubit>().getAllFiles(),
          child: SingleChildScrollView(
            controller: _scroll,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            padding: .fromLTRB(20, 12, 20, 120),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Row(
                  crossAxisAlignment: .end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Greeting(name: 'Elena'),
                    BlocBuilder<HomeCubit, HomeState>(
                      buildWhen: (a, b) => a.status != b.status,
                      builder: (context, state) =>
                          SyncBadge(status: state.status),
                    ),
                  ],
                ),
                SizedBox(height: 28),
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) => SearchField(
                    loading: state.status == SearchStatus.loading,
                    onChanged: (value) =>
                        context.read<SearchCubit>().search(name: value),
                  ),
                ),
                SizedBox(height: 16),
                TypeButton(),
                SizedBox(height: 36),
                BlocBuilder<SearchCubit, SearchState>(builder: (context, state){
                  if (state.status == SearchStatus.initial){
                    return Column(
                      children: [
                         SectionHeader(
                  title: 'Curated spaces',
                  trailing: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.sage,
                      textStyle: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: .w500,
                      ),
                    ),
                    child: Text('View all'),
                  ),
                ),
                SizedBox(height: 12),
                HomeFolders(),
                SizedBox(height: 36),
                SectionHeader(
                  title: 'Recent files',
                  trailing: RecentFilesCount(),
                ),
                SizedBox(height: 12),
                RecentFiles(),
                      ],
                    );
                  } else if (state.status == SearchStatus.loading){
                    return Center(child: LoadingAnimationWidget.fourRotatingDots(color: Colors.black, size: 40),);
                  } else if (state.status == SearchStatus.empty){
                    return Center(child: Lottie.asset('assets/lotties/ghost.json'));
                  } else if (state.status == SearchStatus.success){
                    return ListView.builder(shrinkWrap: true,itemCount: state.data.length,itemBuilder: (context, index){
                      return RecentFileTile(
                        name: state.data[index]['name'],
                        onDelete: () {
                          
                        },
                        deleting: false,
                        onTap: () {
                          launchUrl(Uri.parse(state.data[index]['url']), mode: LaunchMode.inAppWebView);
                        },
                        onEdit: (value) {
                          
                        },
                        onShare: () {
                          
                        },
                      );
                    });
                  } else {
                    return Center(child: Text(state.errorText ?? 'Something went wrong'),);
                  }
                })
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _fabExpanded,
        builder: (context, expanded, _) => ValueListenableBuilder(
          valueListenable: _sheetOpen,
          builder: (context, open, _) => UploadButton(
            expanded: expanded,
            open: open,
            onPressed: _openUploadSheet,
          ),
        ),
      ),
    );
  }
}
