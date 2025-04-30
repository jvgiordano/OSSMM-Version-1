// lib/src/features/bluetooth_off/screens/bluetooth_off_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp; // Use alias

class BluetoothOffScreen extends StatelessWidget {
  final fbp.BluetoothAdapterState? currentState; // Use alias

  const BluetoothOffScreen({super.key, this.currentState});

  String _getStateText(fbp.BluetoothAdapterState? state) { // Use alias
    switch (state) {
      case fbp.BluetoothAdapterState.unknown: return 'Unknown';
      case fbp.BluetoothAdapterState.unavailable: return 'Unavailable';
      case fbp.BluetoothAdapterState.unauthorized: return 'Unauthorized';
      case fbp.BluetoothAdapterState.turningOn: return 'Turning On';
      case fbp.BluetoothAdapterState.on: return 'On';
      case fbp.BluetoothAdapterState.turningOff: return 'Turning Off';
      case fbp.BluetoothAdapterState.off: return 'Off';
      default: return 'Not Available';
    }
  }

  @override
  Widget build(BuildContext context) {
    final stateText = _getStateText(currentState);
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Welcome to OSSMM', style: Theme.of(context).primaryTextTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center,),
              const SizedBox(height: 20),
              const Icon(Icons.bluetooth_disabled, size: 150.0, color: Colors.white54,),
              const SizedBox(height: 20),
              Text('Bluetooth Adapter is $stateText.', style: Theme.of(context).primaryTextTheme.titleMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center,),
              const SizedBox(height: 20),
              // Use aliased type for comparison
              if (currentState == fbp.BluetoothAdapterState.off)
                ElevatedButton(
                  style: ElevatedButton.styleFrom( backgroundColor: Colors.white, foregroundColor: Theme.of(context).primaryColor,),
                  onPressed: () async { // Simplified onPressed
                    try {
                      if (Platform.isAndroid) {
                        await fbp.FlutterBluePlus.turnOn(); // Use alias
                      } else if (Platform.isIOS){
                        // Show prompt for iOS user
                        await showDialog( context: context, builder: (context) => AlertDialog( title: Text("Turn On Bluetooth"), content: Text("Please enable Bluetooth in your device's Control Center or Settings."), actions: [TextButton(onPressed: Navigator.of(context).pop, child: Text("OK"))],));
                      }
                    } catch (e) {
                      print("Error requesting Bluetooth turn on: $e");
                      if(context.mounted) { // Check context before showing snackbar
                        ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Could not request Bluetooth: $e")), );
                      }
                    }
                  },
                  child: const Text('TURN ON BLUETOOTH'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}