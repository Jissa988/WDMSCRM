import 'package:customer_portal/custodyDetails/BottleDetails.dart';
import 'package:customer_portal/viewModels/custody_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/themes.dart';
import '../constant/constants.dart';
import '../customised/quickAlerts/quickAlertDialogue.dart';
import '../customised/quickAlerts/quickAlertType.dart';
import '../models/bottleModel.dart';
import '../models/homeModel.dart';
import '../models/materialModels.dart';
import 'materialDetails.dart';

class CustodyDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final HomeEmployeeDetails? customerDetails =
        arguments?['homeDetails'] as HomeEmployeeDetails?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustodyProvider()),
        // Add other providers if needed
      ],
      child: _CustodyDetails(customerDetails: customerDetails),
    );
  }
}

class _CustodyDetails extends StatefulWidget {
  HomeEmployeeDetails? customerDetails;

  _CustodyDetails({required this.customerDetails});

  @override
  State<_CustodyDetails> createState() => _CustodyDetailsState();
}

class _CustodyDetailsState extends State<_CustodyDetails> {
  // final materialItemList = materialList.toList();

  // final bottleItemList = bottleList.toList();

  late CustodyProvider custodyProvider;
  String _token = "";

  @override
  void initState() {
    super.initState();
    custodyProvider = Provider.of<CustodyProvider>(context, listen: false);

    getSharedPreference();
    ;
  }

  Future<void> getSharedPreference() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _token = prefs.getString(Constants.API_TOKEN) ?? "";
      });
    } catch (e) {
      // Handle errors
      print('Error fetching shared preferences: $e');
    }
  }

  @override
  void dispose() {
    // _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,
      child:
      DefaultTabController(
        length: 2, // Define the number of tabs
        child: Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.theme_color,
                    AppColors.theme_color,
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: 32,
              ),
            ),
            titleSpacing: 8,
            title: Text(
              'Custody Details',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: TabBar(
              labelStyle: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: AppColors.white,
              unselectedLabelColor: AppColors.bs_teal,
              // indicatorWeight: 15,
              tabs: [
                Tab(text: 'Bottle '),
                Tab(
                  text: 'Material ',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Content of Tab 1
              FutureBuilder(
                future: custodyProvider.getBottleDetails(
                     _token,
                  // 3527),
                     widget.customerDetails!.customerId),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.theme_color,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    if (snapshot.error.toString().contains('Network is unreachable')) {
                      return Container(
                        color: AppColors.white,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(padding: EdgeInsets.only(right: 25,left: 25,bottom:15 ),child:
                              Image.asset(
                                'assets/quickAlerts/lightbulb.gif',
                                // width: 500,
                                // height: 100,
                              ),
                              ),
                              Flexible(child:
                              Padding(padding: EdgeInsets.all(10.0), child:
                              Text(
                                'Network is unreachable ,Please check your internet connection',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Metropolis',
                                  color: AppColors.theme_color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),  )
                              ),
                            ],
                          ),
                        ),);
                    }
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (custodyProvider.bottles.isNotEmpty) {
                      return Container(
                        child: BottleDetails(
                          bottles: custodyProvider.bottles,
                          bottleCount: custodyProvider.bottlesCounts,
                        ),
                      );
                    } else {
                      return
                        Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(padding: EdgeInsets.only(right: 25,left: 25,bottom:15 ),child:
                            Image.asset(
                              'assets/quickAlerts/lightbulb.gif',
                              // width: 500,
                              // height: 100,
                            ),
                            ),
                            Text(
                              'Data Not Found',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Metropolis',
                                color: AppColors.theme_color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );


                    }
                  }
                },
              ),
              // Content of Tab 2
              FutureBuilder(
                future: Future.delayed(Duration.zero), // Placeholder future
                builder: (context, snapshot) {
                  if (custodyProvider.materials.isEmpty) {
                    // If materials are empty, show a loading indicator
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.theme_color,
                        strokeWidth: 2,
                      ),
                    );
                  } else {
                    // Render material details widget using custodyProvider.materials
                    return MaterialDetails(
                      materials: custodyProvider.materials,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
