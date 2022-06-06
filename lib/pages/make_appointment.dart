import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/model/business_model.dart';
import 'package:oua_bootcamp/repositories/repo_business_detail.dart';
import 'package:oua_bootcamp/repositories/repo_user.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/utils/utils.dart';

import '../sercices/database.dart';

class MakeAppointment extends ConsumerWidget {
  MakeAppointment({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context, ref) {
    var businessWatch = ref.watch(selectedBusiness).name;
    var categoryWatch = ref.watch(selectedCategory);
    var now = ref.watch(selectedDate.state).state;
    var timeWatch = ref.watch(selectedTime.state).state;
    var timeIntervalWatch = ref.watch(selectedTimeInterval.state).state;
    final businessRepoProvider = ref.read(businessDetailPageProvider);




    addAppointment()  {
      String myUid = FirebaseAuth.instance.currentUser!.uid;
      String? myMail = FirebaseAuth.instance.currentUser!.email;
      String? myName = FirebaseAuth.instance.currentUser!.displayName;
      String randevuTarihi = ref.read(selectedTime.state).state;
      String randevuSaati = DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state);

      Map<String, dynamic> appointmentMap = {
        "businessAddress": businessRepoProvider.address,
        "businessName": businessRepoProvider.companyName,
        "category": "category",
        "done": false,
        "timeStamp": DateTime.now(),
        "randevuTarihi": randevuTarihi,
        "randevuSaati": randevuSaati,
        "userMail": myMail,
        "userName": myName,
        "userPhone": "",
      };


      String time = DateFormat('kk:mm').format(DateTime.now());
      DatabaseMethods().addAppointment(myUid, time, appointmentMap);
      print(appointmentMap);
      print("Eklendi");
    }


    final String _appbarTitle = businessRepoProvider.companyName;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(_appbarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () => showModalBottomSheet(
              backgroundColor: kThirdColor,
              elevation: 30,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  margin: const EdgeInsets.only(
                      top: 20, right: 20, left: 20, bottom: 20),
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          'Saat ve Tarihiniz : ${ref.read(selectedTime.state).state} - ${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: fontFamiy)),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('İşletme : ${businessRepoProvider.companyName}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: fontFamiy)),
                      const SizedBox(
                        height: 15,
                      ),
                      Text('Adres : ${businessRepoProvider.address}',
                          style: const TextStyle(
                              color: Colors.white, fontFamily: fontFamiy)),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: kThirdColor),
                          onPressed: (() => addAppointment()),
                          child: const Text(
                            'Randevuyu Kaydet',
                            style: TextStyle(
                                fontFamily: fontFamiy, color: Colors.black),
                          ))
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: kSecondaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Text(
                      DateFormat.MMMM().format(now),
                      style: const TextStyle(
                          color: Colors.white, fontFamily: fontFamiy),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${now.day}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: fontFamiy),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat.EEEE().format(now),
                      style: const TextStyle(
                          color: Colors.white, fontFamily: fontFamiy),
                    ),
                  ]),
                ),
                GestureDetector(
                  onTap: (() {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: now.add(const Duration(days: 31)),
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
          Expanded(
              flex: 10,
              child: FutureBuilder(
                future:
                    getMaxAvailableTimeSlot(ref.read(selectedDate.state).state),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var maxTimeInterval = snapshot.data as int;
                    print(snapshot.data);
                    return FutureBuilder(
                      future: getTimeIntervalOfAppointment(
                          DateFormat('dd/MM/yyyy')
                              .format(ref.read(selectedDate.state).state),
                          businessRepoProvider.companyName,
                          DateFormat('dd-MM-yyyy')
                              .format(ref.read(selectedDate.state).state)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          var listTimeInterval = snapshot.data as List<String>;

                          return Container(
                            color: kPrimaryColor,
                            child: GridView.builder(
                                itemCount: Time_Interval.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: maxTimeInterval > index ||
                                            listTimeInterval.contains(
                                                Time_Interval.elementAt(index))
                                        ? null
                                        : () {
                                            ref.read(selectedTime.state).state =
                                                Time_Interval.elementAt(index);
                                            ref
                                                .read(
                                                    selectedTimeInterval.state)
                                                .state = index;
                                          },
                                    child: Card(
                                      color: listTimeInterval.contains(
                                              Time_Interval.elementAt(index))
                                          ? Colors.white10
                                          : maxTimeInterval > index
                                              ? Colors.white60
                                              : ref
                                                          .read(selectedTime
                                                              .state)
                                                          .state ==
                                                      Time_Interval.elementAt(
                                                          index)
                                                  ? Colors.white54
                                                  : Colors.white,
                                      child: GridTile(
                                          header: ref
                                                      .read(selectedTime.state)
                                                      .state ==
                                                  Time_Interval.elementAt(index)
                                              ? const Icon(Icons.check)
                                              : null,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(Time_Interval.elementAt(
                                                  index)),
                                              Text(listTimeInterval.contains(
                                                      Time_Interval.elementAt(
                                                          index))
                                                  ? 'Dolu'
                                                  : maxTimeInterval > index
                                                      ? 'Zaman Geçmiş'
                                                      : 'Mevcut')
                                            ],
                                          )),
                                    ),
                                  );
                                }),
                          );
                        }
                      },
                    );
                  }
                },
              ))
        ],
      ),
    );
  }

  confirmAppointment(
      BuildContext context,
      ref,
      BusinessDetailRepository businessRepoProvider,
      CategoryModal categoryWatch) {
    var timeStamp = DateTime(
            ref.read(selectedDate.state).state.year,
            ref.read(selectedDate.state).state.month,
            ref.read(selectedDate.state).state.day)
        //int.parse(ref.read(selectedDate.state).state),
        // .split(':')[0]
        // .subString(0, 2)),
        //int.parse(ref.read(selectedDate.state).state))
        // .split(':')[1]
        // .subString(0, 2)))
        .millisecondsSinceEpoch;

    var appointmentModel = AppointmentModel(
        businessName: businessRepoProvider.companyName,
        category: categoryWatch.category,
        userName: ref.read(userInformation.state).state.fullName,
        userMail: ref.read(userInformation.state).state.mail,
        done: false,
        businessAddress: businessRepoProvider.address,
        interval: ref.read(selectedTime.state).state,
        timeStamp: timeStamp,
        // 'time':
        //     '${ref.read(selectedTime.state).state}-${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}'
        time:
            DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state),
        date: DateFormat('dd-MM-yyyy')
            .format(ref.read(selectedDate.state).state));

    var batch = FirebaseFirestore.instance.batch();

    // DocumentReference businessAppointment = ref
    //     .read(selectedBusiness.state)
    //     .state
    //     .reference
    //     .collection(
    //         '${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}')
    //     .doc(ref.read(selectedTimeInterval.state).state.toString(),
    //     );

    // DocumentReference userAppointment = FirebaseFirestore.instance
    //     .collection('User')
    //     .doc(FirebaseAuth.instance.currentUser!.email)
    //     .collection('Randevu_${FirebaseAuth.instance.currentUser!.uid}')
    //     .doc();

    // batch.set(businessAppointment, AppointmentModel().toJson());
    // batch.set(userAppointment, AppointmentModel().toJson());
    // batch.commit().then((value) {

    FirebaseFirestore.instance
        .collection('UserHistory')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(
            DateFormat('dd-MM-yyyy').format(ref.read(selectedDate.state).state))
        .doc(ref.read(selectedTime.state).state.toString())
        .set(appointmentModel.toJson());

    FirebaseFirestore.instance
        .collection("Appointment")
        .doc(businessRepoProvider.companyName)
        .collection(
            DateFormat('dd-MM-yyyy').format(ref.read(selectedDate.state).state))
        .doc(ref.read(selectedTime.state).state.toString())
        .set({
      'businessName': businessRepoProvider.companyName,
      'category': categoryWatch.category,
      'userName': ref.read(userInformation.state).state.fullName,
      'userMail': ref.read(userInformation.state).state.mail,
      'done': false,
      'businessAddress': businessRepoProvider.address,
      'interval': ref.read(selectedTime.state).state,
      'timeStamp': timeStamp,
      'time':
          '${ref.read(selectedTime.state).state}-${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}',
      'date':
          '${DateFormat('dd-MM-yyyy').format(ref.read(selectedDate.state).state)}'
    }).then((value) {
      final appointment = Event(
          title: 'Randevu Bilgisi',
          startDate: DateTime(
              ref.read(selectedDate.state).state.year,
              ref.read(selectedDate.state).state.month,
              ref.read(selectedDate.state).state.day),
          endDate: DateTime(
              ref.read(selectedDate.state).state.year,
              ref.read(selectedDate.state).state.month,
              ref.read(selectedDate.state).state.day),
          iosParams: IOSParams(reminder: Duration(minutes: 30)),
          androidParams: AndroidParams(emailInvites: []));

      Add2Calendar.addEvent2Cal(appointment).then((value) {});

      Navigator.popAndPushNamed(context, '/homePage');

      // FirebaseFirestore.instance
      //     .collection('AllBusiness')
      //     .doc(selectedCategory.toString())
      //     .collection("BusinessList")
      //     .doc(value.id)
      //     .collection("Appointment")
      //     .add(appointmentModel.toJson());
    });
    // });

    // ref
    //     .read(selectedAppointment.state)
    //     .state
    //     //.reference
    //     .collection(
    //         '${DateFormat('dd_MM_yyyy').format(ref.read(selectedDate.state).state)}')
    //     .doc(ref.read(selectedTime.state).state.toString())
    //     .set(submitData)
    //     .then((value) {
    //   Navigator.of(context).pop();
    //   // ScaffoldMessenger.of(scaffoldKey.currentContext)
    //   //     .showSnackBar(SnackBar(content: Text('Kayıt işlemi başarılı')));
    //   //Değerleri sıfırlama
    //   ref.read(selectedDate.state).state = DateTime.now();
    //   ref.read(selectedCategory.state).state = BusinessModal();
    //   ref.read(selectedBusiness.state).state = CategoryModal();
    //   ref.read(selectedTime.state).state = '';
    // });
  }
}
