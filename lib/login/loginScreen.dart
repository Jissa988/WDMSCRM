import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/constant/constants.dart';
import 'package:customer_portal/constant/string.dart';
import 'package:customer_portal/home/homePage.dart';
import 'package:customer_portal/login/registeration.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../viewModels/registeration_provider.dart';



class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        // Add other providers if needed
      ],
      child: MaterialApp(
        title: 'Your App',
        home: _LoginScreen(),
      ),
    );
  }
}

class _LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>(); // Add form key
  late RegisterProvider registerProvider;
  final logger = Logger();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late FocusNode _userNameFocusNode;
  late FocusNode _passwordFocusNode; // Declare the FocusNode variable
  bool isLogin = false;
  late SharedPreferences _prefs;
  String? fcmToken;
  double bottomPadding = 0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    _initializeSharedPreferences(); // Initialize SharedPreferences

    registerProvider = Provider.of<RegisterProvider>(context, listen: false);

    _userNameFocusNode = FocusNode(); // Initialize the FocusNode
    // _userNameFocusNode
    //     .addListener(_updateFocus); // Add a listener to focus changes
    // Add a listener to focus changes
    _passwordFocusNode = FocusNode(); // Initialize the FocusNode
    // _passwordFocusNode
    //     .addListener(_updateFocus); // Add a listener to focus changes
  }
  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _usernameController.dispose();
    _passwordController.dispose();
    _userNameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance!.window.viewInsets.bottom;
    setState(() {
      bottomPadding = value;
    });
  }


  Future<void> _initializeSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    fcmToken = _prefs.getString(Constants.FCM_TOKEN);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Container(
                // color: AppColors.white,
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  'assets/logo/app_icon.png',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.08),
                          // TextField(
                          //   readOnly: true,
                          //   controller: TextEditingController(text: fcmToken),
                          //   style: TextStyle(
                          //     color: Colors.black, // Change the color if needed
                          //     fontSize: 16, // Adjust the font size if needed
                          //   ),
                          //
                          // ),

                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              controller: _usernameController,
                              cursorColor: AppColors.theme_color,
                              focusNode: _userNameFocusNode,
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.theme_color,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors
                                          .theme_color), // Set the color of the focused border
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.theme_color,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return MyStrings.errorUsername;
                                }
                                return null;
                              },
                              onEditingComplete: () {
                                // Request focus on the password field
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocusNode);
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          // Password TextField
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              controller: _passwordController,
                              cursorColor: AppColors.theme_color,
                              focusNode: _passwordFocusNode,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.theme_color,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors
                                          .theme_color), // Set the color of the focused border
                                ),
                              ),
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.theme_color,
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return MyStrings.errorPassword;
                                }
                                return null;
                              },
                            ),
                          ),
                          // Forgot password
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align children at the start of the cross axis
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                  child: GestureDetector(
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterScreen(),
                                          settings: RouteSettings(
                                            arguments: {'isRegister': 0},
                                          ),
                                        ),
                                      )
                                    },
                                    child: Text(
                                      "Forgot your user name?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.theme_color,
                                        fontFamily: 'Metropolis',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                  child: GestureDetector(
                                    onTap: () => {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RegisterScreen(),
                                          settings: RouteSettings(
                                            arguments: {'isRegister': 1},
                                          ),
                                        ),
                                      )
                                    },
                                    child: Text(
                                      "Forgot your password?",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.theme_color,
                                        fontFamily: 'Metropolis',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Login button
                          Container(
                            alignment: Alignment.center,
                            // margin: EdgeInsets.symmetric(
                            //     horizontal: 40, vertical: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate the form
                                if (_formKey.currentState!.validate()) {
                                  // If all fields are valid, submit the form
                                  handleLogin();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0),
                                ),
                                backgroundColor: AppColors.theme_color, // Set the button's background color

                              ),
                              child: Container(
                                alignment: Alignment.center,
                                height: 50.0,
                                width: size.width * 0.5,
                                child: Text(
                                  "LOGIN",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Metropolis',
                                    color: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Sign up button
                          Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 10),
                            child: GestureDetector(
                              onTap: () {
                                // throw Exception('Test Crashlytics'),
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterScreen(),
                                    settings: RouteSettings(
                                      arguments: {'isRegister': 2},
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Don't Have an Account? Sign up",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.theme_color,
                                  fontFamily: 'Metropolis',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50 + bottomPadding,
            left: 0,
            right: 0,
            child: Text(
              'Powered by Sevion Technologies',
              // Replace with your actual version number
              textAlign: TextAlign.center,
              style:
                TextStyle(
                  fontSize: 12,
                  color: AppColors.theme_color,
                  fontFamily: 'Metropolis',
                  decoration: TextDecoration.none,
                ),
              ),
            ),

          Positioned(
            bottom: 20 + bottomPadding,
            left: 0,
            right: 0,
            child: Text(
              'Version 1.0.0', // Replace with your actual version number
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.theme_color,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );

  }

  Future<void> handleLogin() async {
    try {
      String? fcmToken = _prefs.getString(Constants.FCM_TOKEN);
      await registerProvider
          .login(_usernameController.text, _passwordController.text, fcmToken!)
          .then((_) {
        print(registerProvider.status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);

          _prefs.setString(Constants.API_TOKEN, registerProvider.api_token);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${registerProvider.msg}",
                style: TextStyle(fontFamily: 'Metropolis'),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green[700],
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${registerProvider.msg}",
                style: TextStyle(fontFamily: 'Metropolis'),
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red[700],
            ),
          );
        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error fetching departments: $e");
    } finally {
      setState(() {
        isLogin = false; // Set isLoading to false after sending OTP
      });
    }
  }
}
