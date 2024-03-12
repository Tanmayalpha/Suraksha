



import 'apiConstants.dart';

final Uri getSendOtp = Uri.parse('${baseUrl}getOtp');
final Uri addTransactionApi  = Uri.parse('${baseUrl}addTransaction');
final Uri getTransactionApi  = Uri.parse('${baseUrl}getTransactions');
final Uri getWidrawalRequestApi  = Uri.parse('${baseUrl}addWithdrawalRequest');
final Uri getNotificationsApi  = Uri.parse('${baseUrl}getNotifications');
final Uri getLogIn = Uri.parse('${baseUrl}signin');
final Uri getVerifyOtp = Uri.parse('${baseUrl}verifyOtp');
final Uri getSignUpApi = Uri.parse('${baseUrl}user');
final Uri getSignSendOtp = Uri.parse('${baseUrl}signup/sendotp');
final Uri getSignVerifyOtp = Uri.parse('${baseUrl}signup/verifyotp');
final Uri getCountry = Uri.parse('${baseUrl}get_countries');
final Uri applyPromoApi= Uri.parse('${baseUrl}applyPromo');
final Uri createPaymentSessionApi= Uri.parse('${baseUrl}createOrderSession');
final Uri getPlanCostApi = Uri.parse('${baseUrl}plan-details');
final Uri getProductListAPI = Uri.parse('${baseUrl}get_product_list');
final Uri getAddProductApi = Uri.parse('${baseUrl}product_purchase');
final Uri getSupplierOrClientApi = Uri.parse('${baseUrl}supplier');
final Uri contactSupplierOrClientApi = Uri.parse('${baseUrl}save_inquiry');
final Uri getProductsApi = Uri.parse('${baseUrl}get_home_products');

const String MethodType = 'GET';