import 'package:customer_portal/custodyDetails/BottleDetails.dart';
import 'package:customer_portal/viewModels/custody_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/themes.dart';
import '../constant/constants.dart';
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
    return MaterialApp(
      home: DefaultTabController(
        length: 2, // Define the number of tabs
        child: Scaffold(
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
                fontSize: 22,
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
                    _token, widget.customerDetails!.customerId),
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
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Add return statement here
                    return custodyProvider.bottles.isNotEmpty
                        ? Container(
                            child: BottleDetails(
                              bottles: custodyProvider.bottles,
                              bottleCount: custodyProvider.bottlesCounts,
                            ),
                          )
                        : Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                color: AppColors.white,
                                elevation: 2,
                                shadowColor: AppColors.theme_color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 16,
                                    ),
                                    // minLeadingWidth: task.isDone ? 0 : 2,
                                    title: Center(
                                      child: Text(
                                        'Data Not Found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Metropolis',
                                          color: AppColors.theme_color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          );
                  }
                },
              ),

              // Content of Tab 2
              FutureBuilder(
                future: custodyProvider.getmaterialDetails(
                    _token, widget.customerDetails!.customerId),
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
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Add return statement here
                    return custodyProvider.materials.isNotEmpty
                        ? Container(
                            child: MaterialDetails(
                              materials: custodyProvider.materials,
                            ),
                          )
                        : Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                                right: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Card(
                                color: AppColors.white,
                                elevation: 2,
                                shadowColor: AppColors.theme_color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 16,
                                    ),
                                    // minLeadingWidth: task.isDone ? 0 : 2,
                                    title: Center(
                                      child: Text(
                                        'Data Not Found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Metropolis',
                                          color: AppColors.theme_color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
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
