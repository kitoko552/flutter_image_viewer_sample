import 'package:flutter/widgets.dart';

class FadeInRoute extends PageRouteBuilder {
  final Widget widget;
  final bool opaque;

  FadeInRoute({
    @required this.widget,
    this.opaque = true,
  }) : super(
          opaque: opaque,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
