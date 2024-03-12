import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/Screens/Home.dart';
import 'package:suraksha/Screens/auth/login.dart';
import 'package:suraksha/Screens/auth/newlogIn.dart';
import 'package:suraksha/utils/app_images.dart';
import 'package:suraksha/utils/colors%20.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String ? token = prefs.getString('token');
        if(token!=null && token!=''){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen()));
    }else{

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const Login()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
     Timer(const Duration(seconds: 3), () {
       checkLogin();
      });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteColor,
     body: Center(child: SizedBox(
       width: MediaQuery.of(context).size.width/1.5,
         child: Image.asset(Images.splashLogo,))),
    );
  }
}
