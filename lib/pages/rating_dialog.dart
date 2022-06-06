import "package:flutter/material.dart";
import 'package:oua_bootcamp/pages/category_page.dart';
import "package:rating_dialog/rating_dialog.dart";

import '../constants.dart';

class MyRatingDialogScreen extends StatefulWidget {
  @override
  _MyRatingDialogScreenState createState() => _MyRatingDialogScreenState();
}
class _MyRatingDialogScreenState extends State<MyRatingDialogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton(
              child: Text( 'Rating Dialog', style: TextStyle(color: Colors.white, fontSize: 25) ),
          style: ElevatedButton.styleFrom(
              primary: kSecondaryColor,
              elevation: 5,
              shape: const BeveledRectangleBorder( borderRadius: BorderRadius.all(Radius.circular(5))),
              padding: EdgeInsets.all(12)
          ),
          onPressed: showRatingDialog,
        ),
      ),
    ));
  }

  void showRatingDialog() {
    final ratingDialog = RatingDialog(
      title: Text('Rate this app'),
      message: Text('If you enjoy using this app, would you mind taking a moment to rate it? Thank you for your support!'),
      submitButtonText: 'Submit',
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) {
        print('rating: ${response.rating}, ');
        print('comment: ${response.comment}');
      },
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ratingDialog,
    );
  }
}