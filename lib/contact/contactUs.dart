import 'package:flutter/material.dart';

import '../config/themes.dart';
import '../home/bottomNavigation.dart';

class ContactUs extends StatelessWidget {

  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us",style:TextStyle(
          color:AppColors.black,
          fontSize: 30,
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.bold,
        ),),
        titleSpacing: 8,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: 32,
          ),
        ),
      ),
      body:Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text('Mobile NO: +71 xxxxxxx336', style: TextStyle(
              fontFamily:
              'Metropolis',
              fontSize: 16,
              fontWeight:
              FontWeight.w500,
              color: AppColors
                  .theme_color,
            ),),
            Text('MailId: dajla@gmal.com', style: TextStyle(
              fontFamily:
              'Metropolis',
              fontSize: 16,
              fontWeight:
              FontWeight.w500,
              color: AppColors
                  .theme_color,
            ),)
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationMenu(3),
    );
  }
}