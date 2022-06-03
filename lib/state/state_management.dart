import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/model/appointment.dart';
import 'package:oua_bootcamp/model/business_model.dart';
import 'package:oua_bootcamp/model/user_model.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref) => '');
final forceReload = StateProvider((ref) => false);

//CategoryState
final currentState = StateProvider((ref) => 1);
final selectedCategory = StateProvider((ref) => CategoryModal());
final selectedBusiness = StateProvider((ref) => BusinessModal());
final selectedAppointment = StateProvider((ref) => AppointmentModel());
final userInformation = StateProvider((ref) => UserModel());
final selectedDate = StateProvider((ref) => DateTime.now());

//Zaman aralığı seçmeden ilerleyememsi için kullanılacak
final selectedTimeInterval = StateProvider((ref) => -1);
final selectedTime = StateProvider((ref) => '');

final deleteFlagRefresh = StateProvider((ref) => false);
