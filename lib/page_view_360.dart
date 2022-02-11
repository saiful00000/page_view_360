library page_view_360;

import 'package:flutter/material.dart';

class ThreeSixtyPageView extends StatefulWidget {
  /// dependencies
  /// required dependencies to using this widget

  /// item builder method
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;

  const ThreeSixtyPageView({Key? key, required this.itemBuilder, required this.itemCount}) : super(key: key);

  @override
  _ThreeSixtyPageViewState createState() => _ThreeSixtyPageViewState();
}

class _ThreeSixtyPageViewState extends State<ThreeSixtyPageView> with TickerProviderStateMixin {
  /// animation controllers
  late final AnimationController _toLeftAnimationController;
  late final AnimationController _toRightAnimationController;

  /// indicate drag extent value is screen
  double _toLeftDragExtent = 0.0;

  @override
  void initState() {
    super.initState();
    _toLeftAnimationController = AnimationController(vsync: this);
    _toRightAnimationController = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    /// to right sliding
    return AnimatedBuilder(
      animation: _toRightAnimationController,
      builder: (context, child) {
        return SlideTransition(
          position: AlwaysStoppedAnimation(Offset(_toRightAnimationController.value, 0.0)),
          /// to left sliding
          child: AnimatedBuilder(
            animation: _toLeftAnimationController,
            builder: (context, child) {
              return SlideTransition(
                position: AlwaysStoppedAnimation(Offset(-_toLeftAnimationController.value, 0.0)),
                child: PageView.builder(
                  itemCount: widget.itemCount,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      /// on start
                      onHorizontalDragStart: (DragStartDetails details) {
                        setState(() {
                          _toLeftDragExtent = 0;
                          _toLeftAnimationController.reset();
                          _toRightAnimationController.reset();
                        });
                      },

                      /// on update
                      onHorizontalDragUpdate: (DragUpdateDetails details) {
                        _toLeftDragExtent += details.primaryDelta ?? 0;

                        /// to ensure only to left drag will work
                        if (_toLeftDragExtent >= 0) {
                          setState(() {
                            _toRightAnimationController.value = _toLeftDragExtent / (context.size?.width ?? 1.0);
                          });
                          return;
                        }

                        /// calculate how much we dragged into the screen
                        setState(() {
                          _toLeftAnimationController.value = _toLeftDragExtent.abs() / (context.size?.width ?? 1.0);
                        });
                      },

                      /// on end
                      onHorizontalDragEnd: (DragEndDetails details) {
                        /// if slided bellow 10% of screen
                        /// then reverse the animation
                        if (_toLeftAnimationController.value < 0.1) {
                          _toLeftAnimationController.fling(velocity: -1);
                        } else {
                          /// slide to end
                          _toLeftAnimationController.fling();
                        }

                        if(_toRightAnimationController.value > 0.1){
                          _toRightAnimationController.fling();
                        }else{
                          _toRightAnimationController.fling(velocity: -1);
                        }

                      },

                      /// child widget
                      child: widget.itemBuilder(context, index),
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
