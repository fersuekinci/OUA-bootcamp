import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesRepository extends ChangeNotifier {
  String image = "";
  String category = "";
  List categoryName = [];

  List getCategoryName() {
    return categoryName;
  }

  void notifyAll() {
    notifyListeners();
  }
}

final categoriesPageProvider = ChangeNotifierProvider((ref) {
  return CategoriesRepository();
});
