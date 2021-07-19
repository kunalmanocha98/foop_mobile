enum COUPON_DISCOUNT_TYPE { Percentage, Amount }

extension COUPON_DISCOUNT_TYPE_EXTENSION on COUPON_DISCOUNT_TYPE {
  String get type {
    switch (this) {
      case COUPON_DISCOUNT_TYPE.Percentage:
        {
          return 'Percentage';
        }
      case COUPON_DISCOUNT_TYPE.Amount:
        {
          return 'Amount';
        }
      default:
        {
          return 'type';
        }
    }
  }
}

enum COUPON_STATUS { Active, Inactive, Expired }

extension COUPON_STATUS_EXTENSION on COUPON_STATUS {
  String get type {
    switch (this) {
      case COUPON_STATUS.Active:
        {
          return 'A';
        }
      case COUPON_STATUS.Inactive:
        {
          return 'I';
        }
      case COUPON_STATUS.Expired:
        {
          return 'E';
        }
      default:
        {
          return 'type';
        }
    }
  }
}
