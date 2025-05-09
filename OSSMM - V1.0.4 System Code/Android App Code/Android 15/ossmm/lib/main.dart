// lib/main.dart

/*
  ******************************************************************************
    Notes:
    Program: OSSMM App for Android 15+
    By: Jonny Giordano

    Compared with the OSSMM version this:
    * Implements bonding/pairing with OSSMM headband
    * Encrypted CSV files after data recording
    * Various Connection Settings
      * Auto-Reconnect to Bonded Device
      * Auto-Record upon pairing to Bonded Device
      * Keep unecrypted CSV files
    * Collapsible sections with all items under one "Dashboard" main page
    *
  ******************************************************************************

 */


import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp; // Use alias
import 'package:provider/provider.dart';
import 'package:ossmm/src/core/services/bluetooth_service.dart';
import 'package:ossmm/src/features/bluetooth_off/screens/bluetooth_off_screen.dart';
import 'package:ossmm/src/features/home/screens/home_screen.dart';

// Add this line for global navigation context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  fbp.FlutterBluePlus.setLogLevel(fbp.LogLevel.info, color: true);

  runApp(
    ChangeNotifierProvider(
      create: (context) => OssmmBluetoothService(),
      child: const OssmmApp(),
    ),
  );
}

class OssmmApp extends StatelessWidget {
  const OssmmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Add navigator key for global context access
      navigatorKey: navigatorKey,
      title: 'OSSMM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Consumer<OssmmBluetoothService>(
        builder: (context, bluetoothService, child) {
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