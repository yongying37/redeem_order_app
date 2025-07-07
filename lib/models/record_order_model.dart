  class RecordOrder {
    final int accountUserId;
    final String productId;
    final int productQty;
    final String paymentMode;
    final double paymentAmt;
    final int volunteerPointsRedeemed;
    final String orderDatetime;
    final String orderType;

    RecordOrder({
      required this.accountUserId,
      required this.productId,
      required this.productQty,
      required this.paymentMode,
      required this.paymentAmt,
      required this.volunteerPointsRedeemed,
      required this.orderDatetime,
      required this.orderType,
    });

    Map<String, dynamic> toJson() => {
      'account_user_id': accountUserId,
      'product_id': productId,
      'product_qty': productQty,
      'payment_mode': paymentMode,
      'payment_amt': paymentAmt,
      'volunteer_points_redeemed': volunteerPointsRedeemed,
      'order_datetime': orderDatetime,
      'order_type': orderType,
    };
  }