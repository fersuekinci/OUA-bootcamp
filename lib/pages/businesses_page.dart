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
import 'package:oua_bootcamp/pages/chat_history_page.dart';
import 'package:oua_bootcamp/pages/make_appointment.dart';
import 'package:oua_bootcamp/repositories/repo_business_detail.dart';
import 'package:oua_bootcamp/repositories/repo_categories.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/utils/utils.dart';
import 'package:oua_bootcamp/widgets/alert.dart';

class Businesses extends ConsumerWidget {
  List<BusinessModal> businessList = [];

  Businesses({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, ref) {
    final categoriesRepoProvider = ref.watch(categoriesPageProvider);
    ;

    final String appbarTitle = categoriesRepoProvider.category.toString();

    return Scaffold(
        backgroundColor: kSecondaryColor,
        appBar: AppBar(
          title: Text(appbarTitle),
          automaticallyImplyLeading: false,
        ),
        body: getBody(context, ref, categoriesRepoProvider));
  }

  getBody(context, ref, CategoriesRepository categoriesRepoProvider) {
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: SpinKitThreeInOut(
                                  color: kThirdColor,
                                ),
                              );
                            }
                            var categories =
                                snapshot.data as List<CategoryModal>;
                            if (categories == null || categories.isEmpty) {
                              return const Center(
                                child: Text('Kategori bulunamadı'),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  categoriesRepoProvider.category =
                                      categories[index].category.toString();
                                  categoriesRepoProvider.notifyAll();
                                },
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
                                            categoriesRepoProvider.category
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
          getBusinessList(
              context, ref, categoriesRepoProvider, businessRepoProvider),
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
                  //  AuthMethods().signInWithGoogle(context);
                  //   AuthMethods().signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChatHistoryPage()));
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
    switch (action) {
      case SlidableAction.appointment:
        if (FirebaseAuth.instance.currentUser?.email == null) {
          getAlert(
                  context,
                  ref,
                  'Seçilen işletmeden randevu alabilmek için giriş yapmanız ya da kayıt olmanız gerekmektedir',
                  'Giriş Yap')
              .show();
        } else {
          businessRepoProvider.companyName =
              businessList[index].name.toString();
          businessRepoProvider.address = businessList[index].address.toString();
          businessRepoProvider.content = businessList[index].content.toString();
          businessRepoProvider.phone = businessList[index].phone.toString();
          businessRepoProvider.subtitle =
              businessList[index].subtitle.toString();
          businessRepoProvider.email = businessList[index].email.toString();
          businessRepoProvider.notifyAll();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MakeAppointment()));
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

  getBusinessList(context, ref, categoriesRepoProvider, businessRepoProvider) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 150,
      child: FutureBuilder(
          future:
              getBusinessByCategory(categoriesRepoProvider.category.toString()),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
    );
  }
}
