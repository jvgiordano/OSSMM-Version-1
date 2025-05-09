// lib/src/core/services/bluetooth_service.dart

import 'dart:async';

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

import 'package:permission_handler/permission_handler.dart';

import 'package:ossmm/src/core/models/data_sample.dart';

import 'package:ossmm/src/core/utils/csv_writer.dart';

import 'package:ossmm/src/features/home/screens/home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

// Merged BleConstants

class _BleConstants {
  _BleConstants._();

  static final fbp.Guid serviceUuid = fbp.Guid(
    "5aee1a8a-08de-11ed-861d-0242ac120002",
  );

  static final fbp.Guid characteristicUuidData = fbp.Guid(
    "405992d6-0cf2-11ed-861d-0242ac120002",
  );

  static final fbp.Guid characteristicUuidMod = fbp.Guid(
    "018ec2b5-7c82-7773-95e2-a5f374275f0b",
  );

  static const String deviceDirectory = "OSSMM";

  // Add constants for bond status storage

  static const String bondedDevicesKey = "ossmm_bonded_devices";

  // Add constant for CSV deletion preference

  static const String deleteUnencryptedCsvKey = "ossmm_delete_unencrypted_csv";
}

enum DeviceConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

enum DeviceBondState { none, bonding, bonded }

class OssmmBluetoothService with ChangeNotifier {
  // --- State Variables ---

  fbp.BluetoothAdapterState _adapterState = fbp.BluetoothAdapterState.unknown;

  StreamSubscription<fbp.BluetoothAdapterState>? _adapterStateSubscription;

  List<fbp.ScanResult> _scanResults = [];

  StreamSubscription<List<fbp.ScanResult>>? _scanResultsSubscription;

  bool _isScanning = false;

  fbp.BluetoothDevice? _selectedDevice;

  StreamSubscription<fbp.BluetoothConnectionState>?
  _connectionStateSubscription;

  DeviceConnectionState _connectionState = DeviceConnectionState.disconnected;

  bool _isConnecting = false;

  fbp.BluetoothCharacteristic? _dataCharacteristic;

  fbp.BluetoothCharacteristic? _modCharacteristic;

  StreamSubscription<List<int>>? _dataSubscription;

  final CsvWriterUtil _csvWriter = CsvWriterUtil();

  List<DataSample> _currentSamples = [];

  bool _isRecording = false;

  static const int _maxLiveSamples = 7500;

  // --- Bonding State Variables ---

  DeviceBondState _bondState = DeviceBondState.none;

  StreamSubscription? _bondStateSubscription;

  Set<String> _bondedDevices = {};

  bool _autoReconnectToBonded = false;  // Turn off _autoReconnectToBonded for default

  // --- CSV Handling Settings ---

  bool _deleteUnencryptedCsv =
      true; // Default to true (delete CSV after zipping)

  // --- Auto-reconnection variables ---

  bool _isAttemptingAutoReconnect = false;

  int _reconnectAttemptCount = 0;

  Timer? _reconnectTimer;

  bool _appInForeground = true;

  // --- Constants based on OBSERVED packet size ---

  static const int _samplesPerPacket = 10;

  static const int _bytesPerSample = 18;

  static const int _expectedPacketSize = _samplesPerPacket * _bytesPerSample;

  // --- Public Getters ---

  fbp.BluetoothAdapterState get adapterState => _adapterState;

  List<fbp.ScanResult> get scanResults => _scanResults;

  bool get isScanning => _isScanning;

  fbp.BluetoothDevice? get selectedDevice => _selectedDevice;

  String get selectedDeviceName =>
      _selectedDevice?.platformName.isNotEmpty ?? false
          ? _selectedDevice!.platformName
          : (_selectedDevice?.remoteId.toString() ?? "None");

  DeviceConnectionState get connectionState => _connectionState;

  bool get isConnected => _connectionState == DeviceConnectionState.connected;

  bool get isConnecting => _isConnecting;

  bool get isRecording => _isRecording;

  String? get csvFilePath => _csvWriter.currentFilePath;

  List<DataSample> get currentRawSamples => List.unmodifiable(_currentSamples);

  // --- Bond State Getters ---

  DeviceBondState get bondState => _bondState;

  bool get isBonded => _bondState == DeviceBondState.bonded;

  bool get isBonding => _bondState == DeviceBondState.bonding;

  Set<String> get bondedDevices => Set.unmodifiable(_bondedDevices);

  bool get autoReconnectToBonded => _autoReconnectToBonded;

  bool get isAttemptingAutoReconnect => _isAttemptingAutoReconnect;

  int get reconnectAttemptCount => _reconnectAttemptCount;

  // --- CSV Settings Getter ---

  bool get deleteUnencryptedCsv => _deleteUnencryptedCsv;

  // --- Initialization & Disposal ---

  OssmmBluetoothService() {
    _initialize();

    _loadBondedDevices();

    _loadCsvPreferences();
  }

