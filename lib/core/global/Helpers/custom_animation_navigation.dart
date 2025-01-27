import 'package:flutter/material.dart';

enum TransitionType {
  rightToLeft,
  leftToRight,
  bottomToTop,
  topToBottom,
}

//MaterialPageRoute , PageRouteBuilder
Route createCustomTransitionRoute(
  Widget screen,
  TransitionType transitionType,
) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.ease;
      // Define the different start and end points for each transition
      Offset begin;
      Offset end = Offset.zero;
      switch (transitionType) {
        case TransitionType.rightToLeft:
          begin = const Offset(1.0, 0.0); // Right to left
          break;
        case TransitionType.leftToRight:
          begin = const Offset(-1.0, 0.0); // Left to right
          break;
        case TransitionType.bottomToTop:
          begin = const Offset(0.0, 1.0); // Bottom to top
          break;
        case TransitionType.topToBottom:
          begin = const Offset(0.0, -1.0); // Top to bottom
          break;
      }
      // Apply the offset transition
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
