import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/model/appointment.dart';
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

Future<List> getUserDateAppointment() async {
  var listAppointment = List.empty(growable: true);
  var result = await FirebaseFirestore.instance
      .collection("UserHistory")
      .doc(FirebaseAuth.instance.currentUser!.email.toString())

      // .orderBy('timeStamp', descending: true)
      //.where(, isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get();

  return listAppointment;
}

Future<List<AppointmentModel>> getUserHistory(String date) async {
  var listAppointment = List<AppointmentModel>.empty(growable: true);
  var result = await FirebaseFirestore.instance
      .collection("UserHistory")
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .collection(date)
      // .orderBy('timeStamp', descending: true)
      //.where(, isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get();

  result.docs.forEach((res) {
    var appointment = AppointmentModel.fromJson(res.data());
    listAppointment.add(appointment);
  });
  return listAppointment;
}
