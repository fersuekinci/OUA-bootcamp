import 'package:flutter/material.dart';
import '../widgets/menu_widget.dart';


// Galeriden fotoğraf seçme işlemleri yapılacak

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const MenuWidget()),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.red.shade700,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 150, child: Image(image: AssetImage("assets/images/avatar.png"))),
                const SizedBox(height: 50),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const Attributes(title: "Mail", icon: Icons.mail_outline_outlined, isPassword: false),
                      const SizedBox(height: 15),
                      const Attributes(title: "Password", icon: Icons.password_outlined, isPassword: true),
                      const SizedBox(height: 15),
                      const Attributes(title: "İşletme Adı", icon: Icons.circle_notifications, isPassword: false),
                      const SizedBox(height: 15),
                      const Attributes(title: "İşletme Fotoğrafları", icon: Icons.photo_album, isPassword: false),
                      const SizedBox(height: 15),
                      const Attributes(title: "İşletme Detayları", icon: Icons.star, isPassword: false),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red.shade600,
                            minimumSize: Size(MediaQuery.of(context).size.width - 75, 40)),
                        child: const Text("Kayıt ol Butonu"),
                        onPressed: () {
                          print("Kayıt ol butonu çalıştı.");
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Attributes extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isPassword;

  const Attributes({Key? key, required this.title, required this.icon, required this.isPassword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0),
      alignment: Alignment.centerRight,
      color: Colors.red.shade600,
      height: 50.0,
      width: MediaQuery.of(context).size.width - 75,
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'OpenSans',
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.only(top: 14.0),
          prefixIcon: Icon(
            icon,
            color: Colors.white,
          ),
          hintText: title,
        ),
      ),
    );
  }
}
