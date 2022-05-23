import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/model/user_model.dart';
import 'package:oua_bootcamp/state/state_management.dart';

Future<UserModel> getUserProfiles(WidgetRef ref, dynamic mail) async {
  CollectionReference userRef = FirebaseFirestore.instance.collection('User');
  DocumentSnapshot snapshot = await userRef.doc(mail).get();
  if (snapshot.exists) {
    var userModel = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    ref.read(userInformation.state).state = userModel;
    return userModel;
  } else {
    return UserModel();
  }
}
