import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';

import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/repositories/repo_business_detail.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/utils/utils.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BusinessHistoryPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final String _appbarTitle = 'Randevu Bilgileri';
    var refRefresh = ref.watch(deleteFlagRefresh);
    final businessRepoProvider = ref.read(businessDetailPageProvider);
    var now = ref.watch(selectedDate.state).state;
    return Scaffold(
        appBar: AppBar(
          leading: const MenuWidget(),
          title: Text(_appbarTitle),
          actions: [
            Container(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: (() {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime.now().add(const Duration(days: 31)),
                          onConfirm: (date) =>
                              ref.read(selectedDate.state).state = date);
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                              'assets/images/icons8-tear-off-calendar-48.png')),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        body: Container(
          color: kPrimaryColor,
          padding: const EdgeInsets.all(15),
          child: FutureBuilder(
              future: getBusinessHistory(DateFormat('dd-MM-yyyy').format(now),
                  FirebaseAuth.instance.currentUser!.email.toString()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var businessAppointments =
                      snapshot.data as List<AppointmentModel>;

                  if (businessAppointments == null ||
                      businessAppointments.length == 0) {
                    return const Center(
                      child: Text('Geçmiş bulunamadı'),
                    );
                  } else {
                    return FutureBuilder(
                        future: syncTime(),
                        builder: (context, snapshot) {
                          var syncTime = DateTime.now();
                          return ListView.builder(
                              itemCount: businessAppointments.length,
                              itemBuilder: (context, index) {
                                var isExpried =
                                    DateTime.fromMillisecondsSinceEpoch(
                                            businessAppointments[index]
                                                .timeStamp!)
                                        .isAfter(syncTime);
                                return Card(
                                  color: kThirdColor,
                                  elevation: 20,
                                  clipBehavior: Clip.antiAlias,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                            Icons.arrow_drop_down_circle),
                                        title: Text(businessAppointments[index]
                                            .userName
                                            .toString()),
                                        subtitle: Text(
                                          businessAppointments[index]
                                              .userMail
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'Tarih : ${businessAppointments[index].date} - Saat : ${businessAppointments[index].interval} ',
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: isExpried
                                              ? null
                                              : () {
                                                  Alert(
                                                      context: context,
                                                      type: AlertType.warning,
                                                      title: 'Randevu İptali',
                                                      desc:
                                                          'Seçilen randevuyu iptal etmek istediğinizden emin misiniz?',
                                                      buttons: [
                                                        DialogButton(
                                                            child:
                                                                Text('Vazgeç'),
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop()),
                                                        DialogButton(
                                                            child:
                                                                Text('Onayla'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              cancelAppointment(
                                                                  context,
                                                                  ref,
                                                                  businessAppointments[
                                                                      index]);
                                                            })
                                                      ]).show();
                                                },
                                          child: Container(
                                            alignment: Alignment.center,
                                            color: kSecondaryColor,
                                            height: 30,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Text(
                                              businessAppointments[index].done!
                                                  ? 'Gerçekleşti '
                                                  : isExpried
                                                      ? 'İptal Et'
                                                      : 'İptal Et',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ))

//Image.asset('assets/card-sample-image.jpg'),
                                    ],
                                  ),
                                );
                              });
                        });
                  }
                }
              }),
        ));
  }

  void cancelAppointment(
      BuildContext context, WidgetRef ref, AppointmentModel appointmentModel) {
    var batch = FirebaseFirestore.instance.batch();

    var businessAppointment = FirebaseFirestore.instance
        .collection("Appointment")
        .doc(appointmentModel.businessName)
        .collection(
            DateFormat('dd-MM-yyyy').format(ref.read(selectedDate.state).state))
        .doc(appointmentModel.interval);

    var userAppointment = FirebaseFirestore.instance
        .collection('UserHistory')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(
            DateFormat('dd-MM-yyyy').format(ref.read(selectedDate.state).state))
        .doc(appointmentModel.interval);
    // .where('timeStamp', isEqualTo: appointmentModel.timeStamp);
    //  FirebaseFirestore.instance.collection('BusinessHistory').doc();
    //  .where('timeStamp', isEqualTo: appointmentModel.timeStamp);
    // .doc(FirebaseAuth.instance.currentBusiness!.email)
    // .collection(appointmentModel.date.toString())
    // .doc();

    batch.delete(businessAppointment);
    batch.delete(userAppointment);

    batch.commit().then((value) {
      ref.read(deleteFlagRefresh.state).state =
          !ref.read(deleteFlagRefresh.state).state;
    });
  }
}
