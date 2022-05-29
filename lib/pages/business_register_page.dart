import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/model/CategoryModal.dart';
import 'package:oua_bootcamp/state/state_management.dart';

class BusinessRegister extends ConsumerWidget {
  BusinessRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var businessWatch = ref.watch(userInformation);
    final String _appbarTitle = businessWatch.fullName.toString();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            _appbarTitle,
          ),
        ),
        body: Scaffold(
          body: SingleChildScrollView(
              child: Column(children: [
            Container(
              height: 200,
              child: FutureBuilder(
                future: getCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  else {
                    var categories = snapshot.data as List<CategoryModal>;
                    if (categories == null || categories.length == 0)
                      return Center(
                        child: Text('Kategori bulunamadı'),
                      );
                    return ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              print(categories[index].category.toString());
                            },
                            child: ListTile(
                              title:
                                  Text(categories[index].category.toString()),
                            ),
                          );
                        });
                  }
                },
              ),
            )
          ])),
        ));
  }
}
