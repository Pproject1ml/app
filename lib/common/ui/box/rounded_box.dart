import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer(
      {super.key, required this.child, this.backgroundColor, this.radius = 12});
  final Widget child;
  final Color? backgroundColor;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: backgroundColor),
        child: child);
  }
}
