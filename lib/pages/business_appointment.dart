import 'dart:collection';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/model/api_service.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/widgets/calendar_utils.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class BusinessAppointment extends StatefulWidget {
  const BusinessAppointment({Key? key}) : super(key: key);

  @override
  State<BusinessAppointment> createState() => _BusinessAppointmentState();
}

class _BusinessAppointmentState extends State<BusinessAppointment> {
  final String _appbarTitle = 'Randevu Al';
  late final ValueNotifier<List<AppointmentModel>> _selectedAppointment;
  late TextEditingController eventController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  ApiService service = ApiService.getInstance();
  List<AppointmentModel> appointmentList = [];

  @override
  void initState() {
    super.initState();
    eventController = TextEditingController();
    _selectedDay = _focusedDay;
    _selectedAppointment = ValueNotifier(_getAppointmentsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedAppointment.dispose();
    super.dispose();
  }

  List<AppointmentModel> _getAppointmentsForDay(DateTime day) {
    return appointmentList;
  }

  List<AppointmentModel> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getAppointmentsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedAppointment.value = _getAppointmentsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedAppointment.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedAppointment.value = _getAppointmentsForDay(start);
    } else if (end != null) {
      _selectedAppointment.value = _getAppointmentsForDay(end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appbarTitle),
        leading: const MenuWidget(),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.only(right: 15, left: 15),
            elevation: 15,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TableCalendar<AppointmentModel>(
                locale: 'tr_TR',
                availableCalendarFormats: const {
                  CalendarFormat.week: 'Hafta',
                  CalendarFormat.month: 'Ay',
                  CalendarFormat.twoWeeks: '2 Hafta',
                },
                headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonDecoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                    formatButtonTextStyle: const TextStyle(color: Colors.white),
                    formatButtonShowsNext: false),
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getAppointmentsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: const CalendarStyle(
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
              child: FutureBuilder<List<AppointmentModel>>(
            future: service.getAppointment(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  appointmentList = snapshot.data!;
                  return Container(
                    padding: EdgeInsets.only(right: 15, left: 15),
                    child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 10,
                            child: ListTile(
                              tileColor: kSecondColor,
                              onTap: () {},
                              title: Text(
                                '${appointmentList[index].category.toString()} \n${appointmentList[index].time.toString()}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: appointmentList.length),
                  );

                default:
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.all(75),
                      child: const LinearProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  );
              }
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  _showAddDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: eventController,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (eventController.text.isEmpty) return;
                      setState(() {
                        _addFirebase();
                        // kEvents.addAll({
                        //   _focusedDay: [Event(eventController.text)]
                        // });
                        eventController.clear();
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Kaydet'))
              ],
            ));
  }

  _addFirebase() async {
    // var model = AppointmentModel(
    //     tarih: dateFormat.format(_focusedDay), icerik: eventController.text);
    // await ApiService.getInstance().addAppointment(model);
  }
}
