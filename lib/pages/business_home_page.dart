import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oua_bootcamp/state/state_management.dart';

class BusinessHomePage extends ConsumerWidget {
  BusinessHomePage({Key? key}) : super(key: key);

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
            Card(
                child: ElevatedButton(
              child: Text('Kaydol'),
              onPressed: () {
                Navigator.of(context).pushNamed('/businessRegister');
              },
            )),
          ])),
        ));
  }
}
