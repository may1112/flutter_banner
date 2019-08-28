import 'package:flutter/material.dart';
import 'dart:async';

class AppNavigator {
  static Future<dynamic> push(BuildContext context, Widget widget) {
    RouteTransitionsBuilder routeTransitionsBuilde = (BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child) {
      SlideTransition slideTransition = SlideTransition(
          child: child,
          position:
              Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .animate(animation));
      return slideTransition;
    };

    RoutePageBuilder routePageBuilder = (BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return widget;
    };

    return Navigator.of(context).push(PageRouteBuilder(
        pageBuilder: routePageBuilder,
        transitionsBuilder: routeTransitionsBuilde));
  }
}
