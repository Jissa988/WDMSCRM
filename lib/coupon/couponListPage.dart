import 'dart:ui';

import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/constant/constants.dart';
import 'package:customer_portal/viewModels/coupon_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/couponModel.dart';
import '../models/homeModel.dart';
import 'couponCard.dart';

class CouponListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final HomeEmployeeDetails? customerDetails =
        arguments?['homeDetails'] as HomeEmployeeDetails?;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CouponProvider()),
        // Add other providers if needed
      ],
      child: _CouponListPage(customerDetails: customerDetails),
    );
  }
}

class _CouponListPage extends StatefulWidget {
  HomeEmployeeDetails? customerDetails;

  _CouponListPage({required this.customerDetails});

  @override
  State<_CouponListPage> createState() => _CouponListPageState();
}

class _CouponListPageState extends State<_CouponListPage> {
  late CouponProvider couponProvider;
  String _token = "";

  @override
  void initState() {
    super.initState();
    couponProvider = Provider.of<CouponProvider>(context, listen: false);

    getSharedPreference();
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
    // var _theme = CustomerPortalTheme.of(context);
    return  WillPopScope(
        onWillPop: () async => false,
    child:
      Scaffold(
        backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
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
        titleSpacing: 8,
        title: Text(
          'Available Coupons',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: couponProvider.getCoupons(
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
            // Add return statement here
            return couponProvider.coupons.isNotEmpty
                ? Container(
                    color: AppColors.background.withOpacity(0.01),
                    child: ListView.separated(
                      itemCount: couponProvider.coupons.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 0.0),
                      // Adjust the height of the separator as needed
                      itemBuilder: (context, index) {
                        Coupons coupon = couponProvider.coupons[index];
                        bool shouldChangeColor =
                            coupon.utilizedStatus == "Not Utilized"
                                ? false
                                : true;
                        bool isPaid =
                            coupon.couponStatus == "Paid" ? true : false;

                        // Check if the current coupon's series number is different from the previous one
                        bool isNewSeries = index == 0 ||
                            coupon.seriesNo !=
                                couponProvider.coupons[index - 1].seriesNo;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display the series number if it's a new series
                            if (isNewSeries)
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, top: 10, bottom: 10),
                                child: Text(
                                  '${coupon.book} : ${coupon.seriesNo} ( ${coupon.amount} AED )',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Metropolis',
                                    color: AppColors.theme_color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              child: CouponCard(
                                width: double.infinity,
                                height: 100,
                                borderRadius: 12,
                                curveRadius: 20,
                                curvePosition: 100,
                                curveAxis: Axis.vertical,
                                clockwise: false,
                                backgroundColor: AppColors.white,
                                shadow: BoxShadow(
                                  color: AppColors.theme_color,
                                ),
                                border: BorderSide(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.4),
                                ),
                                firstChild: shouldChangeColor
                                    ? FirstChildWidgetWithBlur(

                                        couponSerialno: coupon.serialNo,
                                        couponPrice: coupon.leafletPrice,
                                      )
                                    : FirstChildWidgetWithOutBlur(
                                        couponSerialno: coupon.serialNo,
                                        couponPrice: coupon.leafletPrice,
                                      ),
                                secondChild: shouldChangeColor
                                    ? SecondChildWithBlur(

                                        couponSerialno: coupon.serialNo,
                                        couponPrice: coupon.leafletPrice,
                                        couponName: coupon.book,
                                        isPaid: isPaid,
                                        shouldChangeColor: shouldChangeColor)
                                    : SecondChildWithOutBlur(

                                        couponSerialno: coupon.serialNo,
                                        couponPrice: coupon.leafletPrice,
                                        couponName: coupon.book,
                                        isPaid: isPaid,
                                        shouldChangeColor: shouldChangeColor),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                :
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
        },
      ),
    ));
  }
}

class FirstChildWidgetWithBlur extends StatelessWidget {

  final String couponSerialno;
  final double couponPrice;

  const FirstChildWidgetWithBlur({
    Key? key,

    required this.couponSerialno,
    required this.couponPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 0.2, sigmaY: 1.0),
      // Adjust blur values as needed
      child: Container(
        color: AppColors.theme_color.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'S/N: $couponSerialno',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$couponPrice AED',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FirstChildWidgetWithOutBlur extends StatelessWidget {

  final String couponSerialno;
  final double couponPrice;

  const FirstChildWidgetWithOutBlur({
    Key? key,

    required this.couponSerialno,
    required this.couponPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.theme_color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'S/N: $couponSerialno',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Metropolis',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$couponPrice AED',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 13,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class SecondChildWithBlur extends StatelessWidget {

  final String couponSerialno;
  final double couponPrice;
  final String couponName;
  final bool isPaid;
  final bool shouldChangeColor;

  const SecondChildWithBlur(
      {Key? key,

      required this.couponSerialno,
      required this.couponPrice,
      required this.couponName,
      required this.isPaid,
      required this.shouldChangeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 0.4, sigmaY: 1.0),
      child: Container(
        color: AppColors.theme_color.withOpacity(0.1),
        width: double.infinity, // Make the container full width
        height: double.infinity, // Make the container full height
        child: Stack(
          children: [
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // Center the Row horizontally
                  children: [
                    Image.asset(
                      'assets/coupon/bottle.png',
                      width: 75,
                      height: 75,

                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Align text to start
                      children: [
                        Text(
                          couponName,
                          style: TextStyle(
                            color: AppColors.lightGray,
                            fontSize: 13,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          'S/N: $couponSerialno',
                          style: TextStyle(
                            color: AppColors.lightGray,
                            fontSize: 13,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          isPaid ? '$couponPrice AED' :  '',
                          style: TextStyle(
                            color: AppColors.lightGray,
                            fontSize: 13,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 25.0, // Adjust as needed
              right: 0.0,

              //   // Align to right side
              child: Text(
                isPaid ? '' : '  Free Coupon',
                style: TextStyle(
                  color: AppColors.lightGray,
                  fontSize: 10,
                  backgroundColor: AppColors.redish_brown,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 8.0,
              right: 8.0,
              child: Text(
                shouldChangeColor ? 'Utilized' : '',
                style: TextStyle(
                    color: AppColors.lightGray,
                    fontSize: 10,
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondChildWithOutBlur extends StatelessWidget {

  final String couponSerialno;
  final double couponPrice;
  final String couponName;
  final bool isPaid;
  final bool shouldChangeColor;

  const SecondChildWithOutBlur(
      {Key? key,

      required this.couponSerialno,
      required this.couponPrice,
      required this.couponName,
      required this.isPaid,
      required this.shouldChangeColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity, // Make the container full width
        height: double.infinity, // Make the container full height
        child: Stack(
          children: [
            Container(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // Center the Row horizontally
                  children: [
                    Image.asset(
                      'assets/coupon/bottle.png',
                      width: 75,
                      height: 75,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // Align text to start
                      children: [
                        Text(
                          couponName,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'S/N: $couponSerialno',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isPaid ? '$couponPrice AED' :  '',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                            fontFamily: 'Metropolis',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 25.0, // Adjust as needed
              right: 0.0, // Align to right side
              child: Text(
                isPaid ? '' : '  Free Coupon',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 10,
                  backgroundColor: AppColors.redish_brown,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 8.0,
              right: 8.0,
              child: Text(
                shouldChangeColor ? 'Utilized' : '',
                style: TextStyle(
                    color: AppColors.lightGray,
                    fontSize: 10,
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
