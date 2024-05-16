import 'dart:convert';
import 'dart:typed_data';

import 'package:customer_portal/contact/contactUs.dart';
import 'package:customer_portal/profile/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/themes.dart';
import '../constant/constants.dart';
import '../customised/quickAlerts/quickAlertDialogue.dart';
import '../customised/quickAlerts/quickAlertType.dart';
import '../login/loginScreen.dart';
import '../profile/profile.dart';
import '../settings/setting.dart';
import '../viewModels/profile_provider.dart';
import '../viewModels/registeration_provider.dart';
import 'drawerNavItem.dart';

class MyHeaderDrawer extends StatefulWidget {
  final String fileName,customerName; // Define fileName parameter

  // Constructor to initialize fileName
  MyHeaderDrawer({required this.fileName,required this.customerName});

  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}
class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("getImage--" + widget.fileName);
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(bottom: 10, top: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<Uint8List?>(
                      future: getImage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          if (snapshot.hasError || snapshot.data == null) {
                            return CircleAvatar(
                              backgroundImage: AssetImage("assets/profile/Profile_Image.png"),
                            );
                          } else {
                            Uint8List? imageData = snapshot.data;
                            return CircleAvatar(
                              backgroundImage: MemoryImage(imageData!),
                            );
                          }
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Align text to the start
                        children: [
                          Text(
                            "Welcome,",
                            style:  TextStyle(
                              fontFamily: 'Metropolis',
                              fontSize: 18 ,
                              fontWeight: FontWeight.w500,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Dismiss the drawer
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.customerName}",
                  style:  TextStyle(
                    fontFamily: 'Metropolis',
                    fontSize: 20 ,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
          ),
          DrawerNavItem(
            iconData: Icons.arrow_forward_ios_rounded,
            imagePath: 'assets/bottom_menu/profile_trans.png',
            navItemTitle: "Profile",

            callback: () {
              // Navigator.of(context).pushReplacementNamed(
              //   RouteConstants.homeScreen,
              // );
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          Divider(),
          DrawerNavItem(
            iconData: Icons.arrow_forward_ios_rounded,
            imagePath: 'assets/bottom_menu/aboutUs_trans.png',
            navItemTitle: "About Us",

            callback: () {
              // Navigator.of(context).pushReplacementNamed(
              //   RouteConstants.homeScreen,
              // );
            },
          ),
          Divider(),
          DrawerNavItem(
            iconData: Icons.arrow_forward_ios_rounded,
            imagePath: 'assets/bottom_menu/setting_trans.png',
            navItemTitle: "Settings",

            callback: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Setting()));
            },
          ),
          Divider(),
          DrawerNavItem(
            iconData: Icons.arrow_forward_ios_rounded,
            imagePath: 'assets/bottom_menu/contact_trans.png',
            navItemTitle: "Contact Us",

            callback: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ContactUs()));
            },
          ),
          Divider(),
          DrawerNavItem(
            iconData: Icons.arrow_forward_ios_rounded,
            imagePath: 'assets/bottom_menu/logout_trans.png',
            navItemTitle: "Logout",

            callback: () {
              Navigator.pop(context); // Dismiss the drawer

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertLogout(
                      scaffoldContext: context,   navigator: Navigator.of(context),); // Pass scaffoldContext here
                },
              );
            },
          ),


        ],
      ),
    );

  }


  Future<Uint8List?> getImage() async {

    if (widget.fileName == null) {
      print("widget.fileName is null");
      return null;
    }

    print("getImage11--" + widget.fileName);

    try {
      print("getImage12--" + widget.fileName);
      ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);

      await profileProvider.imageView(widget.fileName);
      print("stringstatus--" + profileProvider.stringstatus);
      print("message--" + profileProvider.msg);

      if (profileProvider.stringstatus == 'Success') {
        String base64String = profileProvider.msg;
        return base64Decode(base64String);
      } else {
        print("message--" + profileProvider.msg);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       "${profileProvider.msg}",
        //       style: TextStyle(fontFamily: 'Metropolis'),
        //     ),
        //     duration: Duration(seconds: 2),
        //     backgroundColor: Colors.red[700],
        //   ),
        // );
        return null;
      }
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }

}





  class AlertLogout extends StatelessWidget {
  final BuildContext scaffoldContext;
  final NavigatorState navigator;

  AlertLogout({required this.scaffoldContext, required this.navigator});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        // Add other providers if needed
      ],
      child:  _AlertLogout(scaffoldContext: scaffoldContext,navigator:navigator),
    );
  }
}

