import 'package:oua_bootcamp/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter/material.dart';

Alert getAlert(context, String content, String title) {
  return Alert(
      style: AlertStyle(
          titleStyle: TextStyle(fontFamily: fontFamiy, fontSize: 16),
          descStyle: TextStyle(fontFamily: fontFamiy, fontSize: 16),
          backgroundColor: Colors.white,
          alertElevation: 20),
      context: context,
      type: AlertType.warning,
      title: title,
      desc: content,
      buttons: [
        DialogButton(
            color: Colors.red,
            child: Text(
              'Vazgeç',
              style: TextStyle(color: Colors.white, fontFamily: fontFamiy),
            ),
            onPressed: () => Navigator.of(context).pop()),
        DialogButton(
            color: kPrimaryColor,
            child: Text('Giriş Yap',
                style: TextStyle(color: Colors.white, fontFamily: fontFamiy)),
            onPressed: () {})
      ]);
}
