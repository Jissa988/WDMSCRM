class CustomerAccouts {
  final int customerId;
  final String customerName;

  CustomerAccouts(this.customerId,this.customerName);


}
class HomeEmployeeDetails{
  int? customerId;
  String? customerName;
  String? area;
  String? route;
  String? paymentTerm;
  double? totalOutstanding;
  int? bottleCustody;
  int? tempBottle;
  String? lastSaleDateTime;
  double? totalCustodyAmount;
  int? totalDispenser;
  int? totalOthers;
  int? totalAvailableCouponCount;
  int? remainingPaidCouponCount;
  int? remainingFreeCouponCount;
  int? utilizedPaidCouponCount;
  int? utilizedFreeCouponCount;
  double? thisMonthsaleAmount;
  double? thisMonthCollection;
  double? lastCollectionAmount;
  int notificationCount;
  int finyearId;

  HomeEmployeeDetails(
      this.customerId,
      this.customerName,
      this.area,
      this.route,
      this.paymentTerm,
      this.totalOutstanding,
      this.bottleCustody,
      this.tempBottle,
      this.lastSaleDateTime,
      this.totalCustodyAmount,
      this.totalDispenser,
      this.totalOthers,
      this.totalAvailableCouponCount,
      this.remainingPaidCouponCount,
      this.remainingFreeCouponCount,
      this.utilizedPaidCouponCount,
      this.utilizedFreeCouponCount,
      this.thisMonthsaleAmount,
      this.thisMonthCollection,
      this.lastCollectionAmount,
this.notificationCount,
      this.finyearId,
      );
}

class UnSeenNotification {
  final int notificationId;
  final String notificationType;
  final int customerId;
  final int transactionHeadId;
  final int typeid;
  final String transactionDocNo;
  final double amount;
  final int finYearId;

  UnSeenNotification(this.notificationId,
      this.notificationType,
      this.customerId,
      this.transactionHeadId,
      this.typeid,
      this.transactionDocNo,
      this.amount,
      this.finYearId);


}
