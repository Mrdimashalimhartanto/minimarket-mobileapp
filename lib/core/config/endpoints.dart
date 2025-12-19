class Endpoints {
  // AUTH
  static const String login = '/auth/login';
  static const String login2faVerify = '/auth/2fa/verify'; // ✅ FIX
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';

  // PRODUCTS
  static const String products = '/products';

  // POS
  static const String posCheckout = '/pos/checkout';

  // INVENTORY
  static const inventoryStock = '/inventory/stock';
  static const inventoryMovements = '/inventory/movements';
  static const inventoryAdjustments = '/inventory/adjustments';

  // SUPPLIERS / PURCHASES
  static const String suppliers = '/suppliers';

  // PURCHASES
  static const String purchases = '/purchases';
  static const purchaseOrders = '/purchase-orders';
  static String purchaseOrderDetail(int id) => '/purchase-orders/$id';

  static String purchaseOrderCancel(int id) => '/purchase-orders/$id/cancel';
  static String purchaseOrderReceive(int id) => '/purchase-orders/$id/receive';
  static String purchaseOrderMarkOrdered(int id) =>
      '/purchase-orders/$id/mark-ordered';

  // Google
  static const googleLogin = '/auth/google';
}
