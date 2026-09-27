import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/features/home/cubit/home_cubit.dart';
import 'package:free_put/src/features/home/cubit/home_state.dart';
import 'package:free_put/src/features/home/cubit/upload_cubit.dart';
import 'package:free_put/src/features/home/cubit/upload_state.dart';
import 'package:free_put/src/features/home/widgets/home_folders.dart';
import 'package:free_put/src/features/home/widgets/recent_files.dart';
import 'package:free_put/src/features/home/widgets/type_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

abstract final class _Palette {
  static const paper = Color(0xFFF8F9F9);
  static const ink = Color(0xFF1A1C1B);
  static const slate = Color(0xFF44474A);
  static const sage = Color(0xFF4C635D);
  static const mist = Color(0xFFCBE5DD);
  static const line = Color(0xFFE3E6E5);
  static const error = Color(0xFFB3261E);
  static const errorTint = Color(0xFFF6E1DF);
}

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
      builder: (_) => _UploadSheet(
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
      backgroundColor: _Palette.paper,
      appBar: AppBar(
        forceMaterialTransparency: true,
        titleSpacing: 20,
        actionsPadding: .only(right: 20),
        title: Row(
          children: [
            Image(image: AssetImage(Assets.images.logo.path), height: 26),
            SizedBox(width: 10),
            Text(
              'Aether',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: .w700,
                color: _Palette.ink,
              ),
            ),
            Text(
              '  /  Files',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: _Palette.slate,
              ),
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            radius: 16,
            backgroundImage: AssetImage(Assets.images.json.path),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
              children: [
                Expanded(child: _Greeting(name: 'Elena')),
                BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (a, b) => a.status != b.status,
                  builder: (context, state) =>
                      _SyncBadge(status: state.status),
                ),
              ],
            ),
            SizedBox(height: 28),
            _SearchField(),
            SizedBox(height: 16),
            TypeButton(),
            SizedBox(height: 36),
            _SectionHeader(
              title: 'Curated spaces',
              trailing: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: _Palette.sage,
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
            _SectionHeader(
              title: 'Recent files',
              trailing: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    state.status == HomeStatus.success
                        ? '${state.data.length} files'
                        : '',
                    key: ValueKey(state.data.length),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: _Palette.slate,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            RecentFiles(),
          ],
        ),
      ),
      floatingActionButton: ValueListenableBuilder(
        valueListenable: _fabExpanded,
        builder: (context, expanded, _) => ValueListenableBuilder(
          valueListenable: _sheetOpen,
          builder: (context, open, _) => _UploadButton(
            expanded: expanded,
            open: open,
            onPressed: _openUploadSheet,
          ),
        ),
      ),
    );
  }
}

/// The screen's one load-time moment: each line rises out of a mask.
class _Greeting extends StatefulWidget {
  const _Greeting({required this.name});
  final String name;

  @override
  State<_Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<_Greeting>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.value = 1;
    } else if (!_controller.isAnimating && _controller.value == 0) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _partOfDay {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 18) return 'afternoon';
    return 'evening';
  }

  Widget _line(String text, Interval interval) {
    final curve = CurvedAnimation(
      parent: _controller,
      curve: interval.chain(Curves.easeOutCubic),
    );
    return ClipRect(
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(curve),
        child: Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 34,
            height: 1.12,
            letterSpacing: -1.2,
            fontWeight: .w600,
            color: _Palette.ink,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: 'Good $_partOfDay, ${widget.name}',
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _line('Good $_partOfDay,', const Interval(0, 0.7)),
            _line(widget.name, const Interval(0.2, 1)),
          ],
        ),
      ),
    );
  }
}

extension on Interval {
  Curve chain(Curve inner) => Interval(begin, end, curve: inner);
}

/// Reflects the real state of the file list; only moves while loading.
class _SyncBadge extends StatefulWidget {
  const _SyncBadge({required this.status});
  final HomeStatus status;

  @override
  State<_SyncBadge> createState() => _SyncBadgeState();
}

class _SyncBadgeState extends State<_SyncBadge>
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
  void didUpdateWidget(_SyncBadge oldWidget) {
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
    final dot = failed ? _Palette.error : _Palette.sage;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: .only(bottom: 6),
      padding: .symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: failed ? _Palette.errorTint : _Palette.mist,
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
                color: failed ? _Palette.error : _Palette.sage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 1.2),
      borderRadius: BorderRadius.circular(50),
    );

    return TextField(
      cursorColor: _Palette.sage,
      style: GoogleFonts.inter(fontSize: 15, color: _Palette.ink),
      decoration: InputDecoration(
        hintText: 'Find files',
        hintStyle: GoogleFonts.inter(fontSize: 15, color: _Palette.slate),
        contentPadding: .symmetric(vertical: 16),
        prefixIconConstraints: BoxConstraints(maxHeight: 17),
        prefixIcon: Padding(
          padding: .only(left: 20, right: 10),
          child: SvgPicture.asset(Assets.icons.search),
        ),
        suffixIconConstraints: BoxConstraints(minHeight: 22),
        suffixIcon: Padding(
          padding: .only(right: 20, left: 10),
          child: SvgPicture.asset(Assets.icons.voice),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: border(_Palette.line),
        focusedBorder: border(_Palette.sage),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.trailing});
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: .w600,
            letterSpacing: -0.3,
            color: _Palette.ink,
          ),
        ),
        Spacer(),
        trailing,
      ],
    );
  }
}

