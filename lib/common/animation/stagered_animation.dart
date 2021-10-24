import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class StaggeredAnimationDetail extends StatelessWidget {
  const StaggeredAnimationDetail(
      {required this.offset, required this.children, Key? key})
      : super(key: key);
  final List<Widget> children;
  final double? offset;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 400),
            childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: offset,
                  curve: Curves.easeIn,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
            children: children),
      ),
    );
  }
}

class StaggeredAnimation extends StatelessWidget {
  const StaggeredAnimation(
      {required this.offset,
      required this.children,
      required this.crossAxisAlignment,
      required this.mainAxisAlignment,
      Key? key})
      : super(key: key);
  final List<Widget> children;
  final double? offset;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 400),
            childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: offset,
                  curve: Curves.easeIn,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
            children: children),
      ),
    );
  }
}
