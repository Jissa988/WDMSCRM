import 'package:customer_portal/models/collectionModel.dart';
import 'package:customer_portal/sales/salesCardWidget.dart';
import 'package:customer_portal/sales/salesDetailsTableWidget.dart';
import 'package:customer_portal/viewModels/outstanding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/themes.dart';
import '../constant/constants.dart';
import '../models/homeModel.dart';
import 'collectionDetailsTableWidget.dart';



class CollectionDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final int voucherId = arguments?['voucherId'] ;
    final int finyearId = arguments?['finyearId'] ;
    final int typeId = arguments?['typeId'] ;


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OutstandingProvider()),
        // Add other providers if needed
      ],
      child: _CollectionDetails(
        voucherId: voucherId,
          finyearId:finyearId,
          typeId:typeId,
      ),
    );
  }
}


class _CollectionDetails extends StatefulWidget {
  int voucherId;
  int finyearId;
  int typeId;
  _CollectionDetails({required this.voucherId, required this.finyearId,required this.typeId});

  @override
  State<_CollectionDetails> createState() => _CollectionDetailsState();
}

class _CollectionDetailsState extends State<_CollectionDetails> {
  late OutstandingProvider outstandingProvider;
  String _token = "";

  @override
  void initState() {
    super.initState();

    outstandingProvider = Provider.of<OutstandingProvider>(context, listen: false);

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
    print('CollectionDetails---');
    return FutureBuilder(
        future: outstandingProvider.getCollectionDetails(
            _token, widget.voucherId,widget.finyearId,widget.typeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
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
            child:  Scaffold(
              appBar: AppBar(
                title: Text(
                  'Receipt Voucher',
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
                      'Receipt no : ${outstandingProvider.collectionHeaderDetails[0].voucherNo}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 25,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'Date : ${outstandingProvider.collectionHeaderDetails[0].voucherDate} ${outstandingProvider.collectionHeaderDetails[0].voucherTime}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    Text(
                      'To : ${outstandingProvider.collectionHeaderDetails[0].customerName}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${outstandingProvider.collectionHeaderDetails[0].routeName} - ${outstandingProvider.collectionHeaderDetails[0].areaName}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Text(
                    //   '${}',
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
                      '${outstandingProvider.collectionHeaderDetails[0].createdBy}',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 20,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Container(
                      child: CollectionProductDataTable(
                        collectionItemDetails: outstandingProvider.collectionItemDetails,
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
