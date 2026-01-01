import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkChecker {
  static Future<bool> get hasInternet async {
    return await InternetConnection().hasInternetAccess;
  }
}
