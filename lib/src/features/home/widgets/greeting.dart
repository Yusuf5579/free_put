import 'package:flutter/material.dart';
import 'package:free_put/src/core/utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

/// The screen's one load-time moment: each line rises out of a mask.
class Greeting extends StatefulWidget {
  const Greeting({super.key, required this.name});
  final String name;

  @override
  State<Greeting> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting>
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
            color: AppColors.ink,
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
