class Bottles {

  final String refDateTime;
  final String refNo;
  final String bottleType;
  final double qty;
  Bottles(
      this.refDateTime,
      this.refNo,
      this.bottleType,
      this.qty,

      );
}

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
