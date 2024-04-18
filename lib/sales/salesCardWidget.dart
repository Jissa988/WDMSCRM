import 'package:customer_portal/config/themes.dart';
import 'package:customer_portal/sales/salesDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/homeModel.dart';
import '../models/saleInvoiceModel.dart';

class SalesCardWidget extends StatelessWidget {
  final SalesInvoice salesInvoice;
  final HomeEmployeeDetails? homeDetails;

  const SalesCardWidget({
    Key? key,
    required this.salesInvoice, required this.homeDetails
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return  GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SalesDetails(),
          settings: RouteSettings(
            arguments: {'salesInvoiceId': salesInvoice.heaaId,'headType':salesInvoice.strxType},
          ),
        ),
      );

        },
    child:
      Card(
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
            horizontal: 16,),
          // minLeadingWidth: task.isDone ? 0 : 2,
          leading
              : Container(
            width: 2,
            color:  AppColors.bs_teal,
          ),
          title:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              //   child:
            Text(
                  salesInvoice.invoiceNo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child:
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${salesInvoice.paymentTerm}',
                        style: TextStyle(
                          color: AppColors.bs_teal,
                          fontSize: 16,
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${salesInvoice.invoiceDate} ${salesInvoice.invoiceTime}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightGray,
                      ),
                    ),
                  ],
                ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0, right: 16.0, bottom: 8.0),
              //   child:
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${salesInvoice.paymentStatus}',
                      style: TextStyle(
                        color: AppColors.theme_color,
                        fontSize: 16,
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '${salesInvoice.netAmount} AED',
                    style: TextStyle(
                      color: AppColors.bs_teal,
                      fontSize: 16,
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child:
                //   Text(
                //     '${salesInvoice.totalAmount} AED',
                //     style: TextStyle(
                //       color: AppColors.bs_teal,
                //       fontSize: 16,
                //       fontFamily: 'Metropolis',
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
              // ),
            ],
          ),

        ),
      ),
    // );
    );
  }
}
// Slidable(
// key: const ValueKey(0),
// startActionPane: ActionPane(
//   motion: const ScrollMotion(),
//   dismissible: DismissiblePane(onDismissed: () {}),
//   children: [
//     const SizedBox(
//       width: 2,
//     ),
//     SlidableAction(
//       borderRadius: BorderRadius.circular(16),
//       onPressed: (_) {},
//       backgroundColor: const Color(0xff2da9ef),
//       foregroundColor: Colors.white,
//       icon: Icons.done_outline_rounded,
//       label: 'Done',
//     ),
//     const SizedBox(
//       width: 2,
//     ),
//     SlidableAction(
//       borderRadius: BorderRadius.circular(16),
//       onPressed: (_) {},
//       backgroundColor: const Color(0xFFFE4A49),
//       foregroundColor: Colors.white,
//       icon: Icons.delete,
//       label: 'Remove',
//     ),
//   ],
// ),
// child: