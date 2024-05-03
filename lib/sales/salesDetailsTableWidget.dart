import 'package:flutter/material.dart';

import '../config/themes.dart';
import '../models/saleInvoiceModel.dart';



class ProductDataTable extends StatelessWidget {
  final List<SalesItem> productList;
  final SalesHeadItems? sales;

  ProductDataTable({
    required this.productList,required this.sales ,
  });

  @override
  Widget build(BuildContext context) {
    double totalAmount = productList.fold(0, (previousValue, product) => previousValue + product.totalAmount);

    return Container(
      child: Column(children: [
      DataTable(
        dataRowHeight: 60,
      columns: [
        DataColumn(label:Flexible( child: Text('Item',style:
          TextStyle(
            fontSize: 15,
            fontFamily: 'Metropolis',
            color: Colors.black,
          ),
        ),)),
        DataColumn(label:Expanded( child: Text('Quantity',style:
        TextStyle(
          fontSize: 15,
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),))),
        DataColumn(label: Expanded( child:Text('Rate',style:
        TextStyle(
          fontSize: 15,
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),))),
        DataColumn(label: Expanded( child:Text('Amount',style:
        TextStyle(
          fontSize: 15,
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),))),
      ],
      rows: productList.map((product) {
        return DataRow(
            cells: [
          DataCell(Text(product.itemName,style:
          TextStyle(
            fontSize: 15,
            fontFamily: 'Metropolis',
            color: Colors.black,
          ),)),
          DataCell(Text(product.quantity.toString(),style:
          TextStyle(
            fontSize: 15,
            fontFamily: 'Metropolis',
            color: Colors.black,
          ),)),
          DataCell(Text(product.unitPrice.toString(),style:
          TextStyle(
            fontSize: 15,
            fontFamily: 'Metropolis',
            color: Colors.black,
          ),)),
          DataCell(Text(product.totalAmount.toString(),style:
          TextStyle(
            fontSize: 15,
            fontFamily: 'Metropolis',
            color: Colors.black,
          ),)),
        ]);
      }).toList(),
    ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Taxable:',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.normal,
              ),

            ),

            Text(
              '${sales!.totalwithoutTax} AED',
              style: TextStyle(
                color: AppColors.black,
                fontSize: 20,
                fontFamily: 'Metropolis',
                fontWeight: FontWeight.bold,
              ),

            ),
          ],),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
          Text(
            'Tax:',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.normal,
            ),

          ),

          Text(
            '${sales!.taxamount} AED',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),

          ),
        ],),
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
            '${sales!.netAmount} AED',
            style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontFamily: 'Metropolis',
              fontWeight: FontWeight.bold,
            ),

          ),
        ],),

      ],
    ),
    );
  }
}
