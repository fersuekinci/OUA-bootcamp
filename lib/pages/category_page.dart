import 'package:flutter/material.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/widgets/CategoryItems.dart';
import 'package:oua_bootcamp/widgets/CategoryView.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final String _appbarTitle = 'Kategoriler';
  bool isList = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //ZoomDraer eklentisi
          leading: const MenuWidget(),
          title: Text(
            _appbarTitle,
          )),
      extendBody: true,
      //Yan menü - drawer eklentisi (Widget klasöüründe)
      //drawer: const DrawerWidget(),
      body: Categoryview(
        direction: Axis.vertical,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: kWhiteColor,
        column: isList? 1:2,
        ratio: isList? 2.6:1.3,
        items: categoryList.length,
        itemBuilder: (context, index) {
          return CategoryItems(
            height: 150.0,
            width: MediaQuery.of(context).size.width,
            paddingHorizontal: 0.0,
            paddingVertical: 0.0,
            align: Alignment.center,
            radius: kLessPadding,
            blendMode: BlendMode.difference,
            color: kDarkColor,
            image: categoryList[index].image!,
            title: categoryList[index].category!,
            titleSize: 20.0,
            amount: "",
            amountSize: 0.0,
            );
        }
      )
    );
  }
}
