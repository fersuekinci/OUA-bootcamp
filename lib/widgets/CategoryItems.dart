import 'package:flutter/material.dart';

import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:provider/provider.dart';

class CategoryItems extends StatelessWidget {
  final double height,
      width,
      radius,
      titleSize,
      amountSize,
      paddingHorizontal,
      paddingVertical;
  final String title, amount;
  final String image;
  final Color color;
  final Color? lblColor;
  final align, blendMode;
  const CategoryItems({
    Key? key,
    required this.height,
    required this.width,
    required this.radius,
    required this.image,
    required this.titleSize,
    required this.title,
    required this.color,
    required this.align,
    required this.amount,
    required this.blendMode,
    required this.amountSize,
    required this.paddingHorizontal,
    required this.paddingVertical,
    this.lblColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kLess),
      child: Stack(
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(color, blendMode),
              ),
            ),
          ),
          Align(
            alignment: align,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: title,
                    style: TextStyle(color: kWhiteColor, fontSize: titleSize),
                  ),
                  WidgetSpan(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: paddingHorizontal,
                        vertical: paddingVertical,
                      ),
                      decoration: BoxDecoration(
                        color: lblColor,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: amount,
                              style: TextStyle(
                                color: kWhiteColor,
                                fontSize: amountSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
