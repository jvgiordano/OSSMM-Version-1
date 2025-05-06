// lib/src/core/utils/app_lifecycle_observer.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ossmm/src/core/services/bluetooth_service.dart';

/// AppLifecycleObserver is a class that observes app lifecycle changes
/// and notifies the Bluetooth service when the app enters or exits the foreground.
class AppLifecycleObserver extends WidgetsBindingObserver {
  final BuildContext context;
  bool _wasInForeground = true;

  AppLifecycleObserver(this.context) {
    WidgetsBinding.instance.addObserver(this);

    // Initialize with current state
    final bluetoothService = Provider.of<OssmmBluetoothService>(context, listen: false);
    bluetoothService.setAppLifecycleState(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final bluetoothService = Provider.of<OssmmBluetoothService>(context, listen: false);

    switch (state) {
      case AppLifecycleState.resumed:
      // App in foreground
        if (!_wasInForeground) {
          print('App resumed - now in foreground');
          bluetoothService.setAppLifecycleState(true);
          _wasInForeground = true;
        }
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      // App in background or being closed
        if (_wasInForeground) {
          print('App paused/inactive/detached - now in background');
          bluetoothService.setAppLifecycleState(false);
          _wasInForeground = false;
        }
        break;
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}