import 'package:customer_portal/models/collectionModel.dart';
import 'package:flutter/material.dart';

import '../config/themes.dart';

class BottleProductDataTable extends StatelessWidget {
  final List<CollectionItemDetails> collectionItemDetails;

  BottleProductDataTable({
    required this.collectionItemDetails,
  });

  @override
  Widget build(BuildContext context) {
    double totalAmount = collectionItemDetails.fold(0, (previousValue, product) => previousValue + product.billAmount);

    return Container(
      child: Column(
        children: [
          DataTable(
            columnSpacing: 15,
            dataRowHeight: 50,
            columns: [
              DataColumn(
                label: Text(
                  'Invoice No',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Metropolis',
                    color: Colors.black,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Metropolis',
                    color: Colors.black,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Due',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Metropolis',
                    color: Colors.black,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Paid',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Metropolis',
                    color: Colors.black,
                  ),
                ),
              ),
            ],
            rows: collectionItemDetails.map((item) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      item!.docNo,
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Metropolis',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.docDt.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Metropolis',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.settled.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Metropolis',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      item.billAmount.toString(),
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
                'Total:',
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 20,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                '${totalAmount} AED',
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
