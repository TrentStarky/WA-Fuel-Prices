import 'package:flutter/material.dart';

class TransitionRouter {
  static bottomToTop(Widget newScreen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final curveTween = CurveTween(curve: Curves.ease);
        final offsetAnimation = animation.drive(tween.chain(curveTween));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static rightToLeft(Widget newScreen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newScreen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final curveTween = CurveTween(curve: Curves.ease);
        final offsetAnimation = animation.drive(tween.chain(curveTween));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  static noTransition(Widget newScreen) {
    return PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => newScreen);
  }
}