import 'package:flutter/material.dart';

import 'package:oua_bootcamp/constants.dart';


class Categoryview extends StatelessWidget {
  final int column, items;
  final Color color;
  final double ratio, height, width;
  final direction, itemBuilder;
  Categoryview({
    Key? key,
    required this.column,
    required this.items,
    required this.color,
    required this.ratio,
    required this.height,
    required this.width,
    required this.direction,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      color: color,
      child: GridView.builder(
          padding: EdgeInsets.all(kLess),
          scrollDirection: direction,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: column,
            childAspectRatio: ratio,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
          ),
          itemCount: items,
          itemBuilder: itemBuilder),
    );
  }
}