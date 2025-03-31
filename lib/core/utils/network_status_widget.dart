import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itunes_music_app/core/network/network_info.dart';

class NetworkStatusWidget extends ConsumerWidget {
  const NetworkStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected =
        ref.watch(networkProvider.select((state) => state.isConnected));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: isConnected ? 0 : 40,
      color: Colors.red,
      child: const Center(
        child: Text(
          'No Internet Connection',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
