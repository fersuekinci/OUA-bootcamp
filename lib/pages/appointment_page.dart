import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helperfun/sharedpref_helper.dart';
import '../sercices/database.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({Key? key}) : super(key: key);

  @override
  State<AppointmentsPage> createState() => _AppointmentsPagePageState();
}

class _AppointmentsPagePageState extends State<AppointmentsPage> {
  String? myName, myProfilePic, myUserName, myEmail;
  Stream<QuerySnapshot>? appointmentsStream;
  QuerySnapshot? usersStream;

  getMyInfoFromSharedPreference() async {
    myName = await SharedPreferenceHelper().getDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserProfileUrl();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  getAppointments() async {
    String myUid = FirebaseAuth.instance.currentUser!.uid;
    appointmentsStream = await DatabaseMethods().getAppointment(myUid);
    print(myName);
    setState(() {});
  }


  Widget appointmentsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: appointmentsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print(snapshot.hasData);
        print(snapshot.data?.docs.length);
        return snapshot.hasData
            ? ListView.builder(
            itemCount: snapshot.data?.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data?.docs[index] as DocumentSnapshot<Object?>;
              Timestamp tsdate = ds["timeStamp"];
              String randevuAlanName = ds["userName"];
            //  String randevuAlanTelefon = ds["phone"];
              String date = ds["randevuTarihi"];
              String time = ds["randevuSaati"];
              return AppointmentsListTile(
                  randevuAlanName, date, time, ds);
            })
            : const Center(child: const CircularProgressIndicator());
      },
    );
  }

  @override
  void initState() {
    print("init çalıştı");
    getMyInfoFromSharedPreference();
    getAppointments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Randevular"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: appointmentsList(),
      ),
    );
  }
}

class AppointmentsListTile extends StatefulWidget {
  final String randevuAlanIsim, dtDate, dtTime;
  final DocumentSnapshot ds;
  AppointmentsListTile(this.randevuAlanIsim, this.dtDate, this.dtTime, this.ds);

  @override
  _AppointmentsListTileState createState() => _AppointmentsListTileState();
}

class _AppointmentsListTileState extends State<AppointmentsListTile> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.ds["businessAddress"]);
        print(widget.ds["businessName"]);
        print(widget.ds["category"]);
        print(widget.ds["done"]);
        print(widget.ds["userMail"]);
        print(widget.ds["userName"]);

      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.randevuAlanIsim,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(widget.ds["userPhone"])
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.dtDate),
                Text(widget.dtTime),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
