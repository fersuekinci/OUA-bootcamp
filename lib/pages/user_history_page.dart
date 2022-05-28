import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/cloud_firestore/user_ref.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/model/business_model.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';
import 'package:provider/provider.dart';

class UserHistoryPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    final String _appbarTitle = 'Geçmiş';
    return Scaffold(
        appBar: AppBar(leading: const MenuWidget(), title: Text(_appbarTitle)),
        body: FutureBuilder(
            future: getUserHistory(DateFormat('dd-MM-yyyy')
                .format(ref.read(selectedDate.state).state)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var userAppointments = snapshot.data as List<AppointmentModel>;
                print(userAppointments);
                if (userAppointments == null || userAppointments.length == 0) {
                  return const Center(
                    child: Text('Geçmiş bulunamadı'),
                  );
                } else {
                  return ListView.builder(
                      itemCount: userAppointments.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 20,
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                leading:
                                    const Icon(Icons.arrow_drop_down_circle),
                                title: Text(userAppointments[index]
                                    .businessName
                                    .toString()),
                                subtitle: Text(
                                  'Secondary Text',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () => null,
                                    child: const Text('İptal Et'),
                                  ),
                                ],
                              ),
//Image.asset('assets/card-sample-image.jpg'),
                            ],
                          ),
                        );
                      });
                }
              }
            }));
  }
}
