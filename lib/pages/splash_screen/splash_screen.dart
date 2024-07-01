import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/utils/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
      Future.delayed(Duration(seconds: 3),(){
        context.go('/home');
      });
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Center(
          child: logo(),
        ),
      ),
    );
  }


}
