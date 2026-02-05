import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final networkServiceProvider = Provider<ServiceNetwork>((ref) {
  return ServiceNetwork();
});

final internetStatusProvider = StreamProvider<InternetStatus>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return networkService.onStatusChange;
});

class ServiceNetwork {

  Future<bool> get hasInternet async {
    return await InternetConnection().hasInternetAccess;
  }

  Stream<InternetStatus> get onStatusChange {
    return InternetConnection().onStatusChange;
  }
}