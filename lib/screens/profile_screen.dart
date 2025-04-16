import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? photoUrl;
  String? firstName;
  String? lastName;
  String? role;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    if (user == null) return;
    final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
    final data = doc.data() as Map<String, dynamic>;

    setState(() {
      photoUrl = data['photoUrl'];
      firstName = data['firstName'];
      lastName = data['lastName'];
      role = data['role'];
    });
  }

  Future<void> uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures')
        .child('${user!.uid}.jpg');

    await storageRef.putFile(File(pickedFile.path));
    final imageUrl = await storageRef.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'photoUrl': imageUrl,
    });

    setState(() {
      photoUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl!)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: uploadProfilePicture,
              child: const Text('Change Profile Picture'),
            ),
            const SizedBox(height: 24),
            if (firstName != null && lastName != null)
              Text("Name: $firstName $lastName", style: const TextStyle(fontSize: 18)),
            if (role != null)
              Text("Role: $role", style: const TextStyle(fontSize: 16)),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}
