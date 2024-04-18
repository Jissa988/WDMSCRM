class Collections {
  final int snno;
  final int typeId;
  final int finYearId;
  final int voucherId;
  final String VoucherNo;
  final String voucherDate;
  final String transDate;
  final String transTime;
  final double totalAmount;
  final String customerName;
  final int receiptMode;
  final String receiptType;
  final bool status;
  final String createdBy;

  Collections(
      this.snno,
      this.typeId,
      this.finYearId,
      this.voucherId,
      this.VoucherNo,
      this.voucherDate,
      this.transDate,
      this.transTime,
      this.totalAmount,
      this.customerName,
      this.receiptMode,
      this.receiptType,
      this.status,
      this.createdBy
      );
}

class CollectionItemDetails {
  final int invoiceId;
  final int stkTrxtypeId;
  final String docNo;
  final String docDt;
  final String dueDt;
  final String refDoc;
  final double billAmount;
  final int balance;
  final double settled;

  CollectionItemDetails(
      this.invoiceId,
      this.stkTrxtypeId,
      this.docNo,
      this.docDt,
      this.dueDt,
      this.refDoc,
      this.billAmount,
      this.balance,
      this.settled,
      );
}

class CollectionHeaderDetails {
  int voucherId;
  String voucherNo;
  String voucherDate;
  String voucherTime;
  int customerId;
  String customerName;
  String routeName;
  String areaName;
  String createdBy;
  double totalAmount;
  CollectionHeaderDetails(
      this.voucherId,
      this.voucherNo,
      this.voucherDate,
      this.voucherTime,
      this.customerId,
      this.customerName,
      this.routeName,
      this.areaName,
      this.createdBy,
      this.totalAmount
      );

}