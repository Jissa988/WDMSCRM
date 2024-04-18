class SalesInvoice {
  final int pageNo;
  final int heaaId;
  final String strxType;
  final String invoiceNo;
  final String invoiceDate;
  final String dct;
  final String invoiceTime;
  final int customerId;
  final String customerName;
  final paymentTermId;
  final String paymentTerm;
  final double netAmount;
  final double settled;
  final String paymentStatus;
  final bool creditFlag;
  final String activeStatus;
  final String createdby;
  final double taxableAmount;
  final double taxamount;
  final int receiptId;
  final String paymentMode;

  SalesInvoice(
      this.pageNo,
      this.heaaId,
      this.strxType,
      this.invoiceNo,
      this.invoiceDate,
      this.dct,
      this.invoiceTime,
      this.customerId,
      this.customerName,
      this.paymentTermId,
      this.paymentTerm,
      this.netAmount,
      this.settled,
      this.paymentStatus,
      this.creditFlag,
      this.activeStatus,
      this.createdby,
      this.taxableAmount,
      this.taxamount,
      this.receiptId,
      this.paymentMode,

      );
}

class SalesHeadItems {
  final int invoiceId;
  final String invoiceNo;
  final String invoiceDate;
  final String invoiceTime;
  final String customerName;
  final int customerId;
  // final String paymentTerm;
  final String routeName;
  final String area;
  final double totalwithoutTax;
  final double taxamount;
  final double netAmount;
  final String createdBy;

  SalesHeadItems(
      this.invoiceId,
      this.invoiceNo,
      this.invoiceDate,
      this.invoiceTime,
      this.customerName,
      this.customerId,
      this.routeName,
      this.area,
      this.totalwithoutTax,
      this.taxamount,
      this.netAmount,
      this.createdBy
      );
}
class SalesItem {
  final int stockIssueId;
  final int rowNum;
  final int itemId;
  final int unitId;
  final String itemCode;
  final String itemName;
  final String unit;
  final double consumptionQty;
  final double tempQty;
  final double quantity;
  final double unitPrice;
  final double value;
  final double focQty;
  final int discountType;
  final String discType;
  final double discountPercent;
  final double discountAmount;
  final int taxId;
  final double taxableAmount;
  final double taxPercent;
  final double taxAmount;
  final double totalAmount;
  final bool activeStatus;

  SalesItem(
      this.stockIssueId,
      this.rowNum,
      this.itemId,
      this.unitId,
      this.itemCode,
      this.itemName,
      this.unit,
      this.consumptionQty,
      this.tempQty,
      this.quantity,
      this.unitPrice,
      this.value,
      this.focQty,
      this.discountType,
      this.discType,
      this.discountPercent,
      this.discountAmount,
      this.taxId,
      this.taxableAmount,
      this.taxPercent,
      this.taxAmount,
      this.totalAmount,
      this.activeStatus
      );
}
class InvoiceCount{
final int paidCount;
final int upaidCount;
final int patialCount;

InvoiceCount(
this.paidCount,
    this.upaidCount,
    this.patialCount,
);
}