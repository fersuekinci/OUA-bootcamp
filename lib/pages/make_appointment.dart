import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/model/business_model.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/utils/utils.dart';

class MakeAppointment extends ConsumerWidget {
  MakeAppointment({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context, ref) {
    var businessWatch = ref.watch(selectedBusiness);
    var now = ref.watch(selectedDate.state).state;
    var timeWatch = ref.watch(selectedTime.state).state;
    var timeIntervalWatch = ref.watch(selectedTimeInterval.state).state;

    final String _appbarTitle = businessWatch.name.toString();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(_appbarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        Text(
                            '${ref.read(selectedTime.state).state} - ${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text('${ref.read(selectedBusiness.state).state.name}'),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            '${ref.read(selectedBusiness.state).state.address}'),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            onPressed: (() => confirmAppointment(context, ref)),
                            child: const Text('Randevuyu Kaydet'))
                      ],
                    ));
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: kSecondColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(children: [
                        Text(
                          DateFormat.MMMM().format(now),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${now.day}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          DateFormat.EEEE().format(now),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ]),
                    ),
                  ),
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
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.calendar_today,
                        color: kFourthColor,
                      ),
                    ),
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
                          businessWatch.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          var listTimeInterval = snapshot.data as List<String>;

                          return GridView.builder(
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
                                              .read(selectedTimeInterval.state)
                                              .state = index;
                                        },
                                  child: Card(
                                    color: listTimeInterval.contains(
                                            Time_Interval.elementAt(index))
                                        ? Colors.white10
                                        : maxTimeInterval > index
                                            ? Colors.white60
                                            : ref
                                                        .read(
                                                            selectedTime.state)
                                                        .state ==
                                                    Time_Interval.elementAt(
                                                        index)
                                                ? Colors.white54
                                                : Colors.white,
                                    child: GridTile(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                Time_Interval.elementAt(index)),
                                            Text(listTimeInterval.contains(
                                                    Time_Interval.elementAt(
                                                        index))
                                                ? 'Dolu'
                                                : maxTimeInterval > index
                                                    ? 'Uygun Değil'
                                                    : 'Mevcut')
                                          ],
                                        ),
                                        header: ref
                                                    .read(selectedTime.state)
                                                    .state ==
                                                Time_Interval.elementAt(index)
                                            ? const Icon(Icons.check)
                                            : null),
                                  ),
                                );
                              });
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

  confirmAppointment(BuildContext context, ref) {
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

    var submitData = {
      // 'businessId': ref.read(selectedBusiness.state).state.docId,
      'businessName': ref.read(selectedBusiness.state).state.name,
      'category': ref.read(selectedCategory.state).state.category,
      'userName': ref.read(userInformation.state).state.fullName,
      'userMail': ref.read(userInformation.state).state.mail,
      'done': false,
      'businessAddress': ref.read(selectedBusiness.state).state.address,
      'interval': ref.read(selectedTime.state).state,
      'timeStamp': timeStamp,
      // 'time':
      //     '${ref.read(selectedTime.state).state}-${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}'
      'time':
          DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)
    };

    FirebaseFirestore.instance.collection("Appointment").add({
      'businessName': ref.read(selectedBusiness.state).state.name,
      'category': ref.read(selectedCategory.state).state.category,
      'userName': ref.read(userInformation.state).state.fullName,
      'userMail': ref.read(userInformation.state).state.mail,
      'done': false,
      'businessAddress': ref.read(selectedBusiness.state).state.address,
      'interval': ref.read(selectedTime.state).state,
      'timeStamp': timeStamp,
      'time':
          '${ref.read(selectedTime.state).state}-${DateFormat('dd/MM/yyyy').format(ref.read(selectedDate.state).state)}'
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

      FirebaseFirestore.instance
          .collection("BusinessList")
          .doc(value.id)
          .collection("Appointment")
          .add(submitData);
    });

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
