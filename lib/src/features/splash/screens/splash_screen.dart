import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_put/gen/assets.gen.dart';
import 'package:free_put/src/features/home/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

/// Splash sequence modelled on the 60fps "good-air-splash" shot: the logo
/// scales/fades in over a soft blue gradient, the title reveals beneath it,
/// the tagline lines stagger in, then a bottom card with a CTA slides up.
///
/// Timings and curves are estimates from the shot's text description, not
/// measured values. Tune the [Interval]s below to taste.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _taglines = ['Store anything.', 'Share it anywhere.'];

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2600),
  );

  // Logo: scale 0.6 -> 1 with a soft overshoot, fading in.
  late final Animation<double> _logoScale = Tween<double>(begin: 0.6, end: 1)
      .animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.30, curve: Curves.easeOutBack),
        ),
      );
  late final Animation<double> _logoFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.0, 0.20, curve: Curves.easeOut),
  );

  // Title reveals just after the logo lands.
  late final Animation<double> _titleFade = CurvedAnimation(
    parent: _controller,
    curve: const Interval(0.22, 0.42, curve: Curves.easeOut),
  );
  late final Animation<Offset> _titleSlide =
      Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.22, 0.42, curve: Curves.easeOutCubic),
        ),
      );

  // Bottom card slides up from below the screen.
  late final Animation<Offset> _cardSlide =
      Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.55, 0.95, curve: Curves.easeOutCubic),
        ),
      );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Fade + rise for tagline line [index], staggered by 0.08 of the timeline.
  Animation<double> _lineAnimation(int index) {
    final start = 0.40 + index * 0.08;
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, start + 0.25, curve: Curves.easeOutCubic),
    );
  }

  void _onGetStarted() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDCEBFF), Color(0xFFF4F9FF)],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: Image.asset(Assets.images.logo.path, width: 88),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        'Aether',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1C1B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (var i = 0; i < _taglines.length; i++)
                    _StaggeredLine(
                      animation: _lineAnimation(i),
                      text: _taglines[i],
                    ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: _cardSlide,
                child: _BottomCard(onPressed: _onGetStarted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredLine extends StatelessWidget {
  const _StaggeredLine({required this.animation, required this.text});

  final Animation<double> animation;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: const Color(0xFF44474A),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomCard extends StatelessWidget {
  const _BottomCard({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        24,
        28,
        24,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: CupertinoColors.activeBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Get started',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
