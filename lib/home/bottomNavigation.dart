import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/contact/contactUs.dart';
import 'package:customer_portal/home/homePage.dart';
import 'package:customer_portal/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../settings/setting.dart';

class BottomNavigationMenu extends StatefulWidget {
  final int menuIndex;

  BottomNavigationMenu(this.menuIndex);

  @override
  _BottomNavigationMenuState createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  late int _menuIndex;

  @override
  void initState() {
    super.initState();
    _menuIndex = widget.menuIndex;
  }

  Future<void> _onMenuItemTapped(int index) async {
    setState(() {
      _menuIndex = index;
    });

    // Perform navigation based on index
    switch (index) {
      case 0:
      // Replace 'ProfileScreen()' with your actual screen widget
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileScreen()));

        // Navigator.pushNamed(context, CustomerPortalRoutes.profile);
        break;
      case 1:
    // String url = 'https://altaybawater.com/';
    final Uri _url = Uri.parse('https://altaybawater.com/');

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }

    break;
      case 2:
      // Navigate to Home screen
      // Replace 'HomeScreen()' with your actual screen widget
      //   Navigator.pushNamed(context, '/home');
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage()));
        // Navigator.pushNamed(context, CustomerPortalRoutes.home);

        break;
      case 3:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContactUs()));
        // Navigator.pushNamed(context, CustomerPortalRoutes.contacts);

        break;
      case 4:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Setting()));
        // Navigator.pushNamed(context, CustomerPortalRoutes.settings);


        break;
    // Add more cases as needed
    }
  }

  Color colorByIndex(BuildContext context, int index) {
    return index == _menuIndex ? AppColors.theme_color : AppColors.lightGray;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 80.0, // Adjust the height as needed
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.2),
            blurRadius: 24,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildMenuItem(context, 0, 'Profile', 'assets/bottom_menu/profile.png', 'assets/bottom_menu/profile_trans.png'),
          buildMenuItem(context, 1, 'About Us', 'assets/bottom_menu/aboutUs.png', 'assets/bottom_menu/aboutUs_trans.png'),
          buildMenuItem(context, 2, 'Home', 'assets/bottom_menu/home.png', 'assets/bottom_menu/home_trans.png'),
          buildMenuItem(context, 3, 'Contact Us', 'assets/bottom_menu/contact.png', 'assets/bottom_menu/contact_trans.png'),
          buildMenuItem(context, 4, 'Settings', 'assets/bottom_menu/setting.png', 'assets/bottom_menu/setting_trans.png'),
          // Add more menu items as needed
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, int index, String title, String imagePath, String transImagePath) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            onTap: () => _onMenuItemTapped(index), // Update menuIndex and navigate when tapped
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                index == _menuIndex
                    ? Image.asset(
                  imagePath,
                  width: 30,
                  height: 30,
                  color: colorByIndex(context, index),
                )
                    : Image.asset(
                  transImagePath,
                  width: 30,
                  height: 30,
                  color: colorByIndex(context, index),
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorByIndex(context, index),
                  ),
                ),
              ],
            ),
          ),
          if (index == _menuIndex) // Display indicator line only for the selected menu item
            Positioned(
              top: 0,
              height: 2,
              width: 50,
              child: Container(
                color: AppColors.theme_color, // Change the color as needed
              ),
            ),
        ],
      ),
    );
  }
}


