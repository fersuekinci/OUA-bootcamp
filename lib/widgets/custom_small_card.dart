import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:oua_bootcamp/constants.dart';

class CustomCategoryCard extends StatelessWidget {
  const CustomCategoryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(3, (index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              height: size.width * .25,
              width: size.width * .25,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: textWhite,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: textBlack.withOpacity(0.05),
                    blurRadius: 15.0,
                    offset: Offset(0, 7),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 35.0,
                    width: 35.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.5),
                          spreadRadius: 0.0,
                          blurRadius: 6.0,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Container(child: Icon(Icons.history)),
                  ),
                  Text(
                    'Geçmiş',
                    // HomePageCategoryJson[index]['title'],
                    style: kTextStyle,
                  ),
                  SizedBox(height: 0.0),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
