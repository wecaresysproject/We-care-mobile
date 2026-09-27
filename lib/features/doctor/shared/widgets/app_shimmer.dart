import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Generic shimmer sweep — wraps any bone layout (solid-colored placeholder
/// shapes) and animates a diagonal gradient across it. Used for manual
/// skeleton loading states that need full control over their bones (e.g. to
/// match a specific Figma skeleton pixel-for-pixel), instead of a third-party
/// skeleton package.
class AppShimmer extends StatefulWidget {
  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor = AppColorsManager.shimmerBase,
    this.highlightColor = AppColorsManager.shimmerHighlight,
    this.duration = const Duration(milliseconds: 1600),
  });

  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final dx = bounds.width * 2 * _controller.value - bounds.width;
            return LinearGradient(
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.35, 0.5, 0.65],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              transform: _SlideGradientTransform(dx),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  const _SlideGradientTransform(this.dx);
  final double dx;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(dx, 0, 0);
  }
}

/// A single solid placeholder shape (a "bone") used to build manual skeleton
/// layouts inside an [AppShimmer].
class AppShimmerBone extends StatelessWidget {
  const AppShimmerBone({
    super.key,
    required this.width,
    required this.height,
    this.radius = 4,
    this.shape = BoxShape.rectangle,
    this.color = AppColorsManager.shimmerBoneFill,
  });

  /// Convenience for circular bones (avatars, icon placeholders).
  const AppShimmerBone.circle({
    super.key,
    required double diameter,
    this.color = AppColorsManager.shimmerBoneFill,
  })  : width = diameter,
        height = diameter,
        radius = 0,
        shape = BoxShape.circle;

  final double width;
  final double height;
  final double radius;
  final BoxShape shape;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius:
            shape == BoxShape.circle ? null : BorderRadius.circular(radius),
      ),
    );
  }
}
