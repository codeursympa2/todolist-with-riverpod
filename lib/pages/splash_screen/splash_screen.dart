import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/utils/common_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  late var _listener=AppLifecycleListener();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3),(){
        context.go('/home');
      });

      _listener=AppLifecycleListener(
        onStateChange: _onChanged
      );

  }






  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        body: Center(
          child: logo(),
        ),
        backgroundColor: secondary,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listener.dispose();
  }

  void _onChanged(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      context.go("/home");
    }
  }

}
