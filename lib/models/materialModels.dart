class Materials {
  final int slno;
  final itemId;
  final String itemName;
  final String docNo;
  final String materialIssueDate;
  final String docDate;
  final String ownership;
  final int qty;
  final String unit;
  final double price;
  final double amount;
  final double vat;
  final double totalAmount;
  final String returned;
  final int strxheadId;

  Materials(
      this.slno,
      this.itemId,
      this.itemName,
      this.docNo,
      this.materialIssueDate,
      this.docDate,
      this.ownership,
      this.qty,
      this.unit,
      this.price,
      this.amount,
      this.vat,
      this.totalAmount,
      this.returned,
      this.strxheadId
      );
}

