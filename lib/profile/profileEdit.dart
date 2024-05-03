import 'package:customer_portal/constant/string.dart';
import 'package:customer_portal/models/profileModel.dart';
import 'package:customer_portal/profile/profile.dart';
import 'package:customer_portal/profile/profile_menu.dart';
import 'package:customer_portal/profile/profile_pic.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/themes.dart';
import '../constant/constants.dart';
import '../viewModels/profile_provider.dart';

class ProfileEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final ProfileDetails? profileDetails =
        arguments?['profile'] as ProfileDetails?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        // Add other providers if needed
      ],
      child:  _ProfileEdit(profileDetails: profileDetails),
    );
  }
}

class _ProfileEdit extends StatefulWidget {
  ProfileDetails? profileDetails;

  _ProfileEdit({required this.profileDetails});

  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<_ProfileEdit> {
  final logger = Logger();
  late ProfileProvider profileProvider;
  TextEditingController _displayname = TextEditingController();
  TextEditingController _contactNoController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _whatsappNo = TextEditingController();
  TextEditingController _mailId = TextEditingController();

  late FocusNode _userNameFocusNode;
  late FocusNode _mobileNoFocusNode;
  late FocusNode _passwordFocusNode; // Declare the FocusNode variable
  late FocusNode _displayNameFocusNode;
  late FocusNode _whatsappFocusNode;
  late FocusNode _emailIdFocusNode;
  String _token = "";

  void initState() {
    super.initState();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    print('Display name-${widget.profileDetails!.displayName!}');
    print('ContactNo-${widget.profileDetails!.contactNo!}');
    print('userName-${widget.profileDetails!.userName!}');

    _displayname.text = widget.profileDetails!.displayName!;
    _contactNoController.text = widget.profileDetails!.contactNo!;
    _usernameController.text = widget.profileDetails!.userName!;
    _passwordController.text = widget.profileDetails!.password!;
    _whatsappNo.text = widget.profileDetails!.whatsAppNo!;
    _mailId.text = widget.profileDetails!.emailId!;

    getSharedPreference();
  }

  Future<void> getSharedPreference() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _token = prefs.getString(Constants.API_TOKEN) ?? "";
      });

      // Do not call _fetchCustomerAccounts here, because the HomeProvider instance is not initialized yet.
    } catch (e) {
      // Handle errors
      print('Error fetching shared preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
    child: Scaffold(
      appBar: AppBar(
        title: const Text("Profile Edit"),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: 35,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
             ProfilePic(isEdit: true,token:_token,customerId:widget.profileDetails!.customerId,fileName:widget.profileDetails!.fileName),
            const SizedBox(height: 5),
            Center(
              child: Column(children: [
                Text(
                  '${widget.profileDetails!.customerName}',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.profileDetails!.routeName} - ${widget.profileDetails!.areaName}',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  '${widget.profileDetails!.paymentTerm}',
                  style: TextStyle(
                      color: AppColors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      fontStyle: FontStyle.italic),
                ),
              ]),
            ),
            ProfileMenu(
              textEditingController:
                  TextEditingController(text: "${_displayname.text}"),
              icon: "assets/home/user.png",
              isobstruct: false,
              placeholder: MyStrings.errorDisplayName,
              onChanged: (value) {
                // Handle the edited data here
                _displayname.text = value;
                print("Edited displayname: $value");
              },
            ),
            ProfileMenu(
              textEditingController: TextEditingController(
                text: "${_contactNoController.text }",
              ),
              icon: "assets/profile/telephone.png",
              isobstruct: false,
              placeholder: MyStrings.errorContactNo,
              onChanged: (value) {
                // Handle the edited data here
                _contactNoController.text = value;
                print("Edited contactno: $value");
              },
            ),
            ProfileMenu(
              textEditingController:
                  TextEditingController(text: "${_whatsappNo.text}"),
              icon: "assets/profile/whatsapp.png",
              isobstruct: false,
              placeholder: MyStrings.errorWhatsappNo,
              onChanged: (value) {
                // Handle the edited data here
                _whatsappNo.text = value;
                print("Edited whatsapp: $value");
              },
            ),
            ProfileMenu(
              textEditingController:
                  TextEditingController(text: "${_mailId.text}"),
              icon: "assets/profile/email.png",
              isobstruct: false,
              placeholder: MyStrings.errorEmail,
              onChanged: (value) {
                // Handle the edited data here
                _mailId.text = value;
                print("Edited maild: $value");
              },
            ),
            ProfileMenu(
              textEditingController:
                  TextEditingController(text: "${_usernameController.text}"),
              icon: "assets/profile/username.png",
              isobstruct: false,
              placeholder: MyStrings.errorUsername,
              onChanged: (value) {
                _usernameController.text = value;
                // Handle the edited data here
                print("Edited data: $value");
              },
            ),
            ProfileMenu(
              textEditingController:
                  TextEditingController(text: "${_passwordController.text}"),
              icon: "assets/profile/password.png",
              isobstruct: true,
              placeholder: MyStrings.errorPassword,
              onChanged: (value) {
                // Handle the edited data here
                _passwordController.text = value;
                print("Edited data: $value");
              },
            ),
            Center(
                child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.theme_color,
                // Assuming your theme color is similar to this
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.white,
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () => {
                  print("Edited data: ${_displayname.text}"),
                  print("Edited data: ${_contactNoController.text}"),
                  print("Edited data: ${_whatsappNo.text}"),
                  print("Edited data: ${_mailId.text}"),
                  print("Edited data: ${_usernameController.text}"),
                  print("Edited data: ${_passwordController.text}"),
                  profileProvider
                      .saveProfileChange(
                          _token,
                          _displayname.text,
                          _contactNoController.text,
                          _whatsappNo.text,
                          _mailId.text,
                          _usernameController.text,
                          _passwordController.text,
                          widget.profileDetails!.customerId)
                      .then((_) {
                    print(profileProvider.status);
                    print("message--" + profileProvider.msg);
                    if (profileProvider.status == 1) {
                      print("message--" + profileProvider.msg);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${profileProvider.msg}",
                            style: TextStyle(fontFamily: 'Metropolis'),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.green[700],
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()),
                      );
                    } else {
                      // Show login failure message
                      print("message--" + profileProvider.msg);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "${profileProvider.msg}",
                            style: TextStyle(fontFamily: 'Metropolis'),
                          ),
                          duration: Duration(seconds: 2),
                          backgroundColor: Colors.red[700],
                        ),
                      );
                    }
                  }),
                },
                child: Center(
                  child: Text(
                    'UPDATE',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // fontStyle: FontStyle.italic
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    ));
  }
}
