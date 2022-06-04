import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/constants.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/model/business_model.dart';
import 'package:oua_bootcamp/pages/business_detail_page.dart';
import 'package:oua_bootcamp/repositories/repo_business_detail.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../sercices/auth.dart';

// ignore: must_be_immutable
class Businesses extends ConsumerWidget {
  List<BusinessModal> businessList = [];

  Businesses({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    var categoryWatch = ref.watch(selectedCategory);
    final String appbarTitle = categoryWatch.category.toString();

    return Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: AppBar(
          title: Text(appbarTitle),
          automaticallyImplyLeading: false,
        ),
        body: getBody(context, ref, categoryWatch));
  }

  getBody(context, ref, CategoryModal categoryWatch) {
    final businessRepoProvider = ref.read(businessDetailPageProvider);
    return SafeArea(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
                height: 30,
                width: MediaQuery.of(context).size.width - 30,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                          future: getCategory(),
                          builder: (context, snapshot) {
                            var categories =
                                snapshot.data as List<CategoryModal>;
                            if (categories == null || categories.isEmpty) {
                              return const Center(
                                child: Text('Kategori bulunamadı'),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, '/businessList',
                                    arguments: ref
                                            .read(selectedCategory.state)
                                            .state
                                            .category =
                                        categories[index].category.toString()),
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                    left: kDefaultPadding,
                                    right: index == categories.length - 1
                                        ? kDefaultPadding
                                        : 0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: kDefaultPadding),
                                  decoration: BoxDecoration(
                                    //color: kPrimaryColor,
                                    color: categories[index].category ==
                                            categoryWatch.category
                                        ? kPrimaryColor.withOpacity(0.5)
                                        : kPrimaryColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    categories[index].category.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }
                          });
                    }),
              ),
              const SizedBox(
                  width: 30,
                  child: Icon(
                    Icons.arrow_right,
                    size: 40,
                    color: kThirdColor,
                  )),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: FutureBuilder(
                future:
                    getBusinessByCategory(categoryWatch.category.toString()),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      businessList = snapshot.data!;
                      return listView(ref, businessRepoProvider);

                    default:
                      return const Center(
                        child: SpinKitThreeInOut(
                          color: kThirdColor,
                        ),
                      );
                  }
                }),
          ),
        ],
      ),
    );
  }

  Widget listView(ref, businessRepoProvider) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.separated(
        itemCount: businessList.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) => Card(
            color: kThirdColor,
            elevation: 15,
            clipBehavior: Clip.antiAlias,
            child: Slidable(
              key: Key(businessList[index].key.toString()),
              // dismissal: SlidableDismissal(
              //   child: const SlidableDrawerDismissal(),
              //   onDismissed: (type) {
              //     final action = type == SlideActionType.primary
              //         ? SlidableAction.appointment
              //         : SlidableAction.detail;
              //     onDismissed(
              //         index, action, context, ref, businessRepoProvider);
              //   },
              // ),
              actionPane: const SlidableDrawerActionPane(),
              actions: [
                IconSlideAction(
                    caption: 'Randevu Al',
                    color: kFifthColor,
                    icon: Icons.calendar_month,
                    onTap: () {
                      onDismissed(index, SlidableAction.appointment, context,
                          ref, businessRepoProvider);
                    })
              ],
              secondaryActions: [
                IconSlideAction(
                    caption: 'Detayları Gör',
                    color: kFourthColor,
                    icon: Icons.remove_red_eye,
                    onTap: () {
                      onDismissed(index, SlidableAction.detail, context, ref,
                          businessRepoProvider);
                    }),
              ],
              child: GestureDetector(
                onTap: () {
                  AuthMethods().signInWithGoogle(context);
                  //AuthMethods().signOut();
                },
                child: Column(
                  children: [
                    ListTile(
                      isThreeLine: true,
                      //leading: Icon(Icons.business_center),
                      title: Text(businessList[index].name.toString()),
                      subtitle: Text(
                        '${businessList[index].subtitle.toString()} \n${businessList[index].address.toString()}',
                        style: TextStyle(color: Colors.black.withOpacity(0.6)),
                      ),

                      // trailing: Column(
                      //   children: [
                      //     if (businessList[index]. == true) ...[
                      //       Icon(
                      //         Icons.favorite_outline,
                      //         color: Colors.red,
                      //       ),
                      //     ] else ...[
                      //       Icon(
                      //         Icons.favorite,
                      //       ),
                      //     ],
                      //   ],
                      // ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Future<void> onDismissed(int index, SlidableAction action, context, ref,
      businessRepoProvider) async {
    // setState(() => businessList.removeAt(index));

    switch (action) {
      case SlidableAction.appointment:
        if (FirebaseAuth.instance.currentUser?.email == null) {
          alertMethod(context).show();
        } else {
          Navigator.pushNamed(context, '/makeAppointment',
              arguments: ref.read(selectedBusiness.state).state.name =
                  businessList[index].name.toString());
        }

        break;
      case SlidableAction.detail:
        businessRepoProvider.companyName = businessList[index].name.toString();
        businessRepoProvider.address = businessList[index].address.toString();
        businessRepoProvider.content = businessList[index].content.toString();
        businessRepoProvider.phone = businessList[index].phone.toString();
        businessRepoProvider.subtitle = businessList[index].subtitle.toString();
        businessRepoProvider.email = businessList[index].email.toString();
        businessRepoProvider.notifyAll();

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BusinessDetail()));
        break;
    }
  }

  Alert alertMethod(context) {
    return Alert(
            style: AlertStyle(
                titleStyle: TextStyle(fontFamily: fontFamiy, fontSize: 16),
                descStyle: TextStyle(fontFamily: fontFamiy, fontSize: 16),
                backgroundColor: Colors.white,
                alertElevation: 20),
            context: context,
            type: AlertType.warning,
            title: 'Randevu Al',
            desc:
                'Seçilen işletmeden randevu alabilmek için giriş yapmanız ya da kayıt olmanız gerekmektedir. ',
            buttons: [
              DialogButton(
                  color: Colors.red,
                  child: Text(
                    'Vazgeç',
                    style:
                        TextStyle(color: Colors.white, fontFamily: fontFamiy),
                  ),
                  onPressed: () => Navigator.of(context).pop()),
              DialogButton(
                  color: kPrimaryColor,
                  child: Text('Giriş Yap',
                      style: TextStyle(
                          color: Colors.white, fontFamily: fontFamiy)),
                  onPressed: () {})
            ]);
  }
}
