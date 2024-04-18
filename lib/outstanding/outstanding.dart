import 'package:customer_portal/custodyDetails/BottleDetails.dart';
import 'package:customer_portal/outstanding/CollectionList.dart';
import 'package:customer_portal/outstanding/outstandingList.dart';
import 'package:customer_portal/viewModels/outstanding_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:customer_portal/constant/extensions.dart';

import '../config/themes.dart';
import '../constant/constants.dart';
import '../home/homePage.dart';
import '../models/homeModel.dart';

class Outstanding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final HomeEmployeeDetails? customerDetails =
    arguments?['homeDetails'] as HomeEmployeeDetails?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OutstandingProvider()),
        // Add other providers if needed
      ],
      child: _Outstanding(
          customerDetails: customerDetails
      ),
    );
  }
}


class _Outstanding extends StatefulWidget {
  HomeEmployeeDetails? customerDetails;

  _Outstanding({required this.customerDetails});

  @override
  State<_Outstanding> createState() => _OutstandingState();
}

class _OutstandingState extends State<_Outstanding>
    with SingleTickerProviderStateMixin {
  // late TabController _tabController;
  int _selectedTabIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;
  late OutstandingProvider outstandingProvider;
  String _token = "";

  @override
  void initState() {
    super.initState();
    outstandingProvider =
        Provider.of<OutstandingProvider>(context, listen: false);

    getSharedPreference();
    _startDate = DateTime.now().subtract(Duration(days: 30));
    _endDate = DateTime.now();
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
            title: _selectedTabIndex == 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${_startDate?.formatDate() ?? ''}  '
                        '${DateFormat('MMM').format(_startDate ?? DateTime.now())} ${_startDate?.year.toString() ?? ''} - ${_endDate?.formatDate() ?? ''}  ${DateFormat('MMM').format(_endDate ?? DateTime.now())} ${_endDate?.year.toString() ?? ''} ',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Metropolis',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDateRange(context);
                        },
                        child: Image.asset('assets/home/filter.png',
                            width: 25, height: 25, color: AppColors.white
                            // You can adjust width and height as needed
                            ),
                      ),
                    ],
                  )
                : null,
            bottom: TabBar(
              // controller: _tabController,
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              labelStyle: TextStyle(
                color: AppColors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              indicatorColor: AppColors.white,
              unselectedLabelColor: AppColors.bs_teal,
              // indicatorWeight: 15,

              tabs: [
                Tab(
                  text: 'Outstanding Bills',
                ),
                Tab(text: 'Payments'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Content of Tab 1

              FutureBuilder(
                future: outstandingProvider.getOutstandings(
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
                    return outstandingProvider.outstandings.isNotEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  return OutstandingList(
                                    outstandings:
                                        outstandingProvider.outstandings[index],
                                  );
                                },
                                itemCount:
                                    outstandingProvider.outstandings.length,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 4,
                                  );
                                },
                              ),
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
              FutureBuilder(
                  future: outstandingProvider.getCollectionList(
                      _token,
                      widget.customerDetails!.customerId,
                      _startDate.toString(),
                      _endDate.toString(),
                      3),
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

                      return outstandingProvider.collections.isNotEmpty
                          ? Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CollectionList(
                                          collections: outstandingProvider
                                              .collections[index],
                                          homeDetails:widget.customerDetails,
                                        );
                                      },
                                      itemCount: outstandingProvider
                                          .collections.length,
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(
                                          height: 4,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(
                        height: 20, // Fixed height
                        child: Container(
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 16,
                                ),
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
                                ),
                              ),
                            ),
                          ),
                        ),
                      );

                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime? startDate = _startDate;
    DateTime? endDate = _endDate;
    DateTime initialDate = DateTime(2022, 1, 1); // One year ago
    DateTime lastDate = DateTime.now(); // One year from now

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date Range'),
          content: Container(
            width: 300.0, // Adjust width as needed
            height: 300.0, // Adjust height as needed
            child: SfDateRangePicker(
              startRangeSelectionColor: AppColors.theme_color,
              endRangeSelectionColor: AppColors.theme_color,
              rangeSelectionColor: AppColors.theme_color.withOpacity(0.2),
              view: DateRangePickerView.month,
              selectionMode: DateRangePickerSelectionMode.range,
              onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                if (args.value is PickerDateRange) {
                  PickerDateRange range = args.value;
                  startDate = range.startDate;
                  endDate = range.endDate;
                }
              },
              initialSelectedRange: PickerDateRange(startDate, endDate),
              minDate: initialDate,
              // Set the initial date
              maxDate: lastDate, // Set the last date
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (startDate != null && endDate != null) {
                  setState(() {
                    _startDate = startDate!;
                    _endDate = endDate!;
                  });
                }
              },
              child: Text(
                'Done',
                style: TextStyle(color: AppColors.theme_color),
              ),
            ),
          ],
        );
      },
    );
  }
}
