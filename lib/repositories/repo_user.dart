import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserRepository extends ChangeNotifier {
  String fullName = "";
  String phoneNumber = "";
  String mail = "";
  bool isBusiness = false;

  void notifyAll() {
    notifyListeners();
  }
}

final userProvider = ChangeNotifierProvider((ref) {
  return UserRepository();
});
