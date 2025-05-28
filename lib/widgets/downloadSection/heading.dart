import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String heading;
  final double fontSize;
  final EdgeInsets padding;

  const Heading(this.heading, {required this.fontSize, required this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: padding,
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Text(
              heading,
              style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
