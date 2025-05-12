// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:provider/provider.dart';
import 'package:ossmm/src/core/services/bluetooth_service.dart';
import 'package:ossmm/src/core/services/location_service.dart';
import 'package:ossmm/src/features/system_requirements/screens/system_requirements_screen.dart';
import 'package:ossmm/src/features/home/screens/home_screen.dart';

// Add this line for global navigation context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  fbp.FlutterBluePlus.setLogLevel(fbp.LogLevel.info, color: true);

  runApp(
    // Use MultiProvider to provide both services
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => OssmmBluetoothService()),
        ChangeNotifierProvider(create: (context) => LocationService()),
      ],
      child: const OssmmApp(),
    ),
  );
}

class OssmmApp extends StatefulWidget {
  const OssmmApp({super.key});

  @override
  State<OssmmApp> createState() => _OssmmAppState();
}

class _OssmmAppState extends State<OssmmApp> with WidgetsBindingObserver {
  late LocationService _locationService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Store reference to location service
    _locationService = Provider.of<LocationService>(context, listen: false);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // When app comes to foreground, force check location status
    if (state == AppLifecycleState.resumed) {
      _locationService.forceCheck();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'OSSMM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SystemRequirementsChecker(),
    );
  }
}

// Separate widget to handle navigation logic
class SystemRequirementsChecker extends StatelessWidget {
  const SystemRequirementsChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<OssmmBluetoothService, LocationService>(
      builder: (context, bluetoothService, locationService, child) {
        // Check if both requirements are met
        bool bluetoothEnabled = bluetoothService.adapterState == fbp.BluetoothAdapterState.on;
        bool locationEnabled = locationService.isLocationEnabled;

        print("System check - Bluetooth: $bluetoothEnabled, Location: $locationEnabled");

        // Only navigate to HomeScreen if BOTH are enabled
        if (bluetoothEnabled && locationEnabled) {
          return const HomeScreen();
        } else {
          // Show system requirements screen if either is disabled
          return const SystemRequirementsScreen();
        }
      },
    );
  }
}