// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp; // Use alias
import 'package:provider/provider.dart';
import 'package:ossmm/src/core/services/bluetooth_service.dart'; // Ensure this path is correct
import 'package:ossmm/src/features/bluetooth_off/screens/bluetooth_off_screen.dart';
import 'package:ossmm/src/features/home/screens/home_screen.dart';

void main() {
  fbp.FlutterBluePlus.setLogLevel(fbp.LogLevel.info, color: true); // Use alias

  runApp(
    ChangeNotifierProvider(
      create: (context) => OssmmBluetoothService(), // Use correct constructor
      child: const OssmmApp(),
    ),
  );
}

class OssmmApp extends StatelessWidget {
  const OssmmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OSSMM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Consumer<OssmmBluetoothService>( // Use renamed service
        builder: (context, bluetoothService, child) {
          // Use aliased type for comparison
          if (bluetoothService.adapterState != fbp.BluetoothAdapterState.on) {
            return BluetoothOffScreen(currentState: bluetoothService.adapterState);
          } else {
            return const HomeScreen();
          }
        },
      ),
    );
  }
}