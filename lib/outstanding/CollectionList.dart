import 'package:customer_portal/models/collectionModel.dart';
import 'package:flutter/material.dart';
import '../config/themes.dart';
import '../models/homeModel.dart';
import 'collectionDetails.dart';

class CollectionList extends StatelessWidget {
  final Collections collections;
  final HomeEmployeeDetails? homeDetails;
  const CollectionList({
    Key? key,
    required this.collections,
    required this.homeDetails
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return  GestureDetector(
        onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CollectionDetails(),
          settings: RouteSettings(
            arguments: {'voucherId': collections.voucherId,'finyearId':collections.finYearId,'typeId':collections.typeId},
          ),
        ),
      );

        },
    child:Card(
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

            Text(
              collections.VoucherNo,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Text(
                    '${collections.receiptType}',
                    style: TextStyle(
                      color: AppColors.bs_teal,
                      fontSize: 16,
                      fontFamily: 'Metropolis',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${collections.voucherDate} ${collections.transTime}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Metropolis',
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightGray,
                  ),
                ),
              ],
            ),


            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${collections.totalAmount} AED ',
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
    ),
    );
  }
}