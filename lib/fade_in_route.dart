import 'package:flutter/widgets.dart';

class FadeInRoute extends PageRouteBuilder {
  FadeInRoute({
    @required this.widget,
    this.opaque = true,
    this.onTransitionCompleted,
    this.onTransitionDismissed,
  }) : super(
          opaque: opaque,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            animation.addStatusListener((status) {
              if (status == AnimationStatus.completed &&
                  onTransitionCompleted != null) {
                onTransitionCompleted();
              } else if (status == AnimationStatus.dismissed &&
                  onTransitionDismissed != null) {
                onTransitionDismissed();
              }
            });

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

  final Widget widget;
  final bool opaque;
  final Function onTransitionCompleted;
  final Function onTransitionDismissed;
}
