import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Wraps any child in the app's standard "press-to-shrink + haptic" affordance.
// Tap visually squishes to `scale` on pointer down and springs back on release.
// Used by PopcornButton, GenreCard, and anywhere else a custom GestureDetector
// wanted the same feedback.
class PressableScale extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final double scale;
  final HitTestBehavior behavior;

  const PressableScale({
    required this.onTap,
    required this.child,
    this.scale = 0.96,
    this.behavior = HitTestBehavior.opaque,
    super.key,
  });

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: widget.behavior,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
