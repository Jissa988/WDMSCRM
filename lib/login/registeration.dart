import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/viewModels/registeration_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../constant/string.dart';
import 'background.dart';
import 'loginScreen.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final int? isRegisteration = arguments?['isRegister'] as int?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        // Add other providers if needed
      ],
      child: MaterialApp(
        title: 'Your App',
        home: _RegisterScreen(isRegisteration: isRegisteration),
      ),
    );
  }
}

class _RegisterScreen extends StatefulWidget {
  int? isRegisteration;// userName=0,passward=1,register=2

  _RegisterScreen({required this.isRegisteration});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<_RegisterScreen> {
  late RegisterProvider registerProvider;
  final logger = Logger();
  bool isLoading = false;
  bool isResendLoading = false;

  bool isSignup = false;
  bool isSendOtp=false;
  bool isResendOtp=false;
  List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  late FocusNode _userNameFocusNode;
  late FocusNode _mobileNoFocusNode;
  late FocusNode _passwordFocusNode; // Declare the FocusNode variable
  late FocusNode _confirmPasswordFocusNode;
  late Color _userNameLabelTextColor =
      AppColors.black; // Declare and initialize _labelTextColor
  late Color _mobileNoLabelTextColor = AppColors.black;
  late Color _passwordLabelTextColor = AppColors.black;
  late Color _confirmPasswordLabelTextColor = AppColors.black;
  final _formKey = GlobalKey<FormState>(); // Add form key
  late bool ismobileNull;
  late bool isUserNameNull;

  @override
  void initState() {
    super.initState();
    registerProvider = Provider.of<RegisterProvider>(context, listen: false);

    _userNameFocusNode = FocusNode(); // Initialize the FocusNode
    _userNameFocusNode
        .addListener(_updateFocus); // Add a listener to focus changes
    _mobileNoFocusNode = FocusNode(); // Initialize the FocusNode
    _mobileNoFocusNode
        .addListener(_updateFocus); // Add a listener to focus changes
    _passwordFocusNode = FocusNode(); // Initialize the FocusNode
    _passwordFocusNode
        .addListener(_updateFocus); // Add a listener to focus changes
    _confirmPasswordFocusNode = FocusNode(); // Initialize the FocusNode
    _confirmPasswordFocusNode
        .addListener(_updateFocus); // Add a listener to focus changes
    ismobileNull = false;
    isUserNameNull = false;
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    _userNameFocusNode.removeListener(
        _updateFocus); // Remove the listener to prevent memory leaks
    _userNameFocusNode.dispose(); // Dispose the FocusNode
    _mobileNoFocusNode.removeListener(
        _updateFocus); // Remove the listener to prevent memory leaks
    _mobileNoFocusNode.dispose();
    _passwordFocusNode.removeListener(
        _updateFocus); // Remove the listener to prevent memory leaks
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.removeListener(
        _updateFocus); // Remove the listener to prevent memory leaks
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _updateFocus() {
    setState(() {
      // Update the state based on the focus node's focus
      // If the focus node has focus, set the label text color to AppColors.theme_color, otherwise set it to AppColors.black
      if (_userNameFocusNode.hasFocus) {
        _userNameLabelTextColor = AppColors.theme_color;
      } else {
        _userNameLabelTextColor = AppColors.black;
      }
      if (_mobileNoFocusNode.hasFocus) {
        _mobileNoLabelTextColor = AppColors.theme_color;
      } else {
        _mobileNoLabelTextColor = AppColors.black;
      }
      if (_passwordFocusNode.hasFocus) {
        _passwordLabelTextColor = AppColors.theme_color;
      } else {
        _passwordLabelTextColor = AppColors.black;
      }
      if (_confirmPasswordFocusNode.hasFocus) {
        _confirmPasswordLabelTextColor = AppColors.theme_color;
      } else {
        _confirmPasswordLabelTextColor = AppColors.black;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          // Ensure the container takes up the full screen height
          color: AppColors.white,
          child: Center(
            child: Form(
              // Wrap your form with Form widget
              key: _formKey,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // Vertically center the column
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: widget.isRegisteration == 0
                        ? Text(
                            "Forgot User name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.theme_color,
                              fontSize: 28,
                              fontFamily: 'Metropolis',
                            ),
                            textAlign: TextAlign.left,
                          )
                        : (widget.isRegisteration == 1
                            ? Text(
                                "Forgot Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.theme_color,
                                  fontSize: 28,
                                  fontFamily: 'Metropolis',
                                ),
                                textAlign: TextAlign.left,
                              )
                            : Text(
                                "Register here",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.theme_color,
                                  fontSize: 28,
                                  fontFamily: 'Metropolis',
                                ),
                                textAlign: TextAlign.left,
                              )),
                  ),

                  SizedBox(height: size.height * 0.03),
                  Visibility(
                    visible: widget.isRegisteration == 2,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'For Registeration you should a member of our company and register with your registered mobile no',
                        style: TextStyle(
                            color: AppColors.black,
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            fontFamily: 'Metropolis'),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.isRegisteration == 2,
                    child: SizedBox(height: size.height * 0.03),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: TextFormField(
                      controller: (widget.isRegisteration == 2 ||
                              widget.isRegisteration == 0)
                          ? _mobileNoController
                          : _usernameController,
                      cursorColor: AppColors.theme_color,
                      focusNode: _mobileNoFocusNode,
                      // maxLength: 1,
                      keyboardType: (widget.isRegisteration == 2 ||
                              widget.isRegisteration == 0)
                          ? TextInputType.number
                          : TextInputType.text,
                      decoration: InputDecoration(
                        labelText: (widget.isRegisteration == 2 ||
                                widget.isRegisteration == 0)
                            ? "Mobile Number"
                            : "User Name",
                        labelStyle: TextStyle(
                          color: _mobileNoLabelTextColor,
                          fontSize: _mobileNoFocusNode.hasFocus
                              ? 15.0
                              : 16.0, // Adjust font size when focused
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.theme_color),
                        ),
                        contentPadding: EdgeInsets.only(
                            bottom: 8.0), // Adjust label position when focused
                      ),
                      style:  TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 16 ,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
                      validator: (value) {
                        if (widget.isRegisteration == 2 ||
                            widget.isRegisteration == 0) {
                          if (value == null ||
                              value.isEmpty ||
                              ismobileNull == true) {
                            return MyStrings.errorMobileNo;
                          }
                        } else if (value == null ||
                            value.isEmpty ||
                            isUserNameNull == true) {
                          return MyStrings.errorUsername;
                        }

                        return null;
                      },
                    ),
                  ),

                  SizedBox(height: size.height * 0.02),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        isLoading =
                            true; // Set isLoading to true when sending OTP
                      });
                      if (widget.isRegisteration == 2 ) {
                        if (_mobileNoController.text.isNotEmpty) {
                          // If all fields are valid, submit the form
                          await sendOtp();
                        } else {
                          setState(() {
                            isLoading =
                                false; // Reset isLoading if the field is empty
                            ismobileNull = true;
                          });
                        }
                      } else if(widget.isRegisteration == 1){
                        if (_usernameController.text.isNotEmpty) {
                          // If all fields are valid, submit the form
                          await forgotPasswordsendOtp();
                        } else {
                          setState(() {
                            isLoading =
                                false; // Reset isLoading if the field is empty
                            isUserNameNull = true;
                          });
                        }
                      }else{
                        if (_mobileNoController.text.isNotEmpty) {
                          // If all fields are valid, submit the form
                          await forgotUsernamesendOtp();
                        } else {
                          setState(() {
                            isLoading =
                            false; // Reset isLoading if the field is empty
                            ismobileNull = true;
                          });
                        }
                      }
                    },

