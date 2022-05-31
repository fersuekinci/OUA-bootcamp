import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/cloud_firestore/all_business_ref.dart';
import 'package:oua_bootcamp/model/business_model.dart';
import 'package:oua_bootcamp/repositories/repo_business_detail.dart';
import 'package:oua_bootcamp/state/state_management.dart';
import 'package:oua_bootcamp/widgets/menu_widget.dart';
import 'business_detail_page.dart';

class Businesses extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    var categoryWatch = ref.watch(selectedCategory);

    final businessRepoProvider = ref.read(businessDetailPageProvider);


    return Scaffold(
        appBar: AppBar(leading: const MenuWidget(), title: Text("???")),
        body: FutureBuilder(
            future: getBusinessByCategory(categoryWatch.category.toString()),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var business = snapshot.data as List<BusinessModal>;
                if (business == null || business.length == 0) {
                  return const Center(
                    child: Text('İşletme bulunamadı'),
                  );
                } else {
                  return ListView.builder(
                      itemCount: business.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {

                            businessRepoProvider.companyName = business[index].name.toString();
                            businessRepoProvider.address = business[index].address.toString();
                            businessRepoProvider.content = business[index].content.toString();
                            businessRepoProvider.phone = business[index].phone.toString();
                            businessRepoProvider.subtitle = business[index].subtitle.toString();
                            businessRepoProvider.notifyAll();

                            Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessDetail()));

                           /* Navigator.pushNamed(context, '/businessDetail',
                                arguments: ref
                                    .read(selectedBusiness.state)
                                    .state = business[index]);

                            */

                          },
                          child: Card(
                            elevation: 20,
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                ListTile(
                                  leading:
                                      const Icon(Icons.arrow_drop_down_circle),
                                  title: Text(business[index].name.toString()),
                                  subtitle: Text(
                                    'Secondary Text',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Greyhound divisively hello coldly wonderfully marginally far upon excluding.',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton(
                                      onPressed: () => Navigator.pushNamed(
                                          context, '/makeAppointment',
                                          arguments: ref
                                                  .read(selectedBusiness.state)
                                                  .state
                                                  .name =
                                              business[index].name.toString()),
                                      child: const Text('Randevu Oluştur'),
                                    ),
                                  ],
                                ),
                                //Image.asset('assets/card-sample-image.jpg'),
                              ],
                            ),
                          ),
                        );
                      });
                }
              }
            }));
  }
}
