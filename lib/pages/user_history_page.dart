import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oua_bootcamp/cloud_firestore/user_ref.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/utils/utils.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class UserHistoryPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final String _appbarTitle = 'Randevu Bilgileri';
    var refRefresh = ref.watch(deleteFlagRefresh);
    return Scaffold(
        appBar: AppBar(leading: const MenuWidget(), title: Text(_appbarTitle)),
        body: Container(
          color: kPrimaryColor,
          padding: const EdgeInsets.all(15),
          child: FutureBuilder(
              future: getUserHistory(DateFormat('dd-MM-yyyy')
                  .format(ref.read(selectedDate.state).state)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var userAppointments =
                      snapshot.data as List<AppointmentModel>;

                  if (userAppointments == null ||
                      userAppointments.length == 0) {
                    return const Center(
                      child: Text('Geçmiş bulunamadı'),
                    );
                  } else {
                    return FutureBuilder(
                        future: syncTime(),
                        builder: (context, snapshot) {
                          var syncTime = DateTime.now();
                          return ListView.builder(
                              itemCount: userAppointments.length,
                              itemBuilder: (context, index) {
                                var isExpried =
                                    DateTime.fromMillisecondsSinceEpoch(
                                            userAppointments[index].timeStamp!)
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
                                        title: Text(userAppointments[index]
                                            .businessName
                                            .toString()),
                                        subtitle: Text(
                                          userAppointments[index]
                                              .businessAddress
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          'Tarih : ${userAppointments[index].date} - Saat : ${userAppointments[index].interval} ',
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
                                                                  userAppointments[
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
                                              userAppointments[index].done!
                                                  ? 'Gerçekleşti '
                                                  : isExpried
                                                      ? 'Süresi Doldu'
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
    //  FirebaseFirestore.instance.collection('UserHistory').doc();
    //  .where('timeStamp', isEqualTo: appointmentModel.timeStamp);
    // .doc(FirebaseAuth.instance.currentUser!.email)
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