                    child: Visibility(
                      visible: isSendOtp==false,
                    child:Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            'sent Otp',
                            style: TextStyle(
                              color: AppColors.bs_teal,
                              fontSize: 18,
                              fontFamily: 'Metropolis',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (isLoading)
                            CircularProgressIndicator(
                                color: AppColors.theme_color),
                        ],
                      ),
                    ),),
                  ),
                  Container(
                    child: Row(
                      children: [
                       Visibility(
                          visible: isSendOtp==true,
                          child:Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  "Can't get OTP in 60seconds",
                                  style: TextStyle(
                                    color: AppColors.bs_teal,
                                    fontSize: 12,
                                    fontFamily: 'Metropolis',
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),

                              ],
                            ),
                          ),),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              isResendLoading =
                              true; // Set isLoading to true when sending OTP
                            });
                            if (widget.isRegisteration == 2 ||widget.isRegisteration==0) {
                              if (_mobileNoController.text.isNotEmpty) {
                                // If all fields are valid, submit the form
                                await resendOtp();
                              } else {
                                setState(() {
                                  isResendLoading =
                                  false; // Reset isLoading if the field is empty
                                  ismobileNull = true;
                                });
                              }
                            } else if(widget.isRegisteration == 1){
                              if (_usernameController.text.isNotEmpty) {
                                // If all fields are valid, submit the form
                                await resentforgotPasswordsendOtp();
                              } else {
                                setState(() {
                                  isResendLoading =
                                  false; // Reset isLoading if the field is empty
                                  isUserNameNull = true;
                                });
                              }
                            }
                          },

                          child: Visibility(
                            visible: isSendOtp==true,
                            child:Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    'Resent Otp',
                                    style: TextStyle(
                                      color: AppColors.bs_teal,
                                      fontSize: 18,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isResendLoading)
                                    CircularProgressIndicator(
                                        color: AppColors.theme_color),
                                ],
                              ),
                            ),),
                        ),

                      ],
                    ),
                  ),
                  // SizedBox(height: size.height * 0.01),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                        (index) => Container(
                          width: 40,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: TextFormField(
                            cursorColor: AppColors.theme_color,
                            controller: otpControllers[index],
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              counterText: "",
                              // border: OutlineInputBorder(),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors
                                        .theme_color), // Set the color of the focused border
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '';
                              }
                              return null;
                            },
                            onEditingComplete: () {
                              // Request focus on the password field
                              (widget.isRegisteration == 2)
                                  ? FocusScope.of(context)
                                      .requestFocus(_userNameFocusNode)
                                  : FocusScope.of(context)
                                      .requestFocus(_passwordFocusNode);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.isRegisteration == 2,
                    child: SizedBox(height: size.height * 0.03),
                  ),
                  Visibility(
                    visible: widget.isRegisteration == 2,
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _usernameController,
                        cursorColor: AppColors.theme_color,
                        focusNode: _userNameFocusNode,
                        decoration: InputDecoration(
                          labelText: "User Name",
                          labelStyle: TextStyle(
                            color: _userNameLabelTextColor,
                            fontSize: _userNameFocusNode.hasFocus
                                ? 15.0
                                : 16.0, // Adjust font size when focused
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.theme_color),
                          ),
                          contentPadding: EdgeInsets.only(
                              bottom:
                                  8.0), // Adjust label position when focused
                        ),
                        style:  TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 16 ,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
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
                  ),

                  Visibility(
                    visible: (widget.isRegisteration != 0),
                    child: SizedBox(height: size.height * 0.03),
                  ),

                  Visibility(
                    visible: (widget.isRegisteration != 0),
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _passwordController,
                        cursorColor: AppColors.theme_color,
                        focusNode: _passwordFocusNode,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: _passwordLabelTextColor,
                            fontSize: _passwordFocusNode.hasFocus
                                ? 15.0
                                : 16.0, // Adjust font size when focused
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.theme_color),
                          ),
                          contentPadding: EdgeInsets.only(
                              bottom:
                                  8.0), // Adjust label position when focused
                        ),
                        style:  TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 16 ,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return MyStrings.errorPassword;
                          }
                          return null;
                        },
                        onEditingComplete: () {
                          // Request focus on the password field
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocusNode);
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    visible: (widget.isRegisteration != 0),
                    child: SizedBox(height: size.height * 0.03),
                  ),

                  Visibility(
                    visible: (widget.isRegisteration != 0),
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        controller: _confirmpasswordController,
                        cursorColor: AppColors.theme_color,
                        focusNode: _confirmPasswordFocusNode,
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                            color: _confirmPasswordLabelTextColor,
                            fontSize: _confirmPasswordFocusNode.hasFocus
                                ? 15.0
                                : 16.0, // Adjust font size when focused
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.theme_color),
                          ),
                          contentPadding: EdgeInsets.only(
                              bottom:
                                  8.0), // Adjust label position when focused
                        ),
                        style:  TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 16 ,
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return MyStrings.errorConfirmPassword;
                          } else if (value != _passwordController.text) {
                            return MyStrings.errorvalidConfirmPassword;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top:15),
                    // margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // If all fields are valid, submit the form
                          setState(() {
                            isSignup =
                                true; // Set isLoading to true when sending OTP
                          });
                          if(widget.isRegisteration == 2){
                            handleSignUp();
                          }else if(widget.isRegisteration == 1){
                            handleNext();

                          }else{
                            handleSendUserName();
                          }
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              widget.isRegisteration == 2 ? "SIGN UP" : "NEXT",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Metropolis',
                                color: AppColors.white,
                              ),
                            ),
                            if (isSignup)
                              CircularProgressIndicator(color: AppColors.white),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()))
                      },
                      child: Text(
                        "Already Have an Account? Sign in",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.theme_color,
                          fontFamily: 'Metropolis',
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendOtp() async {
    try {
      await registerProvider.sendOtp(_mobileNoController.text).then((_) {
        print(registerProvider.log_status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                    style: TextStyle(fontFamily: 'Metropolis',color: Colors.green[700],fontSize: 18,fontWeight: FontWeight.bold)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,

                      ),),
                  ),
                ],
              );
            },
          );
          isSendOtp=true;// Set isLoading to false after sending OTP

        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                  style: TextStyle(fontFamily: 'Metropolis',color: Colors.red[700],fontSize: 18,fontWeight: FontWeight.bold),),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,
                      ),),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error fetching departments: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> resendOtp() async {
    try {
      String otpType="";
      if(widget.isRegisteration == 0){
        otpType='FUS';
      }else if(widget.isRegisteration == 2){
        otpType='REG';
      }

      await registerProvider.resentsendOtpforRegisterAndUserName(_mobileNoController.text,otpType).then((_) {
        print(registerProvider.log_status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                    style: TextStyle(fontFamily: 'Metropolis',color: Colors.green[700],fontSize: 18,fontWeight: FontWeight.bold)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,

                      ),),
                  ),
                ],
              );
            },
          );
          isResendOtp=true;// Set isLoading to false after sending OTP
          isResendLoading=false;
        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                  style: TextStyle(fontFamily: 'Metropolis',color: Colors.red[700],fontSize: 18,fontWeight: FontWeight.bold),),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,
                      ),),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error fetching departments: $e");
    } finally {
      setState(() {
        isResendOtp = false;
        isResendLoading=false;
      });
    }
  }

  Future<void> forgotPasswordsendOtp() async {
    try {
      await registerProvider
          .forgotPasswordOtp(_usernameController.text)
          .then((_) {
        print(registerProvider.log_status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                    style: TextStyle(fontFamily: 'Metropolis',color: Colors.green[700],fontSize: 18,fontWeight: FontWeight.bold)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,

                      ),),
                  ),
                ],
              );
            },
          );
          isSendOtp=true;// Set isLoading to false after sending OTP

        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                  style: TextStyle(fontFamily: 'Metropolis',color: Colors.red[700],fontSize: 18,fontWeight: FontWeight.bold),),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,
                      ),),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error fetching departments: $e");
    } finally {
      setState(() {
        isLoading = false; // Set isLoading to false after sending OTP
      });
    }
  }
  Future<void> resentforgotPasswordsendOtp() async {
    try {
      await registerProvider
          .resendforgotPasswordOtp(_usernameController.text)
          .then((_) {
        print(registerProvider.log_status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                    style: TextStyle(fontFamily: 'Metropolis',color: Colors.green[700],fontSize: 18,fontWeight: FontWeight.bold)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,

                      ),),
                  ),
                ],
              );
            },
          );
          isResendOtp=true;// Set isLoading to false after sending OTP
          isResendLoading=false;
        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                  style: TextStyle(fontFamily: 'Metropolis',color: Colors.red[700],fontSize: 18,fontWeight: FontWeight.bold),),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,
                      ),),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error fetching departments: $e");
    } finally {
      setState(() {
        isResendOtp = false; // Set isLoading to false after sending OTP
        isResendLoading=false;
      });
    }
  }

  Future<void> forgotUsernamesendOtp() async {
    try {
      await registerProvider.forgotUsernamesendOtp(_mobileNoController.text).then((_) {
        print(registerProvider.log_status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);

          showDialog(
              context: context,
              builder: (BuildContext context)
          {
            return AlertDialog(
              // title: Text('Dialog Title'),
              content: Text("${registerProvider.msg}",
                style: TextStyle(fontFamily: 'Metropolis',color: Colors.green[700],fontSize: 18,fontWeight: FontWeight.bold)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,

                      ),),
                ),
              ],
            );
          },
          );
          isSendOtp=true;// Set isLoading to false after sending OTP

        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                  style: TextStyle(fontFamily: 'Metropolis',color: Colors.red[700],fontSize: 18,fontWeight: FontWeight.bold),),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,
                      ),),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error fetching departments: $e");
    } finally {
      setState(() {
        isLoading = false; // Set isLoading to false after sending OTP
      });
    }
  }


  Future<void> handleSignUp() async {
    try {
      String combinedOtp =
          otpControllers.map((controller) => controller.text).join();

      await registerProvider
          .signUp(
              combinedOtp, _usernameController.text, _passwordController.text)
          .then((_) {
        print(registerProvider.status);
        print("message--" + registerProvider.msg);
        if (registerProvider.status == true) {
          print("message--" + registerProvider.msg);

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
            MaterialPageRoute(builder: (context) => LoginScreen()),
            // LoginPage(notificationType: '',)),
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
        isSignup = false; // Set isLoading to false after sending OTP
      });
    }
  }

  Future<void> handleNext() async {
    try {
      String combinedOtp =
          otpControllers.map((controller) => controller.text).join();

      await registerProvider
          .forgotpasswordRest(
              combinedOtp, _usernameController.text, _passwordController.text)
          .then((_) {
        print(registerProvider.status);
        print("message--" + registerProvider.msg);
        if (registerProvider.status == true) {
          print("message--" + registerProvider.msg);

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
            MaterialPageRoute(builder: (context) => LoginScreen()),
            // LoginPage(notificationType: '',)),
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
        isSignup = false; // Set isLoading to false after sending OTP
      });
    }
  }
  Future<void> handleSendUserName() async {
    try {
      String combinedOtp =
      otpControllers.map((controller) => controller.text).join();

      await registerProvider
          .sendUserName(
          combinedOtp, _usernameController.text,)
          .then((_) {
        print(registerProvider.status);
        print("message--" + registerProvider.msg);
        if (registerProvider.log_status == 1) {
          print("message--" + registerProvider.msg);

          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                    style: TextStyle(fontFamily: 'Metropolis',color: Colors.green[700],fontSize: 18,fontWeight: FontWeight.bold)),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        // LoginPage(notificationType: '',)),
                      );

                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,

                      ),),
                  ),
                ],
              );
            },
          );
        } else {
          // Show login failure message
          print("message--" + registerProvider.msg);
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return AlertDialog(
                // title: Text('Dialog Title'),
                content: Text("${registerProvider.msg}",
                  style: TextStyle(fontFamily: 'Metropolis',color: Colors.red[700],fontSize: 18,fontWeight: FontWeight.bold),),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok',
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        color: AppColors.theme_color,
                      ),),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      // Handle errors
      logger.e("Error fetching departments: $e");
    } finally {
      setState(() {
        isSignup = false; // Set isLoading to false after sending OTP
      });
    }
  }

}
