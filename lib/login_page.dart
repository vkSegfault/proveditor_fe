import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,  // remove back button
      ),
      body: Center(
        child: Column(children:
        [
          Wrap(
            spacing: 20,
            children: [
              ElevatedButton( style: ElevatedButton.styleFrom( minimumSize: const Size(400, 50), backgroundColor: Colors.amber[700], shape: const StadiumBorder() ), onPressed: () {}, child: const Text("Login") ),
              ElevatedButton( style: ElevatedButton.styleFrom( minimumSize: const Size(400, 50), backgroundColor: Colors.amber[700], shape: const StadiumBorder() ), onPressed: () {}, child: const Text("Login") ),
              ElevatedButton(onPressed: () {}, child: const Text("Register") )
            ],
          ),
        ],) ),
    );
  }
}