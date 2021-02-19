import 'package:flutter/material.dart';

class TransitionRouteLeft extends PageRouteBuilder{
  final Widget widget;
  TransitionRouteLeft({this.widget})
      : super(
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context,animation,secAnimation,child){
        animation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1.0, -0.0),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(-1.0, -0.0),
            ).animate(secAnimation),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secAnimation){

        return widget;
      }
  );
}

class TransitionRouteRight extends PageRouteBuilder{
  final Widget widget;
  TransitionRouteRight({this.widget})
      : super(
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (context,animation,secAnimation,child){
        animation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return SlideTransition(
          position: Tween<Offset>(

            begin: Offset(1.0, -0.0),
            end: Offset.zero,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: Offset(1.0, -0.0),
            ).animate(secAnimation),
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secAnimation){

        return widget;
      }
  );
}