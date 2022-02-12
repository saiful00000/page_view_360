import 'package:flutter/material.dart';

class LeftRightSlidAble extends StatefulWidget {
  const LeftRightSlidAble({
    Key? key,
    required this.child,
    required this.nextChild,
    required this.isLastItem,
    required this.isFirstItem,
    required this.previousChild,
  }) : super(key: key);

  final Widget child;
  final Widget nextChild;
  final Widget previousChild;
  final bool isLastItem;
  final bool isFirstItem;
  // final Function jumpToNextPage;
  // final Function jumpToPreviousPage;

  @override
  _LeftRightSlidAbleState createState() => _LeftRightSlidAbleState();
}

class _LeftRightSlidAbleState extends State<LeftRightSlidAble> with TickerProviderStateMixin {
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

        /// if sliding to right
        if (_toLeftDragExtent >= 0) {
          setState(() {
            _toRightAnimationController.value = _toLeftDragExtent / (context.size?.width ?? 1.0);
          });
          return;
        }

        /// if sliding to left
        /// calculate how much we dragged into the screen
        setState(() {
          _toLeftAnimationController.value = _toLeftDragExtent.abs() / (context.size?.width ?? 1.0);
        });
      },

      /// on end
      onHorizontalDragEnd: (DragEndDetails details) {
        /// slide to right ------->
        /// if slided bellow 10% of screen
        /// then reverse the animation
        if (_toLeftAnimationController.value < 0.1) {
          _toLeftAnimationController.fling(velocity: -1);
        } else {
          /// slide to right
          _toLeftAnimationController.fling();
          print('to right ----------------->');
        }

        /// slide to left <-----
        if (_toRightAnimationController.value > 0.1) {
          _toRightAnimationController.fling();
        } else {
          _toRightAnimationController.fling(velocity: -1);
          print('to left <------------------');
        }
      },

      /// child widget
      child: Stack(
        children: [
          Container(
            child: widget.nextChild,
          ),
          AnimatedBuilder(
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
                      child: widget.child,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
