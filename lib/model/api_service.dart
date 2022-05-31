import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:logger/logger.dart';
import 'package:oua_bootcamp/model/appointment.dart';

class ApiService {
  String? _baseUrl;

  static final ApiService _instance = ApiService._privateConstructor();
  ApiService._privateConstructor() {
    _baseUrl = "https://oua-bootcamp-default-rtdb.firebaseio.com/";
  }

  static ApiService getInstance() {
    if (_instance == null) {
      return ApiService._privateConstructor();
    }
    return _instance;
  }

  Future<void> addAppointment(AppointmentModel model) async {
    final jsonBody = json.encode(model.toJson());
    final response = await http.post(Uri.parse("$_baseUrl/appointment.json"),
        body: jsonBody);

    final jsonResponse = json.decode(response.body);

    switch (response.statusCode) {
      case HttpStatus.ok:
        return Future.value();
      case HttpStatus.unauthorized:
        debugPrint("Error Unauthoriaze");
        Logger().e(jsonResponse);
        break;
    }
    return Future.error(jsonResponse);
  }

  Future<List<AppointmentModel>> getAppointment() async {
    final response = await http.get(Uri.parse("$_baseUrl/appointment.json"));

    final jsonResponse = json.decode(response.body);

    // switch (response.statusCode) {
    //   case HttpStatus.ok:
    //     final appointmentList = AppointmentModel.fromJson(jsonResponse);
    //     return null;

    //   case HttpStatus.unauthorized:
    //     debugPrint("Error Unauthoriaze");
    //     Logger().e(jsonResponse);
    //     break;
    // }

    return Future.error(jsonResponse);
  }
}
