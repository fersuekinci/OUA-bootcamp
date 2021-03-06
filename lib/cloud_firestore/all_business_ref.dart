import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/model/business_model.dart';
import 'package:oua_bootcamp/repositories/repo_business_detail.dart';

Future<List<CategoryModal>> getCategory() async {
  var categories = List<CategoryModal>.empty(growable: true);
  var categoryRef = FirebaseFirestore.instance.collection('AllBusiness');
  var snapshot = await categoryRef.get();
  for (var element in snapshot.docs) {
    categories.add(CategoryModal.fromJson(element.data()));
  }
  return categories;
}

Future<List<BusinessModal>> getBusinessByCategory(String categoryName) async {
  var business = List<BusinessModal>.empty(growable: true);
  var businessRef = FirebaseFirestore.instance
      .collection('AllBusiness')
      .doc(categoryName)
      .collection('BusinessList');
  var snapshot = await businessRef.get();
  for (var element in snapshot.docs) {
    var businesses = (BusinessModal.fromJson(element.data()));
    businesses.docId = element.id;

    business.add(businesses);
  }
  return business;
}

Future<List<AppointmentModel>> getAppointmentByBusiness(
    BusinessModal business) async {
  var appointments = List<AppointmentModel>.empty(growable: true);
  var appointmentRef = FirebaseFirestore.instance.collection('Appointment');
  var snapshot = await appointmentRef.get();
  for (var element in snapshot.docs) {
    var appointment = (AppointmentModel.fromJson(element.data()));
    appointment.docId = element.id;
    appointment.reference = element.reference;
    appointments.add(appointment);
  }
  return appointments;
}

// Future<List<int>> getTimeIntervalOfAppointment(String time) async {
//   List<int> result = List<int>.empty(growable: true);
//   var appointmentRef = FirebaseFirestore.instance.collection('Appointment');
//   // .collection(time);
//   QuerySnapshot snapshot = await appointmentRef.get();
//   for (var element in snapshot.docs) {
//     var appointment = (AppointmentModel.fromJson(element.data()));
//     appointment.time = time;
//     result.add(int.parse(element.id));
//   }
//   return result;
// }

Future<List<String>> getTimeIntervalOfAppointment(
    String time, String businessName, String date) async {
  var appointment = List<String>.empty(growable: true);
  var appointmentRed = FirebaseFirestore.instance
      .collection('Appointment')
      .doc(businessName)
      .collection(date);

  var snapshot = await appointmentRed.get();
  for (var element in snapshot.docs) {
    var appointments = (AppointmentModel.fromJson(element.data()));
    appointments.time = time;
    appointments.businessName = businessName;

    appointment.add(appointments.interval.toString());
  }
  return appointment;
}

Future<List<AppointmentModel>> getBusinessHistory(
    String date, String email) async {
  var listAppointment = List<AppointmentModel>.empty(growable: true);
  var result = await FirebaseFirestore.instance
      .collection("Appointment")
      .doc(email)
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