class _AlertLogout extends StatefulWidget {
  final BuildContext scaffoldContext;
  final NavigatorState navigator;

  _AlertLogout({required this.scaffoldContext,required this.navigator});

  @override
  _AlertLogoutState createState() => _AlertLogoutState();
}

class _AlertLogoutState extends State<_AlertLogout> {
  late BuildContext dialogContext; // Variable to store the context

  @override
  void initState() {
    super.initState();
    if (mounted) {
      dialogContext = context; // Store the context
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dialogContext = context; // Store the context
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
titlePadding: EdgeInsets.all(0),
      title: Image.asset(
        'assets/quickAlerts/confirm.gif',
        // width: 500,
        // height: 100,
      ),
    
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              'Are you sure want to Logout?',
              style: TextStyle(
                  fontFamily: 'Metropolis',
                  color: AppColors.black,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Metropolis',
              color: AppColors.theme_color,
            ),
          ),
        ),
        TextButton(
        onPressed: () {
    if (mounted) { // Check if the widget is still mounted
    Navigator.of(context).pop();
    handleLogout();
    }
    },
          child: Text(
            'Logout',
            style: TextStyle(
              fontFamily: 'Metropolis',
              color: AppColors.theme_color,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> handleLogout() async {
    final logger = Logger();
    late RegisterProvider registerProvider;

    registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    String _token = "";
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _token = prefs.getString(Constants.API_TOKEN) ?? "";
    });

    try {
      await registerProvider.logout(_token).then((_) {
        print(registerProvider.log_status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);

          Fluttertoast.showToast(
            msg: "${registerProvider.msg}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green[700],
            textColor: Colors.white,
            fontSize: 16.0,
          );

          SharedPreferences.getInstance().then((prefs) {
            prefs.remove(Constants.API_TOKEN);
            // Navigate to login screen
            print('SharedPreferences---');
            // final BuildContext? dialogContext = this.dialogContext;
            //
            // // Dismiss the dialog
            // Navigator.of(dialogContext!).pop();

            // Navigate using the stored context
            // if (dialogContext != null && mounted) {
              print('SharedPreferences---11');
              print('dialogContext: $dialogContext');
              widget.navigator.pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            // } else {
            //   print('SharedPreferences---22');
            // }


          });
        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);


          Fluttertoast.showToast(
            msg: "${registerProvider.msg}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red[700],
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error logout: $e");
    }
  }
}
// QuickAlert.show(
// width: 10,
// height:5,
// onCancelBtnTap: () {
// Navigator.pop(context); // Navigate back to the previous screen
// },
// onConfirmBtnTap: (){
// Navigator.pop(context);
// handleLogout();
// },
// context: context,
// type: QuickAlertType.confirm,
// text: 'Do you want to logout',
// titleAlignment: TextAlign.center,
// textAlignment: TextAlign.center,
// confirmBtnText: 'Yes',
// cancelBtnText: 'No',
// confirmBtnColor: AppColors.theme_color,
// backgroundColor: AppColors.white,
// headerBackgroundColor: Colors.grey,
// confirmBtnTextStyle: const TextStyle(
// color: AppColors.white,
// fontWeight: FontWeight.bold,
// ),
// barrierColor: AppColors.theme_color.withOpacity(0.1),
// titleColor: AppColors.black,
// textColor: AppColors.black,
// cancelBtnTextStyle: const TextStyle(
// color: AppColors.white
//
// )
// );