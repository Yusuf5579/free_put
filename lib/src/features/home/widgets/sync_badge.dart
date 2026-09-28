import 'package:flutter/material.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reflects the real state of the file list; only moves while loading.
class SyncBadge extends StatefulWidget {
  const SyncBadge({super.key, required this.status});
  final HomeStatus status;

  @override
  State<SyncBadge> createState() => _SyncBadgeState();
}

class _SyncBadgeState extends State<SyncBadge>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  bool get _busy =>
      widget.status == HomeStatus.loading ||
      widget.status == HomeStatus.initial;

  void _syncPulse() {
    if (_busy && !MediaQuery.disableAnimationsOf(context)) {
      if (!_pulse.isAnimating) _pulse.repeat();
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncPulse();
  }

  @override
  void didUpdateWidget(SyncBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final failed = widget.status == HomeStatus.failure;
    final label = failed ? 'Offline' : (_busy ? 'Syncing' : 'Synced');
    final dot = failed ? AppColors.error : AppColors.sage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: .only(bottom: 6),
      padding: .symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: failed ? AppColors.errorTint : AppColors.mist,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          SizedBox.square(
            dimension: 8,
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (context, _) => Stack(
                clipBehavior: Clip.none,
                alignment: .center,
                children: [
                  Transform.scale(
                    scale: 1 + _pulse.value * 1.6,
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: dot.withValues(
                        alpha: 0.5 * (1 - _pulse.value),
                      ),
                    ),
                  ),
                  CircleAvatar(radius: 4, backgroundColor: dot),
                ],
              ),
            ),
          ),
          SizedBox(width: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Text(
              label,
              key: ValueKey(label),
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: .w500,
                color: dot,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