  void _initialize() {
    _adapterStateSubscription?.cancel();

    _adapterStateSubscription = fbp.FlutterBluePlus.adapterState.listen((
      state,
    ) {
      final bool wasOff = _adapterState != fbp.BluetoothAdapterState.on;

      _adapterState = state;

      if (state != fbp.BluetoothAdapterState.on) {
        _handleBluetoothOff();
      } else if (wasOff && state == fbp.BluetoothAdapterState.on) {
        // Bluetooth just turned on

        print(
          "Bluetooth turned ON. Checking for auto-reconnection eligibility...",
        );

        // Delay to allow adapter to fully initialize

        Future.delayed(const Duration(milliseconds: 1000), () {
          if (_autoReconnectToBonded &&
              _bondedDevices.isNotEmpty &&
              _connectionState == DeviceConnectionState.disconnected &&
              !_isConnecting &&
              !_isAttemptingAutoReconnect) {
            print("Auto-reconnection criteria met. Attempting reconnection.");

            _scheduleReconnectionAttempt(immediate: true);
          }
        });
      }

      print("Adapter State Updated: $state");

      notifyListeners();
    }, onError: (e) => print("Error listening to adapter state: $e"));
  }

  @override
  void dispose() {
    print("Disposing OssmmBluetoothService");

    _adapterStateSubscription?.cancel();

    _scanResultsSubscription?.cancel();

    _connectionStateSubscription?.cancel();

    _dataSubscription?.cancel();

    _bondStateSubscription?.cancel();

    _reconnectTimer?.cancel();

    _csvWriter.close(deleteUnencryptedCsv: _deleteUnencryptedCsv);

    final device = _selectedDevice;

    if (device != null && device.isConnected == true) {
      device.disconnect().catchError((e) {
        print("Error during dispose disconnect: $e");
      });
    }

    super.dispose();
  }

  void _handleBluetoothOff() {
    print("Handling Bluetooth Off event");

    _cancelReconnectionAttempts();

    if (_isScanning) {
      _stopScanInternal();
    }

    _scanResults = [];

    if (_connectionState != DeviceConnectionState.disconnected) {
      _handleDisconnect(showError: false);
    }

    _connectionState = DeviceConnectionState.disconnected;

    _isConnecting = false;

    _isRecording = false;

    _bondState = DeviceBondState.none;

    _bondStateSubscription?.cancel();

    _bondStateSubscription = null;

    _dataSubscription?.cancel();

    _dataSubscription = null;

    _connectionStateSubscription?.cancel();

    _connectionStateSubscription = null;

    _csvWriter.close(deleteUnencryptedCsv: _deleteUnencryptedCsv);

    _selectedDevice = null;

    _dataCharacteristic = null;

    _modCharacteristic = null;

    _currentSamples = [];

    notifyListeners();
  }

  // --- Load/Save CSV Preferences ---

  Future<void> _loadCsvPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _deleteUnencryptedCsv =
          prefs.getBool(_BleConstants.deleteUnencryptedCsvKey) ?? true;