/// Pill that collapses to a circle once the list is scrolled, and whose
/// plus turns into a close mark while the upload sheet is open.
class _UploadButton extends StatelessWidget {
  const _UploadButton({
    required this.expanded,
    required this.open,
    required this.onPressed,
  });

  final bool expanded;
  final bool open;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 280);
    return Semantics(
      button: true,
      label: 'Upload a file',
      child: Material(
        color: _Palette.ink,
        shape: const StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: AnimatedSize(
            duration: duration,
            curve: Curves.easeOutCubic,
            child: SizedBox(
              height: 56,
              child: Padding(
                padding: .symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    AnimatedRotation(
                      turns: open ? 0.125 : 0,
                      duration: duration,
                      curve: Curves.easeOutBack,
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                    if (expanded) ...[
                      SizedBox(width: 8),
                      Padding(
                        padding: .only(right: 6),
                        child: Text(
                          'Upload',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: .w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UploadSheet extends StatelessWidget {
  const _UploadSheet({required this.onUploaded});
  final VoidCallback onUploaded;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: .fromLTRB(
        24,
        12,
        24,
        24 + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: BlocBuilder<UploadCubit, UploadState>(
        builder: (context, state) {
          final loading = state.status == UploadStatus.loading;
          final picked = state.file != null && state.name != null;

          return Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 36,
                  decoration: BoxDecoration(
                    color: _Palette.line,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Upload a file',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: .w600,
                  letterSpacing: -0.5,
                  color: _Palette.ink,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'It shows up in Recent files once it’s stored.',
                style: GoogleFonts.inter(fontSize: 14, color: _Palette.slate),
              ),
              SizedBox(height: 24),
              _DropZone(
                name: picked ? state.name : null,
                onTap: loading
                    ? null
                    : () => context.read<UploadCubit>().fileTanlash(),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: state.status == UploadStatus.failure
                    ? Padding(
                        padding: .only(top: 12),
                        child: Text(
                          'Upload failed. Check your connection, then choose the file again.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: _Palette.error,
                          ),
                        ),
                      )
                    : SizedBox(width: double.infinity),
              ),
              SizedBox(height: 20),
              _SubmitButton(
                loading: loading,
                onPressed: picked && !loading
                    ? () => context.read<UploadCubit>().fileYuborish(
                        onError: () {},
                        onSuccess: () {
                          Navigator.pop(context);
                          onUploaded();
                        },
                      )
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DropZone extends StatelessWidget {
  const _DropZone({required this.name, required this.onTap});
  final String? name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final picked = name != null;
    final radius = BorderRadius.circular(20);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: picked ? _Palette.sage : _Palette.line,
            radius: 20,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 132,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: picked
                  ? _Palette.mist.withValues(alpha: 0.35)
                  : Colors.transparent,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween(begin: 0.96, end: 1.0).animate(animation),
                  child: child,
                ),
              ),
              child: picked
                  ? _PickedFile(key: ValueKey(name), name: name!)
                  : const _EmptyDrop(key: ValueKey('empty')),
            ),
          ),
        ),
      ),
    );
  }
}

class _FileGlyph extends StatelessWidget {
  const _FileGlyph();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: _Palette.mist,
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: .center,
      child: SvgPicture.asset(
        Assets.icons.file,
        colorFilter: ColorFilter.mode(_Palette.sage, BlendMode.srcIn),
      ),
    );
  }
}

class _EmptyDrop extends StatelessWidget {
  const _EmptyDrop({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      children: [
        _FileGlyph(),
        SizedBox(height: 12),
        Text(
          'Choose a file',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: .w500,
            color: _Palette.ink,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Documents, images or videos',
          style: GoogleFonts.inter(fontSize: 12, color: _Palette.slate),
        ),
      ],
    );
  }
}

class _PickedFile extends StatelessWidget {
  const _PickedFile({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .symmetric(horizontal: 20),
      child: Row(
        children: [
          _FileGlyph(),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .start,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: .w500,
                    color: _Palette.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tap to choose another',
                  style: GoogleFonts.inter(fontSize: 12, color: _Palette.slate),
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle_rounded, color: _Palette.sage),
        ],
      ),
    );
  }
}

/// Full-width button that shrinks into a spinner while the upload runs.
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({required this.loading, required this.onPressed});
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final active = onPressed != null || loading;
    return LayoutBuilder(
      builder: (context, constraints) => Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          height: 54,
          width: loading ? 54 : constraints.maxWidth,
          decoration: BoxDecoration(
            color: active ? _Palette.ink : _Palette.line,
            borderRadius: BorderRadius.circular(27),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              customBorder: const StadiumBorder(),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: loading
                      ? const SizedBox.square(
                          key: ValueKey('loading'),
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Upload',
                          key: const ValueKey('label'),
                          maxLines: 1,
                          overflow: .clip,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: .w500,
                            color: active ? Colors.white : _Palette.slate,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});
  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size,
          Radius.circular(radius),
        ).deflate(0.7),
      );
    for (final metric in path.computeMetrics()) {
      for (double d = 0; d < metric.length; d += 10) {
        canvas.drawPath(metric.extractPath(d, d + 5), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color || old.radius != radius;
}
