import 'package:flutter/material.dart';

Route downToTop({
  required Widget screen,
  Map<String, dynamic>? args
}){
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 100),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      const begin = Offset(0, 1);
      const end = Offset.zero;
      const curve = Curves.easeOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final fadeTween = Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: screen,
        ),
      );
    },
    settings: RouteSettings(arguments: args)
  );
}


class NoAnimateTransistion<T> extends PageRouteBuilder<T>{
  final Widget screen;
  final Map<String, dynamic>? args;

  NoAnimateTransistion({required this.screen, this.args})
    :super(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      settings: RouteSettings(arguments: args)
    );
}


class SideTransistionRoute<T> extends PageRouteBuilder<T>{
  final Widget screen;
  final Map<String, dynamic>? args;

  SideTransistionRoute({required this.screen, this.args})
    :super(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCirc;
        var tween =Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      settings: RouteSettings(arguments: args)
    );
}

class ReverseSideTransistionRoute<T> extends PageRouteBuilder<T>{
  final Widget screen;
  final Map<String, dynamic>? args;

  ReverseSideTransistionRoute({required this.screen, this.args})
    :super(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCirc;
        var tween =Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      settings: RouteSettings(arguments: args)
    );
}
