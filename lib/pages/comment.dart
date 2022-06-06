import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../constants.dart';
import 'package:oua_bootcamp/model/review_model.dart';

class Reviews extends StatefulWidget {
  Reviews({Key? key}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  bool isMore = false;
  List<double> ratings = [0.1, 0.3, 0.5, 0.7, 0.9];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: kWhiteColor,
          body: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 8.0, top: 8.0),
                  itemCount: reviewList.length,
                  itemBuilder: (context, index) {
                    return ReviewUI(
                      image: reviewList[index].image,
                      name: reviewList[index].name,
                      date: reviewList[index].date,
                      comment: reviewList[index].comment,
                      rating: reviewList[index].rating,
                      onPressed: () => print("More Action $index"),
                      onTap: () => setState(() {
                        isMore = !isMore;
                      }),
                      isLess: isMore,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 2.0,
                      color: kAccentColor,
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}

class ReviewUI extends StatelessWidget {
  String? image, name, date, comment;
  double? rating;
  Function? onTap, onPressed;
  bool? isLess;

  ReviewUI({
    Key? key,
    this.image,
    this.name,
    this.date,
    this.comment,
    this.rating,
    this.onTap,
    this.isLess,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.0,
        bottom: 2.0,
        left: 16.0,
        right: 0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 45.0,
                width: 45.0,
                margin: EdgeInsets.only(right: 16.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image!),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(44.0),
                ),
              ),
              Expanded(
                child: Text(
                  name!,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              RatingBar.builder(
                itemSize: 25,
                initialRating: rating!,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.orange,
                ),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              ),
              SizedBox(width: kFixPadding),
              Text(
                date!,
                style: TextStyle(fontSize: 18.0),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () => {},
            child: isLess!
                ? Text(
                    comment!,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: kLightColor,
                    ),
                  )
                : Text(
                    comment!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: kLightColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

final reviewList = [
  ReviewModal(
    image: "assets/images/user.png",
    name: "Doruk Ege",
    rating: 4,
    date: "05 June 2022",
    comment: "Harika",
  ),
  ReviewModal(
    image: "assets/images/user.png",
    name: "Fatma Özlem",
    rating: 5,
    date: "06 June 2022",
    comment: "Çok iyi.",
  ),
  ReviewModal(
    image: "assets/images/user.png",
    name: "Kenan Atan",
    rating: 4.5,
    date: "03 June 2022",
    comment: "Müthiş.",
  ),
  ReviewModal(
    image: "assets/images/user.png",
    name: "Onur Bayrak",
    rating: 2,
    date: "01 June 2022",
    comment: "Kötü",
  ),
  ReviewModal(
    image: "assets/images/user.png",
    name: "Seda Sayar",
    rating: 1,
    date: "06 June 2022",
    comment: "Çok kötü.",
  ),
  ReviewModal(
    image: "assets/images/user.png",
    name: "Ali Veli",
    rating: 3,
    date: "08 June 2022",
    comment: "İyi.",
  ),
];
