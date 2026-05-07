/// API Endpoint Strings
class ServerStrings {
  ServerStrings._();

  // Vendor Auth Endpoints
  static const String vendorRegister = '/api/vendor/auth/register';
  static const String vendorLogin = '/api/vendor/auth/login';
  static const String vendorVerifyOtp = '/api/vendor/auth/register/verify-otp';
  static const String vendorForgotPassword = '/api/vendor/auth/forgot-password';
  static const String vendorVerifyForgotPasswordOtp =
      '/api/vendor/auth/verify-forgot-password-otp';
  static const String vendorResetPassword = '/api/vendor/auth/reset-password';
  static const String vendorProfile = '/api/profile/vendor/';
  static const String vendorAddItem = '/api/vendor/items';

  // Items Endpoints
  static const String getItems = '/api/items';
  static String publishItem(int itemId) => '/api/vendor/items/$itemId/publish';
  static String pauseItem(int itemId) => '/api/vendor/items/$itemId/pause';
  static String updateItem(int itemId) => '/api/vendor/items/$itemId';
  static String deleteItem(int itemId) => '/api/vendor/items/$itemId';

  // Orders Endpoints
  static const String getVendorOrders = '/api/vendor/orders';
  static String startCooking(int orderId) =>
      '/api/vendor/orders/$orderId/start-cooking';
  static String readyForPickup(int orderId) =>
      '/api/vendor/orders/$orderId/ready-for-pickup';
  static String confirmHandover(int orderId) =>
      '/api/vendor/orders/$orderId/confirm-handover';

  // General Endpoints
  static const String generalCountries = '/api/general/countries';
  static const String generalCities = '/api/general/cities';
  static const String generalAreas = '/api/general/areas';
  static const String generalCategories = '/api/general/categories';

  // Sub-Categories (Vendor-owned per restaurant)
  static const String vendorSubCategories = '/api/vendor/subcategories';
  static String updateSubCategory(int id) => '/api/vendor/subcategories/$id';
  static String deleteSubCategory(int id) => '/api/vendor/subcategories/$id';

  // Vendor Addresses (Multi-Branch)
  static const String vendorAddresses = '/api/vendor/addresses';
  static String updateAddress(int id) => '/api/vendor/addresses/$id';
  static String deleteAddress(int id) => '/api/vendor/addresses/$id';
}
