

import 'package:customer_portal/models/outstandingModel.dart';
import 'package:flutter/material.dart';

import '../config/themes.dart';

class OutstandingList extends StatelessWidget {
  final Outstandings outstandings;
  const OutstandingList({
    Key? key,
    required this.outstandings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
              outstandings.invoiceNo,
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
                    '${outstandings.invoiceAmount} AED',
                    style: TextStyle(
                      color: AppColors.bs_teal,
                      fontSize: 16,
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  outstandings.invoiceDate,
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
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${outstandings.balanceAmount} AED',
                style: TextStyle(
                  color: AppColors.theme_color,
                  fontSize: 16,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // ),
          ],
        ),

      ),
    );
  }
}