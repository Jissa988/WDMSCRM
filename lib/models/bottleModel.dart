class Bottles {

  final int slno;
  final String itemName;
  final String docNo;
  final String docDate;
  final String bottleType;
  final String trxType;
  final double amount;

  final double qty;
  final String createdOn;

  Bottles(
      this.slno,
      this.itemName,
      this.docNo,
      this.docDate,
      this.bottleType,
      this.trxType,
      this.amount,
      this.qty,
      this.createdOn
      );}

class BottlesCounts {

  final int bottleCustody;
  final int tempBottleInHand;
  final int bottleInHand;
  BottlesCounts(
      this.bottleCustody,
      this.tempBottleInHand,
      this.bottleInHand,

      );
}
