import 'package:customer_portal/sales/salesCardWidget.dart';
import 'package:customer_portal/sales/salesDetailsTableWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/themes.dart';
import '../constant/constants.dart';
import '../models/homeModel.dart';
import '../models/saleInvoiceModel.dart';
import '../viewModels/sales_provider.dart';


class SalesDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final int salesInvoiceId =
    arguments?['salesInvoiceId'] ;
    final String headType =
    arguments?['headType'] ;


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        // Add other providers if needed
      ],
      child: _SalesDetails(
        salesInvoiceId: salesInvoiceId,
          headType:headType
      ),
    );
  }
}


class _SalesDetails extends StatefulWidget {
  int salesInvoiceId;
  String headType;
  _SalesDetails({required this.salesInvoiceId,required this.headType});

  @override
  State<_SalesDetails> createState() => _SalesDetailsState();
}


class _SalesDetailsState extends State<_SalesDetails> {
  // final productItemList = saleProduct.toList();
  late SalesProvider salesProvider;
  String _token = "";

  @override
  void initState() {
    super.initState();

    salesProvider = Provider.of<SalesProvider>(context, listen: false);

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('SalesDetails---');

    return FutureBuilder(
        future:widget.headType=="Sale"? salesProvider.getSalesDetails(
            _token,
            widget.salesInvoiceId):salesProvider.getDoDetails(
            _token,
            widget.salesInvoiceId),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return
              Scaffold(
                // Wrap the CircularProgressIndicator with a Scaffold
                backgroundColor: Colors.white,
                // Set the background color to white
                body: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.theme_color,
                      strokeWidth: 2, // Adjust the size as needed
                    ),
                  ),
                ));
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return  WillPopScope(
                onWillPop: () async => false,
          child: Scaffold(
              backgroundColor: AppColors.white,
              appBar: AppBar(
                title: Text(
                  'Tax Invoice',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 30,
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                titleSpacing: 8,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 32,
                  ), // Your custom back icon
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Container(
                padding: EdgeInsets.all(12),
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doc no : ${salesProvider.salesHeadItems[0].invoiceNo}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 25,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'Date : ${salesProvider.salesHeadItems[0].invoiceDate} ${salesProvider.salesHeadItems[0].invoiceTime}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      'To : ${salesProvider.salesHeadItems[0].customerName} ',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${salesProvider.salesHeadItems[0].routeName} - ${salesProvider.salesHeadItems[0].area}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Text(
                    //   '9089786534',
                    //   style: TextStyle(
                    //     color: AppColors.black,
                    //     fontSize: 20,
                    //     fontFamily: 'Metropolis',
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    // Text(
                    //   'TRN000078',
                    //   style: TextStyle(
                    //     color: AppColors.black,
                    //     fontSize: 20,
                    //     fontFamily: 'Metropolis',
                    //     fontWeight: FontWeight.w500,
                    //   ),
                    // ),
                    Text(
                      '${salesProvider.salesHeadItems[0].createdBy}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      child: ProductDataTable(
                        productList: salesProvider.salesItem,
                        sales:salesProvider.salesHeadItems[0]
                      ),
                    ),
                  ],
                ),
              ),
            ));
          }
        });
  }
}
