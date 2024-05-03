import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/constant/extensions.dart';
import 'package:customer_portal/home/homePage.dart';
import 'package:customer_portal/models/homeModel.dart';
import 'package:customer_portal/viewModels/sales_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constants.dart';
import '../models/saleInvoiceModel.dart';
import 'archivePage.dart';
import 'salesCardWidget.dart';
import 'formWidget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SalesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final HomeEmployeeDetails? customerDetails =
        arguments?['homeDetails'] as HomeEmployeeDetails?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        // Add other providers if needed
      ],
      child: _SalesList(customerDetails: customerDetails),
    );
  }
}

class _SalesList extends StatefulWidget {
  HomeEmployeeDetails? customerDetails;

  _SalesList({required this.customerDetails});

  // const _SalesList({Key? key}) : super(key: key);

  @override
  State<_SalesList> createState() => _SalesListState();
}

class _SalesListState extends State<_SalesList> {
  // final salesInvoiceItemList = salesInvoice.toList();
  // where((element) => !element.isDone).
  late SalesProvider salesProvider;
  String _token = "";

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();

    salesProvider = Provider.of<SalesProvider>(context, listen: false);

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double height=size.height;
    double headerHeight=size.height/3;
    double containerHeight=height-headerHeight;
    return FutureBuilder(
        future: salesProvider.getSalesList(
            _token,
            widget.customerDetails!.finyearId,
            widget.customerDetails!.customerId,
            _startDate.toString(),
            _endDate.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold( // Wrap the CircularProgressIndicator with a Scaffold
                backgroundColor: Colors.white, // Set the background color to white
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
            return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                backgroundColor: AppColors.white,
                resizeToAvoidBottomInset: false,
                body: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Container(
                          width: size.width,
                          height: size.height / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10),
                            ),
                            gradient: LinearGradient(
                              colors: [
                                AppColors.theme_color,
                                AppColors.theme_color,
                              ],
                              begin: Alignment.centerRight,
                              end: Alignment.centerLeft,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 60),
                              // Center(
                              SizedBox(width: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      color: AppColors.white,
                                      size: 32,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Invoices',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 30,
                                      fontFamily: 'Metropolis',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _selectDateRange(context);
                                    },
                                    child: Image.asset('assets/home/filter.png',
                                        width: 25,
                                        height: 25,
                                        color: AppColors.white
                                        // You can adjust width and height as needed
                                        ),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                              // ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(width: 30),
                                  Icon(
                                    Icons.calendar_today,
                                    color: AppColors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
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
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(width: 30),
                                            Icon(
                                              Icons.check,
                                              color: AppColors.white,
                                              size: 16,
                                            ),
                                            SizedBox(width: 5),
                                            Flexible(child:
                                            Text(
                                              'Paid - ${salesProvider.invoiceCount[0].paidCount}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Metropolis',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(children: [
                                          // SizedBox(width: 30),
                                          Icon(
                                            Icons.close,
                                            color: AppColors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 5),
                                          Flexible(child:
                                          Text(
                                            'Unpaid - ${salesProvider.invoiceCount[0].upaidCount}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Metropolis',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          ),],)

                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(children: [
                                      // SizedBox(width: 30),
                                      Icon(
                                        Icons.radio_button_unchecked,
                                        color: AppColors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 5),
                                     Flexible(child:
                                     Text('Partial - ${salesProvider.invoiceCount[0].patialCount} ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Metropolis',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                     ),
                                    ],)

                                    ],
                                  ),
                                  ),
                                ],
                              ),



                          ],
                          ),


                        ),
                      ),
                      salesProvider.salesInvoice.isNotEmpty
                          ? Positioned(
                              top: size.height / 4.5,
                              left: 16,
                              child: Container(
                                width: size.width - 32,
                                height: size.height * 0.76,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10),
                                    right: Radius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return SalesCardWidget(
                                        salesInvoice:
                                            salesProvider.salesInvoice[index],
                                          homeDetails:widget.customerDetails,
                                      );
                                    },
                                    itemCount:
                                        salesProvider.salesInvoice.length,
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 4,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            )
                          : Positioned(
                              top: size.height / 4.5,
                              left: 16,
                              child: Container(
                                width: size.width - 32,
                                height: size.height / 3,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(10),
                                    right: Radius.circular(10),
                                  ),
                                ),
                                child:Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(padding: EdgeInsets.only(bottom:15 ),
                                        child:
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
                                ),

                              ),
                            )
                    ],
                  ),
                ),
              ),
            );
          }
        });
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
// bottomNavigationBar: BottomAppBar(
//   color: const Color(0xff2da9ef),
//   shape: const CircularNotchedRectangle(),
//   notchMargin: 8,
//   child: Row(
//     mainAxisSize: MainAxisSize.max,
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       IconButton(
//         onPressed: () {},
//         icon: const Icon(
//           Icons.list_alt_rounded,
//           color: Colors.white,
//           size: 28,
//         ),
//       ),
//       IconButton(
//         onPressed: () {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) {
//                 return const ArchivePage();
//               },
//             ),
//           );
//         },
//         icon: const Icon(
//           Icons.archive_outlined,
//           color: Colors.white,
//           size: 28,
//         ),
//       ),
//     ],
//   ),
// ),
// floatingActionButton: FloatingActionButton(
//   onPressed: () {
//     showDialog(
//         context: context,
//         builder: (context) {
//           return const FormWidget();
//         });
//   },
//   backgroundColor: const Color(0xff2da9ef),
//   foregroundColor: const Color(0xffffffff),
//   child: const Icon(
//     Icons.add,
//     size: 36,
//   ),
// ),
// floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
