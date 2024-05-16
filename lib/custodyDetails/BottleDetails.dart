import 'package:flutter/material.dart';

import '../config/themes.dart';
import '../models/bottleModel.dart';

class BottleDetails extends StatelessWidget {
  List<Bottles> bottles;
  List<BottlesCounts> bottleCount;

   BottleDetails({
    Key? key,
    required this.bottles, required this.bottleCount ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double columnWidth = size.width / 4; // Adjust the fraction as needed

    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Column(
        children: [
          DataTable(
            columnSpacing: 0,
            dataRowHeight: 50,
            columns: [
              DataColumn(label: SizedBox(width: columnWidth, child:
                Text(

                  'Ref No',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Metropolis',
                    color: Colors.black,
                  ),
                ),)
              ),
    DataColumn(label: SizedBox(width: columnWidth, child:
                Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Metropolis',
                    color: Colors.black,
                  ),
                ),
              ),),
                DataColumn(label: SizedBox(width: columnWidth, child:
                Text(
                  'Issue',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Metropolis',
                    color: Colors.black,
                  ),
                ),
              ),),
    DataColumn(label: SizedBox(width: columnWidth, child:
                Text(
                  'Return',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Metropolis',
                    color: Colors.black,
                  ),
                ),
    ),
              ),
            ],
            rows: bottles.map((item) {

              return DataRow(

                cells: [
                  DataCell(
                    Text(
                      item.docNo,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Metropolis',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.docDate.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Metropolis',
                        color: Colors.black,
                      ),
                    ),
                  ),

                  DataCell(
                    Text(
                      item.trxType.toString() == "Issue" ? item.qty.toString() : "0",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Metropolis',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.trxType.toString() == "Return" ? item.qty.toString() : "0",
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Metropolis',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Bottle Custody:',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                '${bottleCount[0].bottleCustody}',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Temporary Bottle:',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                '${bottleCount[0].tempBottleInHand} ',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

        ],
      ),
    );



  }
}