      print("Loaded CSV deletion preference: $_deleteUnencryptedCsv");
    } catch (e) {
      print("Error loading CSV preferences: $e");

      _deleteUnencryptedCsv = true; // Default to true on error
    }
  }

  Future<void> _saveCsvPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool(
        _BleConstants.deleteUnencryptedCsvKey,
        _deleteUnencryptedCsv,
      );

      print("Saved CSV deletion preference: $_deleteUnencryptedCsv");
    } catch (e) {
      print("Error saving CSV preferences: $e");
    }
  }

  // Set CSV deletion preference

  void setDeleteUnencryptedCsv(bool value) {
    if (_deleteUnencryptedCsv == value) return;

    _deleteUnencryptedCsv = value;

    _saveCsvPreferences();

    notifyListeners();
  }

  // --- App Lifecycle Management ---

  void setAppLifecycleState(bool isInForeground) {
    _appInForeground = isInForeground;

    if (isInForeground &&
        _autoReconnectToBonded &&
        _bondedDevices.isNotEmpty &&
        _connectionState == DeviceConnectionState.disconnected &&
        !_isConnecting &&
        !_isAttemptingAutoReconnect) {
      print("App returned to foreground. Checking for bonded devices...");

      _scheduleReconnectionAttempt(immediate: false);
    } else if (!isInForeground) {
      // App going to background, cancel any pending reconnection attempts

      _cancelReconnectionAttempts();
    }
  }

  // --- Bonding Functions ---

  // Load bonded devices from persistent storage

  Future<void> _loadBondedDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final bondedDevicesList =
          prefs.getStringList(_BleConstants.bondedDevicesKey) ?? [];

      _bondedDevices = bondedDevicesList.toSet();

      print("Loaded ${_bondedDevices.length} bonded devices from storage");

      // Check if we should auto-connect to any of these devices

      if (_autoReconnectToBonded &&
          _bondedDevices.isNotEmpty &&
          _adapterState == fbp.BluetoothAdapterState.on &&
          _connectionState == DeviceConnectionState.disconnected) {
        // Delay to ensure the app is fully initialized

        Future.delayed(const Duration(seconds: 2), () {
          _scheduleReconnectionAttempt(immediate: true);
        });
      }
    } catch (e) {
      print("Error loading bonded devices: $e");

      _bondedDevices = {};
    }
  }

  // Save bonded devices to persistent storage

  Future<void> _saveBondedDevices() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setStringList(
        _BleConstants.bondedDevicesKey,
        _bondedDevices.toList(),
      );

      print("Saved ${_bondedDevices.length} bonded devices to storage");
    } catch (e) {
      print("Error saving bonded devices: $e");
    }
  }

  // Add a device to the bonded devices list

  Future<void> _addBondedDevice(String deviceId) async {
    if (!_bondedDevices.contains(deviceId)) {
      _bondedDevices.add(deviceId);

      await _saveBondedDevices();

      notifyListeners();
    }
  }

  // Remove a device from the bonded devices list

  Future<void> _removeBondedDevice(String deviceId) async {
    if (_bondedDevices.contains(deviceId)) {
      _bondedDevices.remove(deviceId);

      await _saveBondedDevices();

      notifyListeners();
    }
  }

  // Clear all bonded devices

  Future<void> clearAllBondedDevices() async {
    _bondedDevices.clear();

    await _saveBondedDevices();

    notifyListeners();
  }

  // Set auto-reconnect preference

  void setAutoReconnectToBonded(bool value) {
    if (_autoReconnectToBonded == value) return;

    _autoReconnectToBonded = value;

    if (value &&
        _bondedDevices.isNotEmpty &&
        _adapterState == fbp.BluetoothAdapterState.on &&
        _connectionState == DeviceConnectionState.disconnected &&
        !_isConnecting &&
        !_isAttemptingAutoReconnect) {
      print("Auto-reconnect turned ON. Scheduling reconnection attempt.");

      _scheduleReconnectionAttempt(immediate: false);
    } else if (!value) {
      // Cancel any pending reconnect attempts

      _cancelReconnectionAttempts();
    }

    notifyListeners();
  }

  // --- Enhanced Auto-Reconnection Logic ---

  void _scheduleReconnectionAttempt({required bool immediate}) {
    // Cancel any existing timer

    _cancelReconnectionAttempts();

    if (immediate) {
      _tryReconnectToBondedDevice();
    } else {
      // Schedule a reconnection attempt after a short delay

      _reconnectTimer = Timer(const Duration(seconds: 2), () {
        _tryReconnectToBondedDevice();
      });
    }
  }

  // Make this method public so it can be called from outside the class

  void cancelReconnectionAttempts() {
    _cancelReconnectionAttempts();
  }

  void _cancelReconnectionAttempts() {
    _reconnectTimer?.cancel();

    _reconnectTimer = null;

    if (_isAttemptingAutoReconnect) {
      _isAttemptingAutoReconnect = false;

      _reconnectAttemptCount = 0;

      // If we're in the middle of scanning, stop it

      if (_isScanning && fbp.FlutterBluePlus.isScanningNow) {
        fbp.FlutterBluePlus.stopScan().catchError((e) {
          print("Error stopping scan during reconnection cancellation: $e");
        });
      }

      notifyListeners();
    }
  }

  // Public method to manually trigger reconnection

  Future<bool> triggerBondedDeviceReconnection({
    bool isManualAttempt = true,
  }) async {
    if (_bondedDevices.isEmpty ||
        _isConnecting ||
        _connectionState != DeviceConnectionState.disconnected) {
      return false;
    }

    // If there's already an auto-reconnect in progress, cancel it first

    if (_isAttemptingAutoReconnect) {
      _cancelReconnectionAttempts();
    }

    return await _tryReconnectToBondedDevice(isManualAttempt: isManualAttempt);
  }

  // Enhanced reconnection logic with multiple attempts and better error handling

  Future<bool> _tryReconnectToBondedDevice({
    bool isManualAttempt = false,
  }) async {
    if (_bondedDevices.isEmpty ||
        _isConnecting ||
        _connectionState != DeviceConnectionState.disconnected ||
        _adapterState != fbp.BluetoothAdapterState.on) {
      return false;
    }

    // Reset counters and set state

    _isAttemptingAutoReconnect = true;

    _reconnectAttemptCount = 0;

    notifyListeners();

    print(
      "Starting reconnection process to bonded device" +
          (isManualAttempt ? " (manual attempt)" : ""),
    );

    bool reconnectSuccess = false;

    const int maxAttempts = 3;

    try {
      // Request BLE permissions

      bool permissionsGranted = await _requestBlePermissions();

      if (!permissionsGranted) {
        print("Cannot reconnect: BLE permissions not granted");

        _isAttemptingAutoReconnect = false;

        notifyListeners();

        return false;
      }

      // Multiple reconnection attempts with exponential backoff

      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        if (_connectionState == DeviceConnectionState.connected) {
          reconnectSuccess = true;

          break;
        }

        if (!_isAttemptingAutoReconnect) {
          print("Reconnection process was cancelled.");

          break;
        }

        // For auto-reconnect: only continue if auto-reconnect is enabled

        // For manual reconnect: continue regardless of auto-reconnect setting

        if (!isManualAttempt && !_autoReconnectToBonded) {
          print(
            "Auto-reconnect disabled. Stopping automatic reconnection attempts.",
          );

          break;
        }

        if (!_appInForeground) {
          print("App in background. Stopping reconnection attempts.");

          break;
        }

        _reconnectAttemptCount = attempt;

        notifyListeners();

        print("Reconnection attempt $attempt of $maxAttempts");

        // Increasing scan duration for each attempt

        int scanDuration = 5 + (attempt * 2); // 7, 9, 11 seconds

        print("Scanning for $scanDuration seconds...");

        try {
          // Start BLE scan

          await _stopScanInternal(); // Ensure no existing scan is running

          _isScanning = true;

          _scanResults = [];

          notifyListeners();

          // Start scan with timeout

          await fbp.FlutterBluePlus.startScan(
            timeout: Duration(seconds: scanDuration),

            androidUsesFineLocation: true,
          );

          bool deviceFound = false;

          fbp.BluetoothDevice? targetDevice;

          // Subscribe to scan results and look for our bonded device

          await for (final results in fbp.FlutterBluePlus.scanResults) {
            if (!_isAttemptingAutoReconnect) {
              print("Reconnection process cancelled.");

              break;
            }

            for (final result in results) {
              final device = result.device;

              if (_bondedDevices.contains(device.remoteId.toString())) {
                print(
                  "Found bonded device: ${device.platformName} (${device.remoteId})",
                );

                deviceFound = true;

                targetDevice = device;

                break;
              }
            }

            if (deviceFound) break;
          }

          // Stop scanning

          await _stopScanInternal();

          // If device found, attempt to connect

          if (deviceFound && targetDevice != null) {
            print(
              "Attempting to connect to bonded device: ${targetDevice.platformName}",
            );

            bool connected = await connectToDevice(targetDevice);

            if (connected) {
              print("Successfully reconnected to bonded device!");

              reconnectSuccess = true;

              break;
            } else {
              print("Failed to connect to bonded device on attempt $attempt");
            }
          } else {
            print("Bonded device not found in scan attempt $attempt");
          }
        } catch (e) {
          print("Error during reconnection scan attempt $attempt: $e");

          await _stopScanInternal();
        }

        // If this wasn't the last attempt, wait before trying again

        if (attempt < maxAttempts) {
          // Exponential backoff

          int delaySeconds = 2 * attempt; // 2, 4, 6 seconds

          print(
            "Waiting $delaySeconds seconds before next reconnection attempt...",
          );

          bool shouldContinue = await Future.delayed(
            Duration(seconds: delaySeconds),
            () {
              return (isManualAttempt || _autoReconnectToBonded) &&
                  _appInForeground &&
                  _isAttemptingAutoReconnect &&
                  _connectionState == DeviceConnectionState.disconnected;
            },
          );

          if (!shouldContinue) {
            print("Reconnection process interrupted during delay.");

            break;
          }
        }
      }
    } catch (e) {
      print("Error in reconnection process: $e");
    } finally {
      // Clean up

      _isAttemptingAutoReconnect = false;

      _reconnectAttemptCount = 0;

      notifyListeners();
    }

    return reconnectSuccess;
  }

  // --- Pairing Handling ---

  Future<void> _setupBondStateListener(fbp.BluetoothDevice device) async {
    _bondStateSubscription?.cancel();

    _bondStateSubscription = null;

    if (Platform.isAndroid) {
      try {
        // Check if device already appears to be bonded

        if (_bondedDevices.contains(device.remoteId.toString())) {
          _bondState = DeviceBondState.bonded;

          notifyListeners();
        } else {
          _bondState = DeviceBondState.none;

          notifyListeners();
        }

        // Instead of listening to bond state changes (which seems to cause type issues),

        // we'll infer bond state from connection events and our stored list

        print(
          "Bond state monitoring set up (using connection status and stored list)",
        );
      } catch (e) {
        print("Error setting up bond state monitoring: $e");

        _bondState = DeviceBondState.none;

        notifyListeners();
      }
    } else {
      // For iOS, bond state is managed differently

      // Assume a successful connection means bonded for iOS

      _bondState = DeviceBondState.bonded;

      if (_selectedDevice != null) {
        await _addBondedDevice(_selectedDevice!.remoteId.toString());
      }

      notifyListeners();
    }
  }

  // Explicitly request bonding (normally triggered automatically during secure connection)

  Future<bool> createBond() async {
    if (_selectedDevice == null || !isConnected) {
      print("Cannot create bond: No device connected");

      return false;
    }

    if (_bondState == DeviceBondState.bonded) {
      print("Device is already bonded");

      return true;
    }

    try {
      print("Initiating bond with ${_selectedDevice!.platformName}");

      _bondState = DeviceBondState.bonding;

      notifyListeners();

      if (Platform.isAndroid) {
        // Call createBond but don't try to capture a return value

        // Instead, we'll assume success if no exception is thrown

        try {
          // The method returns void, so don't try to assign it

          await _selectedDevice!.createBond();

          // If we get here without an exception, consider it successful

          print("Bond creation completed without exceptions");

          _bondState = DeviceBondState.bonded;

          notifyListeners();

          // Store the device in our bonded list

          if (_selectedDevice != null) {
            await _addBondedDevice(_selectedDevice!.remoteId.toString());
          }

          return true;
        } catch (e) {
          print("Error in createBond method: $e");

          _bondState = DeviceBondState.none;

          notifyListeners();

          return false;
        }
      } else {
        // iOS handles bonding internally during secure connections

        // Just mark as bonded for iOS

        _bondState = DeviceBondState.bonded;

        notifyListeners();

        await _addBondedDevice(_selectedDevice!.remoteId.toString());

        return true;
      }
    } catch (e) {
      print("Error creating bond: $e");

      _bondState = DeviceBondState.none;

      notifyListeners();

      return false;
    }
  }

  // Remove bond with the current device

  Future<bool> removeBond() async {
    if (_selectedDevice == null) {
      print("Cannot remove bond: No device selected");

      return false;
    }

    try {
      final deviceId = _selectedDevice!.remoteId.toString();

      if (Platform.isAndroid) {
        print("Removing bond with $deviceId");

        try {
          // Call removeBond but don't try to capture a return value

          await _selectedDevice!.removeBond();

          // If we get here without exception, consider it successful

          await _removeBondedDevice(deviceId);

          _bondState = DeviceBondState.none;

          notifyListeners();

          return true;
        } catch (e) {
          print("Error in removeBond method: $e");

          return false;
        }
      } else {
        // iOS doesn't have direct bond removal, but we can remove from our storage

        await _removeBondedDevice(deviceId);

        _bondState = DeviceBondState.none;

        notifyListeners();

        return true;
      }
    } catch (e) {
      print("Error removing bond: $e");

      return false;
    }
  }

  // --- Permissions ---

  Future<bool> _requestBlePermissions() async {
    print("Requesting Bluetooth Scan/Connect/Location Permissions...");

    Map<Permission, PermissionStatus> statuses = {};

    if (Platform.isAndroid) {
      statuses =
          await [
            Permission.bluetoothScan,

            Permission.bluetoothConnect,

            Permission.locationWhenInUse,
          ].request();

      statuses.forEach((p, s) => print('$p : $s'));

      final bool scanGranted =
          statuses[Permission.bluetoothScan]?.isGranted ?? false;

      final bool connectGranted =
          statuses[Permission.bluetoothConnect]?.isGranted ?? false;

      final bool locationGranted =
          statuses[Permission.locationWhenInUse]?.isGranted ?? false;

      if (!locationGranted) {
        print(
          'Warning: Location permission not granted. BLE scanning might be unreliable.',
        );
      }

      bool allBtGranted = scanGranted && connectGranted;

      if (!allBtGranted) {
        print('Required Bluetooth permissions (Scan & Connect) not granted.');
        return false;
      }

      return true;
    } else if (Platform.isIOS) {
      print("iOS Permissions should be configured in Info.plist");
      return true;
    }

    print("Unsupported platform for BLE permissions or check failed.");

    return false;
  }

  // _requestStoragePermissions() is now deprecated for OSSMM
  /*
  Future<bool> _requestStoragePermissions() async {
    print("Requesting Storage Permissions...");
    if (Platform.isAndroid) {
      // Request only the storage permission, not photos
      PermissionStatus status = await Permission.storage.request();
      print('Storage Permission status: $status');
      return status.isGranted;
    }
    return true;
  }
  */

  // --- Scanning Logic ---

  Future<void> startScan() async {
    if (_isScanning) {
      print("Scan already in progress.");
      return;
    }

    if (_adapterState != fbp.BluetoothAdapterState.on) {
      print("Cannot scan, Bluetooth is off.");
      return;
    }

    bool blePermissionsGranted = await _requestBlePermissions();

    if (!blePermissionsGranted) {
      print("BLE permissions not granted, cannot start scan.");
      return;
    }

    _isScanning = true;
    _scanResults = [];
    notifyListeners();
    print("Starting BLE scan...");

    try {
      await fbp.FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

      _scanResultsSubscription?.cancel();

      _scanResultsSubscription = fbp.FlutterBluePlus.scanResults.listen(
        (results) {
          _scanResults = results;
          notifyListeners();
        },

        onError: (e) {
          print("Scan Error: $e");
          _stopScanInternal();
        },
      );

      await fbp.FlutterBluePlus.isScanning.where((val) => val == false).first;

      print("Scan automatically stopped or was stopped manually.");

      _stopScanInternal();
    } catch (e) {
      print("Error starting scan: $e");

      _stopScanInternal();
    }
  }

  Future<void> stopScan() async {
    await _stopScanInternal();
  }

  Future<void> _stopScanInternal() async {
    if (!fbp.FlutterBluePlus.isScanningNow && !_isScanning) return;

    _scanResultsSubscription?.cancel();
    _scanResultsSubscription = null;

    try {
      if (fbp.FlutterBluePlus.isScanningNow) {
        await fbp.FlutterBluePlus.stopScan();

        print("Scan stopped via FlutterBluePlus.");
      }
    } catch (e) {
      print("Error stopping scan via FlutterBluePlus: $e");
    } finally {
      if (_isScanning) {
        _isScanning = false;

        notifyListeners();

        print("Scan state updated to false.");
      }
    }
  }

  // --- Connection Logic with Bond Support ---

  Future<bool> connectToDevice(fbp.BluetoothDevice device) async {
    if (_isConnecting ||
        (_connectionState != DeviceConnectionState.disconnected &&
            _selectedDevice?.remoteId == device.remoteId)) {
      print(
        "Warning: Connection attempt already in progress or already connected/connecting. Request ignored.",
      );
      return isConnected;
    }

    if (_isScanning) {
      await _stopScanInternal();
    }

    if (_adapterState != fbp.BluetoothAdapterState.on) {
      print("Cannot connect, Bluetooth is off.");
      return false;
    }

    _isConnecting = true;
    _connectionState = DeviceConnectionState.connecting;
    _selectedDevice = device;
    notifyListeners();

    String deviceId = device.remoteId.toString();
    print("Attempting connection to $selectedDeviceName ($deviceId)");

    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;

    _connectionStateSubscription = device.connectionState.listen(
      (state) {
        print("Device $deviceId Connection State Stream Update: $state");

        if (state == fbp.BluetoothConnectionState.disconnected) {
          print("Device $deviceId reported disconnected state via stream.");

          if (_connectionState != DeviceConnectionState.disconnecting &&
              !_isConnecting) {
            _handleDisconnect(showError: true);
          }
        }
      },
      onError: (e) {
        print("Error in connection state stream for $deviceId: $e");

        if (_connectionState != DeviceConnectionState.disconnecting) {
          _handleDisconnect(showError: true);
        }
      },
    );

    try {
      // Check if this device is already bonded

      if (Platform.isAndroid && _bondedDevices.contains(deviceId)) {
        print("Device is already bonded, using secure connection");
      }

      // Connect with timeout

      await device.connect(timeout: const Duration(seconds: 15));

      // Check connection status immediately after connect returns

      if (device.isConnected == false) {
        print(
          "Device $deviceId disconnected immediately after connect() call. Aborting.",
        );

        await _handleDisconnect(showError: false);

        return false;
      }

      // Setup bond state listener

      await _setupBondStateListener(device);

      print(
        "Platform connection seems established for $deviceId, proceeding to setup...",
      );

      bool setupOk = await _postConnectionSetup(device);

      // Check connection status again after setup attempt

      if (device.isConnected == false ||
          _connectionState == DeviceConnectionState.disconnected ||
          _selectedDevice?.remoteId != device.remoteId) {
        print(
          "Device $deviceId disconnected during or immediately after setup. Aborting.",
        );

        await _handleDisconnect(showError: !setupOk);

        return false;
      }

      if (setupOk) {
        _connectionState = DeviceConnectionState.connected;
        _isConnecting = false;

        print("✅ Device $deviceId setup complete and connected.");

        // If device isn't bonded yet, try to create a bond

        if (_bondState == DeviceBondState.none && Platform.isAndroid) {
          print("Attempting to create bond with device");

          await createBond();
        }

        notifyListeners();

        return true;
      } else {
        print("❌ Post-connection setup failed for $deviceId.");

        await _handleDisconnect(showError: true);

        return false;
      }
    } catch (e) {
      print("❌ Error during connect() or setup for device $deviceId: $e");

      await _handleDisconnect(showError: true);

      return false;
    } finally {
      if (_connectionState != DeviceConnectionState.connected &&
          _isConnecting) {
        _isConnecting = false;

        notifyListeners();
      }
    }
  }

  Future<bool> _postConnectionSetup(fbp.BluetoothDevice device) async {
    try {
      print("PostConnect: Requesting MTU 184 for ${device.remoteId}...");

      await device.requestMtu(184);

      await Future.delayed(const Duration(milliseconds: 100));

      print(
        "PostConnect: Requesting Connection Priority High for ${device.remoteId}...",
      );

      await device.requestConnectionPriority(
        connectionPriorityRequest: fbp.ConnectionPriority.high,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      print("PostConnect: Discovering services for ${device.remoteId}...");

      List<fbp.BluetoothService> services = await device.discoverServices();

      print("PostConnect: Found ${services.length} services.");

      await Future.delayed(const Duration(milliseconds: 100));

      _dataCharacteristic = null;
      _modCharacteristic = null;

      fbp.BluetoothService? targetService;

      for (var s in services) {
        if (s.uuid == _BleConstants.serviceUuid) {
          targetService = s;

          break;
        }
      }

      if (targetService == null) {
        print(
          "PostConnect: ❌ Error: Required service ${_BleConstants.serviceUuid} not found.",
        );

        return false;
      }

      print("PostConnect: ✅ Found Required Service: ${targetService.uuid}");

      for (fbp.BluetoothCharacteristic c in targetService.characteristics) {
        if (c.uuid == _BleConstants.characteristicUuidData) {
          _dataCharacteristic = c;

          print("PostConnect:     * ✅ Found Data Characteristic: ${c.uuid}");
        } else if (c.uuid == _BleConstants.characteristicUuidMod) {
          _modCharacteristic = c;

          print(
            "PostConnect:     * ✅ Found Modulation Characteristic: ${c.uuid}",
          );
        }
      }

      if (_dataCharacteristic == null) {
        print(
          "PostConnect: ❌ Error: Data characteristic ${_BleConstants.characteristicUuidData} not found.",
        );

        return false;
      }

      if (_modCharacteristic == null) {
        print(
          "PostConnect: ❌ Error: Modulation characteristic ${_BleConstants.characteristicUuidMod} not found.",
        );

        return false;
      }

      if (!_dataCharacteristic!.properties.notify) {
        print(
          "PostConnect: ❌ Error: Data characteristic does NOT support Notify.",
        );

        _dataCharacteristic = null;

        return false;
      }

      if (!_modCharacteristic!.properties.write) {
        print(
          "PostConnect: ⚠️ Warning: Modulation characteristic does NOT support Write.",
        );
      }

      print(
        "PostConnect: ✅ Service discovery and characteristic validation successful.",
      );

      return true;
    } catch (e) {
      print("PostConnect: ❌ Error during post-connection setup: $e");

      return false;
    }
  }

  // Modified to accept saveData parameter

  Future<void> disconnectAndTurnOffDevice({
    bool showError = false,
    bool? saveData,
  }) async {
    final deviceToDisconnect = _selectedDevice;

    if (deviceToDisconnect == null ||
        _connectionState == DeviceConnectionState.disconnected) {
      print("Not connected or no device selected.");

      _isConnecting = false;

      if (_connectionState != DeviceConnectionState.disconnected) {
        _connectionState = DeviceConnectionState.disconnected;

        notifyListeners();
      }

      return;
    }

    print("Disconnecting & Turning Off ${deviceToDisconnect.platformName}...");

    if (_isConnecting) _isConnecting = false;

    // Cancel any reconnection attempts

    _cancelReconnectionAttempts();

    final wasRecording = _isRecording;

    _connectionState = DeviceConnectionState.disconnecting;

    notifyListeners();

    if (_modCharacteristic != null && _modCharacteristic!.properties.write) {
      try {
        print("Sending Turn Off command (0x02)...");

        await _modCharacteristic!.write(
          [0x02],
          withoutResponse: _modCharacteristic!.properties.writeWithoutResponse,
        );

        print("Turn Off command sent.");

        await Future.delayed(const Duration(milliseconds: 200));
      } catch (e) {
        print("Error writing Turn Off command: $e");
      }
    } else {
      print(
        "Modulation characteristic unavailable or unwritable, skipping Turn Off command.",
      );
    }

    if (wasRecording) {
      // Use the provided saveData parameter or default to true if not provided

      await stopRecording(saveData: saveData ?? true);
    } else {
      await _dataSubscription?.cancel();
      _dataSubscription = null;

      if (_csvWriter.isInitialized) {
        await _csvWriter.close(deleteUnencryptedCsv: _deleteUnencryptedCsv);
      }
    }

    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;

    await _bondStateSubscription?.cancel();
    _bondStateSubscription = null;

    try {
      print(
        "Calling platform disconnect for ${deviceToDisconnect.remoteId}...",
      );

      if (deviceToDisconnect.isConnected == true) {
        await deviceToDisconnect.disconnect();

        print("Platform disconnect completed.");
      } else {
        print(
          "Device reported as not connected before platform disconnect call.",
        );
      }
    } catch (e) {
      print("Error during disconnect call: $e");

      _handleDisconnect(showError: showError || true);
    } finally {
      if (_connectionState != DeviceConnectionState.disconnected) {
        print("Manually ensuring disconnected state after disconnect attempt.");

        _handleDisconnect(showError: showError);
      }
    }
  }

  Future<void> _handleDisconnect({required bool showError}) async {
    if (_connectionState == DeviceConnectionState.disconnected &&
        !_isConnecting)
      return;

    print("Executing disconnection cleanup logic...");

    final deviceId = _selectedDevice?.remoteId.toString() ?? "Unknown";

    final wasRecording = _isRecording;

    _connectionState = DeviceConnectionState.disconnected;

    _isRecording = false;

    _isConnecting = false;

    // Keep bond state - do not reset to none on disconnect

    // Only clear bond state-related listeners

    await _bondStateSubscription?.cancel();

    _bondStateSubscription = null;

    if (wasRecording) {
      print("Stopping recording tasks due to disconnect...");

      await _dataSubscription?.cancel();
      _dataSubscription = null;

      await _csvWriter.close(deleteUnencryptedCsv: _deleteUnencryptedCsv);

      if (!showError) {
        print("Data possibly saved (check CSV writer close log).");
      } else {
        print("Data saving aborted due to error. Check file state.");
      }
    } else {
      await _dataSubscription?.cancel();
      _dataSubscription = null;

      if (_csvWriter.isInitialized) {
        await _csvWriter.close(deleteUnencryptedCsv: _deleteUnencryptedCsv);
      }
    }

    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;

    _dataCharacteristic = null;

    _modCharacteristic = null;

    _currentSamples = [];

    _selectedDevice = null;

    print("Cleanup after disconnect for device $deviceId complete.");

    if (showError) {
      print("Disconnect reason: Error or unexpected device disconnection.");
    }

    // If auto-reconnect is enabled and we didn't purposely disconnect,

    // schedule a reconnection attempt

    if (_autoReconnectToBonded &&
        _bondedDevices.isNotEmpty &&
        _adapterState == fbp.BluetoothAdapterState.on &&
        !_isAttemptingAutoReconnect &&
        showError) {
      // Only reconnect on errors, not manual disconnects

      print("Unexpected disconnect detected. Scheduling reconnection attempt.");

      _scheduleReconnectionAttempt(immediate: false);
    }

    notifyListeners();
  }

  // --- Added public method to show the data access password

  Future<void> showDataAccessPassword(BuildContext context) async {
    await _csvWriter.showDataAccessPassword(context);
  }

  // --- Recording & Data Handling ---

  Future<bool> startRecording() async {
    if (!isConnected ||
        _selectedDevice == null ||
        _dataCharacteristic == null) {
      print(
        "Cannot start recording: Not connected or data characteristic not found.",
      );

      return false;
    }

    if (_isRecording) {
      print("Recording is already in progress.");
      return true;
    }

    print("Attempting to start recording...");

    // Deprecated in OSSMM app - Storage permission not required
    /*
    bool storagePermissionsGranted = await _requestStoragePermissions();

    if (!storagePermissionsGranted) {
      print("Storage permissions not granted, cannot start recording.");

      return false;
    }
    */


    bool csvReady = await _csvWriter.initialize();

    if (!csvReady) {
      print(
        "Failed to initialize CSV writer. Check permissions and storage path.",
      );

      return false;
    }

    _currentSamples = [];

    try {
      if (!_dataCharacteristic!.isNotifying) {
        await _dataCharacteristic!.setNotifyValue(true);

        print("Subscribed to data characteristic notifications.");

        await Future.delayed(const Duration(milliseconds: 100));
      } else {
        print("Data characteristic notifications already enabled.");
      }

      await _dataSubscription?.cancel();

      _dataSubscription = _dataCharacteristic!.onValueReceived.listen(
        (data) {
          if (data.length == _expectedPacketSize) {
            bool samplesAddedForPlotting = false;

            for (int i = 0; i < _samplesPerPacket; i++) {
              int offset = i * _bytesPerSample;

              try {
                final sample = DataSample(
                  transNum: data[offset + 0] + (256 * data[offset + 1]),

                  eog: data[offset + 2] + (256 * data[offset + 3]),

                  hr: data[offset + 4] + (256 * data[offset + 5]),

                  accX: data[offset + 6] + (256 * data[offset + 7]),

                  accY: data[offset + 8] + (256 * data[offset + 9]),

                  accZ: data[offset + 10] + (256 * data[offset + 11]),

                  gyroX: data[offset + 12] + (256 * data[offset + 13]),

                  gyroY: data[offset + 14] + (256 * data[offset + 15]),

                  gyroZ: data[offset + 16] + (256 * data[offset + 17]),

                  timestamp: DateTime.now(),
                );

                _csvWriter.appendSample(sample);

                if (i == 0) {
                  _currentSamples.add(sample);

                  samplesAddedForPlotting = true;
                }
              } catch (e) {
                print(
                  "Error parsing sample $i from packet at offset $offset: $e",
                );

                break;
              }
            }

            if (samplesAddedForPlotting &&
                _currentSamples.length > _maxLiveSamples) {
              _currentSamples.removeRange(
                0,
                _currentSamples.length - _maxLiveSamples,
              );
            }

            if (samplesAddedForPlotting) {
              notifyListeners();
            }
          } else {
            print(
              "Warning: Received data packet with unexpected size. Expected $_expectedPacketSize, got ${data.length}. Ignoring packet.",
            );
          }
        },

        onError: (error) {
          print("Error in data subscription stream: $error");

          _handleDisconnect(showError: true);
        },

        onDone: () {
          print("Data subscription stream closed by peripheral.");

          _handleDisconnect(showError: false);
        },

        cancelOnError: true,
      );

      _isRecording = true;

      print("✅ Recording started. Saving data to: ${csvFilePath ?? 'N/A'}");

      notifyListeners();

      return true;
    } catch (e, stacktrace) {
      print("❌ Error starting recording or setting notifications: $e");

      print(stacktrace);

      _isRecording = false;

      await _dataSubscription?.cancel();
      _dataSubscription = null;

      await _csvWriter.close(deleteUnencryptedCsv: _deleteUnencryptedCsv);

      if (_dataCharacteristic != null &&
          _dataCharacteristic!.properties.notify) {
        await _dataCharacteristic?.setNotifyValue(false).catchError((err) {
          print("Error disabling notifications after failed start: $err");
        });
      }

      notifyListeners();

      return false;
    }
  }

  Future<void> stopRecording({required bool saveData}) async {
    if (!_isRecording) return;

    print("Stopping recording...");

    final wasRecording = _isRecording;

    _isRecording = false;

    notifyListeners();

    await _dataSubscription?.cancel();

    _dataSubscription = null;

    if (_dataCharacteristic != null && _selectedDevice?.isConnected == true) {
      try {
        if (_dataCharacteristic!.properties.notify &&
            _dataCharacteristic!.isNotifying) {
          print("Unsubscribing from data characteristic...");

          await _dataCharacteristic!.setNotifyValue(false);

          print("Unsubscribed successfully.");
        }
      } catch (e) {
        print("Error unsubscribing from data characteristic: $e");
      }
    } else {
      print("Not connected or characteristic invalid, cannot unsubscribe.");
    }

    if (wasRecording) {
      if (saveData) {
        final savedPath = _csvWriter.currentFilePath;

        await _csvWriter.close(deleteUnencryptedCsv: _deleteUnencryptedCsv);

        print(
          "Recording stopped. Data saved to: ${savedPath ?? 'path not available'}",
        );

        if (navigatorKey.currentContext != null) {
          await _csvWriter.showDataAccessPassword(navigatorKey.currentContext!);
        }
      } else {
        await _csvWriter.deleteCurrentFile();

        print("Recording stopped. Data discarded.");
      }
    } else if (_csvWriter.isInitialized) {
      await _csvWriter.close(deleteUnencryptedCsv: _deleteUnencryptedCsv);

      print("CSV writer closed unexpectedly.");
    }
  }

  // --- Modulation Logic ---

  Future<void> testModulate() async {
    if (!isConnected || _modCharacteristic == null) {
      print("Cannot modulate: Not connected or mod char not found.");

      return;
    }

    if (!_modCharacteristic!.properties.write) {
      print("Modulation characteristic does not support write.");

      return;
    }

    try {
      print("Sending Modulation command (0x01)...");

      await _modCharacteristic!.write([
        0x01,
      ], withoutResponse: _modCharacteristic!.properties.writeWithoutResponse);

      print("Modulation command sent.");
    } catch (e) {
      print("Error writing modulation command: $e");
    }
  }

  // --- Helpers for Plotting ---

  Iterable<DataSample> getRawSamplesInWindow(Duration duration) {
    if (_currentSamples.isEmpty) return [];

    if (duration.isNegative || duration == Duration.zero) return [];

    final DateTime cutoffTime = DateTime.now().subtract(duration);

    if (_currentSamples.isNotEmpty &&
        !_currentSamples.first.timestamp.isBefore(cutoffTime)) {
      return List.unmodifiable(_currentSamples);
    }

    int startIndex = _currentSamples.indexWhere(
      (sample) => !sample.timestamp.isBefore(cutoffTime),
    );

    if (startIndex == -1) return [];

    return _currentSamples.getRange(startIndex, _currentSamples.length);
  }

  List<DataSample> getDownsampledSamples(Duration duration) {
    final List<DataSample> relevantSamples =
        getRawSamplesInWindow(duration).toList();

    if (relevantSamples.isEmpty) return [];

    return relevantSamples;
  }
}
