import 'dart:async';

import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/home/homePage.dart';
import 'package:customer_portal/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constants.dart';


class SplashScreen extends StatefulWidget {

  SplashScreen({Key? key, }) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;

  late String? token;

  @override
  void initState() {
    super.initState();
    getSharedPreference();
  }

  Future<void> getSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString(Constants.API_TOKEN) ?? "";
    print("token===$token");

    setState(() {
      _isVisible = true;
    });

    Future.delayed(Duration(milliseconds: 2000), () {
      print("token---$token");

      if (token != null && token!.isNotEmpty) {
        // Navigate to home page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
        );
      } else {
        // Navigate to login page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }

    });

  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.white, AppColors.white],
              begin: const FractionalOffset(0, 0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0,
            duration: Duration(milliseconds: 1500),
            child: Center(
              child: Container(
                height: 140.0,
                width: 140.0,
                child: Center(
                  child: ClipOval(
                    child: Image.asset(
                      'assets/logo/app_icon.png',
                      width: 100,
                      height: 100,
                    ),
                    //put your logo here
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 2.0,
                      offset: Offset(5.0, 3.0),
                      spreadRadius: 2.0,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child:Text(
            'Powered by Sevion Technologies', // Replace with your actual version number
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.bs_teal,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 16.0,
              decoration: TextDecoration.none, // Add this line to remove underline
            ),
          ),

        ),
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child:Text(
            'Version 1.0.0', // Replace with your actual version number
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.theme_color,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              decoration: TextDecoration.none, // Add this line to remove underline
            ),
          ),

        ),
      ],
    );
  }
}
