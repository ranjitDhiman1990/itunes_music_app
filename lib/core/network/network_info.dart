import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

class NetworkState {
  final bool isConnected;
  final bool isChecking;

  NetworkState(this.isConnected, {this.isChecking = false});

  NetworkState copyWith({bool? isConnected, bool? isChecking}) {
    return NetworkState(
      isConnected ?? this.isConnected,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

class NetworkNotifier extends StateNotifier<NetworkState> {
  NetworkNotifier() : super(NetworkState(true)) {
    _init();
  }

  StreamSubscription? _connectivitySubscription;
  bool _isDisposed = false;

  Future<void> _init() async {
    // Initial check
    await _checkConnection();

    // Listen to connectivity changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((_) => _checkConnection());
  }

  Future<void> _checkConnection() async {
    if (_isDisposed) return;

    state = state.copyWith(isChecking: true);

    try {
      final connectivity = await Connectivity().checkConnectivity();
      final hasInterface =
          connectivity.any((r) => r != ConnectivityResult.none);
      final hasInternet = hasInterface ? await _hasRealInternetAccess() : false;

      if (!_isDisposed && state.isConnected != hasInternet) {
        state = NetworkState(hasInternet);
      }
    } catch (e) {
      if (!_isDisposed) {
        state = NetworkState(false);
      }
    } finally {
      if (!_isDisposed) {
        state = state.copyWith(isChecking: false);
      }
    }
  }

  Future<bool> _hasRealInternetAccess() async {
    try {
      final response = await http
          .get(Uri.parse('http://www.google.com'))
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}

final networkProvider = StateNotifierProvider<NetworkNotifier, NetworkState>(
  (ref) => NetworkNotifier(),
);
