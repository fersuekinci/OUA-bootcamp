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

Future<List<AppointmentModel>> getUserHistory(String time) async {
  // var listAppointment = List<AppointmentModel>.empty(growable: true);
  // var userRef = FirebaseFirestore.instance
  //     .collection('UserHistory')
  //     .doc(FirebaseAuth.instance.currentUser!.email)
  //     .collection(selectedDate.toString());

  // var snapshot = await userRef.orderBy('timeStamp').get();
  // snapshot.docs.forEach((element) {
  //   var appointment = AppointmentModel.fromJson(element.data());
  //   listAppointment.add(appointment);
  // });
  // return listAppointment;
  var listAppointment = List<AppointmentModel>.empty(growable: true);
  var result = await FirebaseFirestore.instance
      .collection("UserHistory")
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .collection(time.toString())
      // .where("mail", isEqualTo: FirebaseAuth.instance.currentUser!.email)
      .get();

  result.docs.forEach((res) {
    var appointment = AppointmentModel.fromJson(res.data());
    listAppointment.add(appointment);
  });
  return listAppointment;
}
