import 'package:customer_portal/constant/constants.dart';
import 'package:customer_portal/profile/profileEdit.dart';
import 'package:customer_portal/profile/profile_menu.dart';
import 'package:customer_portal/profile/profile_pic.dart';
import 'package:customer_portal/viewModels/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/themes.dart';
import '../home/bottomNavigation.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        // Add other providers if needed
      ],
      child: _ProfileScreen(),
    );
  }
}

class _ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  final logger = Logger();
  late ProfileProvider profileProvider;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _token = "";

  @override
  void initState() {
    super.initState();
    print('initState--');
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);

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
    return FutureBuilder(
        future: profileProvider.getProfile(
            _token,

        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold( // Wrap the CircularProgressIndicator with a Scaffold
                backgroundColor: Colors.white,
                // Set the background color to white
                body:
                Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.theme_color,
                      strokeWidth: 2, // Adjust the size as needed
                    ),
                  ),
                )
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Profile", style: TextStyle(
                  color: AppColors.black,
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
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                     ProfilePic(isEdit: false,token:_token,customerId:profileProvider.profileDetails[0].customerId,fileName:profileProvider.profileDetails[0].fileName),
                    const SizedBox(height: 5),
                    Center(
                      child: Column(children: [
                        Text(
                          '${profileProvider.profileDetails[0].customerName}',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${profileProvider.profileDetails[0].routeName} - ${profileProvider.profileDetails[0].areaName}',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                          '${profileProvider.profileDetails[0].paymentTerm}',
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic),
                        ),
                      ]),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileEdit(),
                              settings: RouteSettings(
                                arguments: {'profile': profileProvider.profileDetails[0]},
                              ),
                            ),
                          );

                        },
                        child:
                        Container(
                          width: 60,
                          height: 30,
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
                          child: Center(
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                // fontStyle: FontStyle.italic
                              ),
                            ),
                          ),
                        )),

                    const SizedBox(height: 20),
                    Center(
                        child: Container(
                          // color: AppColors.light_theme_color,
                          padding: EdgeInsets.all(12),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/profile/telephone.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails.isNotEmpty && profileProvider.profileDetails[0].contactNo != null && profileProvider.profileDetails[0].contactNo!="" ? profileProvider.profileDetails[0].contactNo : "Not available"}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/profile/whatsapp.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails.isNotEmpty && profileProvider.profileDetails[0].whatsAppNo != null && profileProvider.profileDetails[0].whatsAppNo!="" ? profileProvider.profileDetails[0].whatsAppNo : "Not available"}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/profile/joining_date.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails.isNotEmpty && profileProvider.profileDetails[0].doj != null && profileProvider.profileDetails[0].doj!="" ? profileProvider.profileDetails[0].doj : "Not available"}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset('assets/profile/email.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails.isNotEmpty && profileProvider.profileDetails[0].emailId != null && profileProvider.profileDetails[0].emailId!="" ? profileProvider.profileDetails[0].emailId : "Not available"}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset('assets/home/location.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails.isNotEmpty && profileProvider.profileDetails[0].officeAddress != null && profileProvider.profileDetails[0].officeAddress!="" ? profileProvider.profileDetails[0].officeAddress : "Not available"}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/profile/credit_limit.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails.isNotEmpty && profileProvider.profileDetails[0].creditLimit != null && profileProvider.profileDetails[0].creditLimit!=0.0 ? profileProvider.profileDetails[0].creditLimit : "Not available"}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),

                                          ),
                                          // Text(
                                          //   '${'*' * employee.password.length}', // Replace each character with an asterisk
                                          //   style: TextStyle(
                                          //     color: AppColors.black,
                                          //     fontSize: 18,
                                          //     fontWeight: FontWeight.normal,
                                          //   ),
                                          // ),

                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset('assets/profile/bottle.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails.isNotEmpty && profileProvider.profileDetails[0].bottleCustody != null && profileProvider.profileDetails[0].bottleCustody!=0? profileProvider.profileDetails[0].bottleCustody : "Not available"}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/profile/delivery.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails[0].deliveryType}( ${profileProvider.profileDetails[0].frequance} )",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset('assets/profile/item.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails[0].itemName} ",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset('assets/profile/price.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails[0].itemPrice}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset('assets/home/user.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails[0].salesExecutive}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/profile/customer_type.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails[0].customerType}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/profile/username.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${profileProvider.profileDetails[0].userName}",
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                            'assets/profile/password.png',
                                            width: 20,
                                            height: 20,
                                            color: AppColors.theme_color),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Flexible(
                                          child:
                                          // Text(
                                          //   "****",
                                          //   style: TextStyle(
                                          //     color: AppColors.black,
                                          //     fontSize: 18,
                                          //     fontWeight: FontWeight.normal,
                                          //   ),
                                          //
                                          // ),
                                          Text(
                                            '${'*' * profileProvider.profileDetails[0].password!.length}', // Replace each character with an asterisk
                                            style: TextStyle(
                                              color: AppColors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),

                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),


                            ],
                          ),
                        )),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.theme_color,
                              width: 0.5),
                          borderRadius: BorderRadius.circular(6),),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Align to the start
                          children: [
                            Text('Schedule', style: TextStyle(
                              color: AppColors.theme_color,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text('${profileProvider.profileDetails[0].anticipate}', style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      // SizedBox(
                                      //   width: 10,
                                      // ),
                                      // Flexible(
                                      //   child: Text(
                                      //     "0",
                                      //     style: TextStyle(
                                      //       color: AppColors.black,
                                      //       fontSize: 18,
                                      //       fontWeight: FontWeight.normal,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Row(
                                //     children: [
                                //       Text('MON', style: TextStyle(
                                //         color: AppColors.black,
                                //         fontSize: 18,
                                //         fontWeight: FontWeight.bold,
                                //       ),),
                                //       SizedBox(
                                //         width: 10,
                                //       ),
                                //       Flexible(
                                //         child: Text(
                                //           "2",
                                //           style: TextStyle(
                                //             color: AppColors.black,
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.normal,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Expanded(
                                //   child: Row(
                                //     children: [
                                //       Text('TUE', style: TextStyle(
                                //         color: AppColors.black,
                                //         fontSize: 18,
                                //         fontWeight: FontWeight.bold,
                                //       ),),
                                //       SizedBox(
                                //         width: 10,
                                //       ),
                                //       Flexible(
                                //         child: Text(
                                //           "5",
                                //           style: TextStyle(
                                //             color: AppColors.black,
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.normal,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // Expanded(
                                //   child:
                                //   Row(
                                //     children: [
                                //       Text('WED', style: TextStyle(
                                //         color: AppColors.black,
                                //         fontSize: 18,
                                //         fontWeight: FontWeight.bold,
                                //       ),),
                                //       SizedBox(
                                //         width: 10,
                                //       ),
                                //       Flexible(
                                //         child: Text(
                                //           "5",
                                //           style: TextStyle(
                                //             color: AppColors.black,
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.normal,
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Expanded(
                            //       child: Row(
                            //         children: [
                            //           Text('THU', style: TextStyle(
                            //             color: AppColors.black,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold,
                            //           ),),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Flexible(
                            //             child: Text(
                            //               "0",
                            //               style: TextStyle(
                            //                 color: AppColors.black,
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.normal,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: Row(
                            //         children: [
                            //           Text('FRI', style: TextStyle(
                            //             color: AppColors.black,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold,
                            //           ),),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Flexible(
                            //             child: Text(
                            //               "7",
                            //               style: TextStyle(
                            //                 color: AppColors.black,
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.normal,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child:
                            //       Row(
                            //         children: [
                            //           Text('SAT', style: TextStyle(
                            //             color: AppColors.black,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold,
                            //           ),),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Flexible(
                            //             child: Text(
                            //               "5",
                            //               style: TextStyle(
                            //                 color: AppColors.black,
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.normal,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child:
                            //       Row(
                            //         children: [
                            //           Text('', style: TextStyle(
                            //             color: AppColors.black,
                            //             fontSize: 18,
                            //             fontWeight: FontWeight.bold,
                            //           ),),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Flexible(
                            //             child: Text(
                            //               "",
                            //               style: TextStyle(
                            //                 color: AppColors.black,
                            //                 fontSize: 18,
                            //                 fontWeight: FontWeight.normal,
                            //               ),
                            //             ),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // ),

                          ],
                        ),
                      ),
                    ),
                    // ProfileMenu(
                    //   text: "My Account",
                    //   icon: "assets/profile/User Icon.svg",
                    //   press: () => {},
                    // ),
                    // ProfileMenu(
                    //   text: "Notifications",
                    //   icon: "assets/profile/Bell.svg",
                    //   press: () {},
                    // ),
                    // ProfileMenu(
                    //   text: "Settings",
                    //   icon: "assets/profile/Settings.svg",
                    //   press: () {},
                    // ),
                    // ProfileMenu(
                    //   text: "Help Center",
                    //   icon: "assets/profile/Question mark.svg",
                    //   press: () {},
                    // ),
                    // ProfileMenu(
                    //   text: "Log Out",
                    //   icon: "assets/profile/Log out.svg",
                    //   press: () {},
                    // ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomNavigationMenu(0),
            );

        }
        });
  }
}
