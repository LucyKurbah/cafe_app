import 'package:cafe_app/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadUserInfo() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false);
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _loadUserInfo();
    });
    //  _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height,
      // child: const Center(
      //   child: CircularProgressIndicator(),
      // ),
    );
  }
}
