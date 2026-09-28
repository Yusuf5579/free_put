import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:free_put/src/features/home/cubit/home_cubit.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';
import 'package:free_put/src/features/home/widgets/edit_name_sheet.dart';
import 'package:free_put/src/features/home/widgets/recent_file_tile.dart';
import 'package:free_put/src/features/video/screens/video_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({super.key});

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _open(QueryDocumentSnapshot file) {
    if (file['name'].toString().toLowerCase().endsWith('.mp4')) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) =>
              VideoScreen(url: file['url'], videoTitle: file['name']),
        ),
      );
    } else {
      launchUrl(Uri.parse(file['url']), mode: LaunchMode.inAppBrowserView);
    }
  }

  void _edit(BuildContext slidableContext, QueryDocumentSnapshot file) {
    _nameController.text = file['name'];
    final homeCubit = context.read<HomeCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: homeCubit,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (sheetContext, state) => EditNameSheet(
            controller: _nameController,
            loading: state.status == HomeStatus.loading,
            onUpdate: () async {
              await homeCubit.editFile(file.id, _nameController.text);
              final status = homeCubit.state.status;
              if (!sheetContext.mounted) return;
              if (status != HomeStatus.success &&
                  status != HomeStatus.failure) {
                return;
              }
              Slidable.of(slidableContext)?.close();
              Navigator.pop(sheetContext);
              _showResult(sheetContext, status, 'Updated Successfully!');
            },
          ),
        ),
      ),
    );
  }

  Future<void> _delete(QueryDocumentSnapshot file) async {
    final cubit = context.read<HomeCubit>();
    await cubit.deleteFile(file.id, file['fileId']);
    if (!mounted) return;
    _showResult(context, cubit.state.status, 'Deleted Successfully!');
  }

  /// Toasts [successTitle] or a generic error, depending on how it ended.
  void _showResult(
    BuildContext context,
    HomeStatus status,
    String successTitle,
  ) {
    if (status == HomeStatus.success) {
      _toast(context, successTitle, ToastificationType.success);
    } else if (status == HomeStatus.failure) {
      _toast(context, 'Something went wrong', ToastificationType.error);
    }
  }

  void _toast(BuildContext context, String title, ToastificationType type) {
    toastification.show(
      context: context,
      title: Text(title),
      type: type,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('files').snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator(color: Colors.black);
        }
        if (!snap.hasData) {
          return Center(child: Text(snap.error.toString()));
        }

        final docs = snap.data!.docs;
        if (docs.isEmpty) {
          return SizedBox(
            height: 300,
            width: double.infinity,
            child: Center(child: Text('Malumotlar yoq')),
          );
        }

        return BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) => ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final file = docs[index];
              return RecentFileTile(
                name: file['name'] ?? 'No name',
                deleting: state.status == HomeStatus.loading,
                onTap: () => _open(file),
                onEdit: (slidableContext) => _edit(slidableContext, file),
                onShare: () => SharePlus.instance.share(
                  ShareParams(uri: Uri.parse(file['url'])),
                ),
                onDelete: () => _delete(file),
              );
            },
          ),
        );
      },
    );
  }
}
