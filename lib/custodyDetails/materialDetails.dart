import 'package:flutter/material.dart';

import '../config/themes.dart';
import '../models/materialModels.dart';

class MaterialDetails extends StatelessWidget {
  final List<Materials> materials;
  const MaterialDetails({
    Key? key,
    required this.materials,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columnSpacing: 15,
          dataRowHeight: 60,
          dividerThickness: 1, // Vertical lines thickness
          columns: [
            DataColumn(
              label: Text(
                'Ref No',
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
                'Issue',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Metropolis',
                  color: Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Return',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Metropolis',
                  color: Colors.black,
                ),
              ),
            ),
            DataColumn(
              label: Text(
                'Amount',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Metropolis',
                  color: Colors.black,
                ),
              ),
            ),
          ],
          rows: () {
            // Create an empty list to store data rows
            List<DataRow> dataRows = [];

            // Group items by their names
            Map<String, List<Materials>> groupedItems = {};
            materials.forEach((item) {
              if (!groupedItems.containsKey(item.itemName)) {
                groupedItems[item.itemName] = [];
              }
              groupedItems[item.itemName]!.add(item);
            });

            // Iterate through the grouped items
            groupedItems.forEach((itemName, items) {
              // Add a data row for the item name
              dataRows.add(
                DataRow(cells: [
                  DataCell(
                    Text(
                      itemName,
                      style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Metropolis',
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  // Empty cells for the remaining columns
                  DataCell(Container()),
                  DataCell(Container()),
                  DataCell(Container()),
                  DataCell(Container()),
                ]),
              );

              // Add data rows for each item's data
              items.forEach((item) {
                dataRows.add(
                  DataRow(cells: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.docDate.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Metropolis',
                              color: Colors.black,
                            ),
                          ),
                          // Text(
                          //   item.docTime.toString(),
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //     fontFamily: 'Metropolis',
                          //     color: Colors.black,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(
                        item.ownership.toString() == "Custody" ? item.qty.toString() : "0",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Metropolis',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.ownership.toString() == "Deposit" ? item.qty.toString() : "0",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Metropolis',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        item.ownership.toString() == "Deposit" ? item.totalAmount.toString() : "0",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Metropolis',
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ]),
                );
              });
            });

            return dataRows;
          }(),
        ),
      ),
    );
  }



}