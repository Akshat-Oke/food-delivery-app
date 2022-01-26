import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

// Test Merchant ID
const mid = "AuBWYM25312044824474";
// Test Merchant Key
// 01lps9#PUnnVVH1V
// Website
// WEBSTAGING
// Industry Type
// Retail
// Channel ID (For Website)
// WEB
// Channel ID (For Mobile Apps)
// WAP
Future<bool> startPayment(
    {required int amount,
    required String txnToken,
    required String orderID}) async {
  // txnToken = "acb3f5de433d44d2b19b67375b1d79601642847769383";
  try {
    final response = await AllInOneSdk.startTransaction(
      mid,
      orderID,
      amount.toString(),
      txnToken,
      "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$orderID",
      true,
      false,
    );
    // print("ALLINONESDK_RES was");
    // print(response);
    return true;
  } catch (e) {
    return true;
    // print("ALLINONESDK ERROR");
    // print(e);
  }
}
