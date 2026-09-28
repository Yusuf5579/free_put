import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:free_put/src/core/widgets/file_tile.dart';

/// A recent file row. Slide right to Edit, slide left to Share or Delete.
class RecentFileTile extends StatelessWidget {
  const RecentFileTile({
    super.key,
    required this.name,
    required this.deleting,
    required this.onTap,
    required this.onEdit,
    required this.onShare,
    required this.onDelete,
  });

  final String name;

  /// Swaps the Delete action for a spinner while a delete is in progress.
  final bool deleting;
  final VoidCallback onTap;

  /// Receives the Slidable's context so the caller can close it afterwards.
  final ValueChanged<BuildContext> onEdit;
  final VoidCallback onShare;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),
          child: Slidable(
            startActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  padding: .zero,
                  autoClose: false,
                  onPressed: onEdit,
                  backgroundColor: CupertinoColors.systemGreen,
                  foregroundColor: Colors.white,
                  icon: CupertinoIcons.pencil,
                  label: 'Edit',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: ScrollMotion(),
              children: [
                SlidableAction(
                  flex: 2,
                  onPressed: (_) => onShare(),
                  backgroundColor: CupertinoColors.activeOrange,
                  foregroundColor: Colors.white,
                  icon: CupertinoIcons.share,
                  label: 'Share',
                ),
                deleting
                    ? const _DeletingIndicator()
                    : SlidableAction(
                        flex: 2,
                        autoClose: false,
                        onPressed: (_) => onDelete(),
                        backgroundColor: CupertinoColors.systemRed,
                        foregroundColor: Colors.white,
                        icon: CupertinoIcons.delete,
                        label: 'Delete',
                      ),
              ],
            ),
            child: FileTile(name: name),
          ),
        ),
      ),
    );
  }
}

class _DeletingIndicator extends StatelessWidget {
  const _DeletingIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: .infinity,
      width: 80,
      padding: .symmetric(horizontal: 40, vertical: 40),
      decoration: BoxDecoration(
        color: CupertinoColors.systemRed,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Center(child: CupertinoActivityIndicator(color: Colors.white)),
    );
  }
}
