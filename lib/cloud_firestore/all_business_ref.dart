import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/model/business_model.dart';

Future<List<CategoryModal>> getCategory() async {
  var categories = List<CategoryModal>.empty(growable: true);
  var categoryRef = FirebaseFirestore.instance.collection('AllBusiness');
  var snapshot = await categoryRef.get();
  snapshot.docs.forEach((element) {
    categories.add(CategoryModal.fromJson(element.data()));
  });
  return categories;
}

Future<List<BusinessModal>> getBusinessByCategory(String categoryName) async {
  var business = List<BusinessModal>.empty(growable: true);
  var businessRef = FirebaseFirestore.instance
      .collection('AllBusiness')
      .doc(categoryName)
      .collection('BusinessList');
  var snapshot = await businessRef.get();
  snapshot.docs.forEach((element) {
    var businesses = (BusinessModal.fromJson(element.data()));
    businesses.docId = element.id;
    businesses.reference = element.reference;
    business.add(businesses);
  });
  return business;
}

Future<List<AppointmentModel>> getAppointmentByBusiness(
    BusinessModal business) async {
  var appointments = List<AppointmentModel>.empty(growable: true);
  var appointmentRef = FirebaseFirestore.instance.collection('Appointment');
  var snapshot = await appointmentRef.get();
  snapshot.docs.forEach((element) {
    var appointment = (AppointmentModel.fromJson(element.data()));
    appointment.docId = element.id;
    appointment.reference = element.reference;
    appointments.add(appointment);
  });
  return appointments;
}
