// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: controller,
        ),
        actions: [
          IconButton(
            onPressed: (){
                final name = controller.text;
                //createUser(name: name);
            }, 
            icon: Icon(Icons.add))
        ],
      ),
    );
  }
  
  // Future createUser({required String name}) async {
  //   final docUser = FirebaseFirestore.instance.collection('users').doc('12345');
  //   final json ={
  //     'name' : name
  //   };
  //   await docUser.set(json);
  // }
}