import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../sercices/database.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _dropDownValue = '';
  bool _isBusiness = false;
  final List<String> _items = [];
  final Map<String, dynamic> _allBusiness = {};
  final String _isletmeHakkinda = "İşletme Hakkında";
  final String _address = "Adres";
  final String _phone = "Telefon Numarası";
  final String _subtitle = "Kısa Açıklama";
  // final var _fotograflar = "Fotoğraf ekleme yapılacak";

  String? isletmeHakkinda, address, phone, subtitle;


  getAllBusiness()async{
    QuerySnapshot querySnapshot = await DatabaseMethods().getBusinessList();
    for(int i = 0; i<querySnapshot.docs.length; i++){
      print(querySnapshot.docs[i]["category"].toString());
      _items.add(querySnapshot.docs[i]["category"].toString());
    }
    _dropDownValue = querySnapshot.docs[0]["category"].toString();
    setState(() {});
  }


  @override
  initState(){
    getAllBusiness();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    _allBusiness.addAll({"isBusiness": false});
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Kayıt Ol"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Bireysel"),
                  Switch(
                      value: _isBusiness,
                      onChanged: (value){
                        setState(() {
                          _isBusiness = value;
                          _allBusiness.addAll({"isBusiness": value});
                        });                }
                  ),
                  const Text("İşletme"),
                ],
              ),
              Visibility(
                visible: _isBusiness,
                child: DropdownButton(
                  // İlk gösterilecek değer
                  value: _dropDownValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  // Değerlerin listesi
                  items: _items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  // Değişiklikten sonra ekranda gösterilmesi için
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropDownValue = newValue!;
                      _allBusiness.addAll({"category": newValue});
                    });
                  },
                ),
              ),
              Visibility(
                visible: _isBusiness,
                child: Column(
                  children: [
                    textField(_isletmeHakkinda),
                    textField(_address),
                    textField(_phone),
                    textField(_subtitle),
                    //    textField(_fotograflar),
                  ],
                ),
              ),
              Visibility(
                visible: !_isBusiness,
                child: Column(
                  children: [
                    textField(_phone),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if(_isBusiness){
                      _allBusiness.addAll(
                          {
                            "content": isletmeHakkinda,
                            "address": address,
                            "phone": phone,
                            "subtitle": subtitle,
                          }
                      );
                    }
                    Navigator.pop(context,_allBusiness);
                  }, child: const Text("Kayıt ol"))
            ],
          ),
        ),
      ),
    );
  }


  TextField textField(String text) {
    return TextField(
      onChanged: (value) {
        if(text == _isletmeHakkinda){
          isletmeHakkinda = value;
        }else if (text == _address){
          address = value;
        }else if(text == _phone){
          phone = value;
        }else if(text == _subtitle){
          subtitle = value;
        }

      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 20),
          border: InputBorder.none,
          hintText: text,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.square,
              size: 30,
              color: Colors.green,
            ),
          ),
          hintStyle: const TextStyle(
            fontSize: 30,
            color: Colors.black,
          )),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
    );
  }
}