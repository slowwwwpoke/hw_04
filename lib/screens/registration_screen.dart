import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();

  void _register() async {
    try {
      final userCred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        'role': 'user',
        'registrationDatetime': DateTime.now(),
      });

      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      print('Register Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
          TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
          TextField(controller: _firstName, decoration: InputDecoration(labelText: 'First Name')),
          TextField(controller: _lastName, decoration: InputDecoration(labelText: 'Last Name')),
          ElevatedButton(onPressed: _register, child: Text("Register")),
          TextButton(onPressed: () => Navigator.pushReplacementNamed(context, '/login'), child: Text("Login instead")),
        ]),
      ),
    );
  }
}
