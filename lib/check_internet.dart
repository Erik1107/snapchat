import 'package:connectivity/connectivity.dart';

class CheckInternet {
  Future<bool> checkIntenet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) return true;
    return false;
  }
}
