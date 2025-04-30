// lib/src/core/services/bluetooth_service.dart

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp; // Use alias for FlutterBluePlus
import 'package:permission_handler/permission_handler.dart';
import 'package:ossmm/src/core/models/data_sample.dart'; // Assuming this path is correct
import 'package:ossmm/src/core/utils/csv_writer.dart'; // Assuming this path is correct

// Merged BleConstants
class _BleConstants {
  _BleConstants._();
  static final fbp.Guid serviceUuid = fbp.Guid("5aee1a8a-08de-11ed-861d-0242ac120002");
  static final fbp.Guid characteristicUuidData = fbp.Guid("405992d6-0cf2-11ed-861d-0242ac120002");
  static final fbp.Guid characteristicUuidMod = fbp.Guid("018ec2b5-7c82-7773-95e2-a5f374275f0b");
  static const String deviceDirectory = "OSSMM"; // Keep name consistent if needed
}

enum DeviceConnectionState { disconnected, connecting, connected, disconnecting }

class OssmmBluetoothService with ChangeNotifier {

  // --- State Variables ---
  fbp.BluetoothAdapterState _adapterState = fbp.BluetoothAdapterState.unknown;
  StreamSubscription<fbp.BluetoothAdapterState>? _adapterStateSubscription;
  List<fbp.ScanResult> _scanResults = [];
  StreamSubscription<List<fbp.ScanResult>>? _scanResultsSubscription;
  bool _isScanning = false;
  fbp.BluetoothDevice? _selectedDevice;
  StreamSubscription<fbp.BluetoothConnectionState>? _connectionStateSubscription;
  DeviceConnectionState _connectionState = DeviceConnectionState.disconnected;
  bool _isConnecting = false;
  fbp.BluetoothCharacteristic? _dataCharacteristic;
  fbp.BluetoothCharacteristic? _modCharacteristic;
  StreamSubscription<List<int>>? _dataSubscription;
  final CsvWriterUtil _csvWriter = CsvWriterUtil();
  List<DataSample> _currentSamples = [];
  bool _isRecording = false;
  static const int _maxLiveSamples = 7500; // Keep a buffer for live plotting

  // --- Constants based on OBSERVED packet size ---
  static const int _samplesPerPacket = 10; // CORRECTED: 180 bytes / 18 bytes/sample
  static const int _bytesPerSample = 18;
  static const int _expectedPacketSize = _samplesPerPacket * _bytesPerSample; // CORRECTED: 180 bytes

  // --- Public Getters ---
  fbp.BluetoothAdapterState get adapterState => _adapterState;
  List<fbp.ScanResult> get scanResults => _scanResults;
  bool get isScanning => _isScanning;
  fbp.BluetoothDevice? get selectedDevice => _selectedDevice;
  String get selectedDeviceName => _selectedDevice?.platformName.isNotEmpty ?? false ? _selectedDevice!.platformName : (_selectedDevice?.remoteId.toString() ?? "None");
  DeviceConnectionState get connectionState => _connectionState;
  bool get isConnected => _connectionState == DeviceConnectionState.connected;
  bool get isConnecting => _isConnecting;
  bool get isRecording => _isRecording;
  String? get csvFilePath => _csvWriter.currentFilePath;
  List<DataSample> get currentRawSamples => List.unmodifiable(_currentSamples); // Keep this if needed elsewhere

  // --- Initialization & Disposal ---
  OssmmBluetoothService() { _initialize(); }

  void _initialize() {
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = fbp.FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (state != fbp.BluetoothAdapterState.on) { _handleBluetoothOff(); }
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
    _csvWriter.close();
    final device = _selectedDevice;
    // Use `device.isConnected` getter which checks platform state
    if (device != null && device.isConnected == true) {
      device.disconnect().catchError((e) { print("Error during dispose disconnect: $e"); });
    }
    super.dispose();
  }

  void _handleBluetoothOff() {
    print("Handling Bluetooth Off event");
    if (_isScanning) { _stopScanInternal(); }
    _scanResults = [];
    if (_connectionState != DeviceConnectionState.disconnected) { _handleDisconnect(showError: false); }
    _connectionState = DeviceConnectionState.disconnected;
    _isConnecting = false; _isRecording = false;
    _dataSubscription?.cancel(); _dataSubscription = null;
    _connectionStateSubscription?.cancel(); _connectionStateSubscription = null;
    _csvWriter.close();
    _selectedDevice = null; _dataCharacteristic = null; _modCharacteristic = null;
    _currentSamples = [];
    notifyListeners();
  }

  // --- Permissions ---

  // Requests only permissions needed for BLE scanning and connecting
  Future<bool> _requestBlePermissions() async {
    print("Requesting Bluetooth Scan/Connect/Location Permissions...");
    Map<Permission, PermissionStatus> statuses = {};

    if (Platform.isAndroid) {
      statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.locationWhenInUse, // Recommended for reliable scan
      ].request();

      statuses.forEach((p, s) => print('$p : $s'));

      final bool scanGranted = statuses[Permission.bluetoothScan]?.isGranted ?? false;
      final bool connectGranted = statuses[Permission.bluetoothConnect]?.isGranted ?? false;
      // Location is recommended but scan might work without it on some OS versions
      final bool locationGranted = statuses[Permission.locationWhenInUse]?.isGranted ?? false;
      if (!locationGranted) { print('Warning: Location permission not granted. BLE scanning might be unreliable.'); }

      bool allBtGranted = scanGranted && connectGranted;
      if (!allBtGranted) { print('Required Bluetooth permissions (Scan & Connect) not granted.'); return false; }
      return true;

    } else if (Platform.isIOS) {
      // iOS permissions (Bluetooth usage description) configured in Info.plist
      print("iOS Permissions should be configured in Info.plist"); return true;
    }
    print("Unsupported platform for BLE permissions or check failed.");
    return false;
  }

  // Requests only permissions needed for storage (writing CSV)
  Future<bool> _requestStoragePermissions() async {
    print("Requesting Storage Permissions...");
    PermissionStatus status;
    if (Platform.isAndroid) {
      // Using Permission.photos as CsvWriterUtil uses it. Adjust if CsvWriterUtil changes.
      status = await Permission.photos.request();
      print('Storage (Photos) Permission status: $status');
      return status.isGranted;
    }
    // Add iOS specific storage permission logic if needed
    return true; // Assume granted or not needed on other platforms
  }


  // --- Scanning Logic ---
  Future<void> startScan() async {
    if (_isScanning) { print("Scan already in progress."); return; }
    if (_adapterState != fbp.BluetoothAdapterState.on) { print("Cannot scan, Bluetooth is off."); return; }

    // Request ONLY BLE permissions before scanning
    bool blePermissionsGranted = await _requestBlePermissions();
    if (!blePermissionsGranted) { print("BLE permissions not granted, cannot start scan."); return; }

    _isScanning = true; _scanResults = []; notifyListeners(); print("Starting BLE scan...");
    try {
      // Start scanning - adjust filters if needed
      await fbp.FlutterBluePlus.startScan(
        // Ensure no filters are applied unless intended
        // withServices: [_BleConstants.serviceUuid], // Keep commented unless needed
          timeout: const Duration(seconds: 5));

      _scanResultsSubscription?.cancel();
      _scanResultsSubscription = fbp.FlutterBluePlus.scanResults.listen(
              (results) { _scanResults = results; notifyListeners(); },
          onError: (e) { print("Scan Error: $e"); _stopScanInternal(); }
      );

      // Wait until scanning stops
      await fbp.FlutterBluePlus.isScanning.where((val) => val == false).first;
      print("Scan automatically stopped or was stopped manually.");
      _stopScanInternal(); // Ensure state is updated even if stopped automatically

    } catch (e) {
      print("Error starting scan: $e");
      // Handle specific errors like platform exceptions if needed
      _stopScanInternal();
    }
  }

  Future<void> stopScan() async { await _stopScanInternal(); }

  Future<void> _stopScanInternal() async {
    // Check library's state first
    if (!fbp.FlutterBluePlus.isScanningNow && !_isScanning) return;

    _scanResultsSubscription?.cancel(); _scanResultsSubscription = null;
    try {
      // Check again before stopping, might have stopped automatically
      if (fbp.FlutterBluePlus.isScanningNow) {
        await fbp.FlutterBluePlus.stopScan();
        print("Scan stopped via FlutterBluePlus.");
      }
    }
    catch(e) { print("Error stopping scan via FlutterBluePlus: $e"); }
    finally {
      // Update our internal state only if it was true
      if (_isScanning) {
        _isScanning = false;
        notifyListeners();
        print("Scan state updated to false.");
      }
    }
  }

  // --- Connection Logic ---
  Future<bool> connectToDevice(fbp.BluetoothDevice device) async {
    if (_isConnecting || (_connectionState != DeviceConnectionState.disconnected && _selectedDevice?.remoteId == device.remoteId)) {
      print("Warning: Connection attempt already in progress or already connected/connecting. Request ignored."); return isConnected;
    }
    if (_isScanning) { await _stopScanInternal(); }
    if (_adapterState != fbp.BluetoothAdapterState.on) { print("Cannot connect, Bluetooth is off."); return false; }

    _isConnecting = true; _connectionState = DeviceConnectionState.connecting; _selectedDevice = device; notifyListeners();
    String deviceId = device.remoteId.toString(); print("Attempting connection to $selectedDeviceName ($deviceId)");

    await _connectionStateSubscription?.cancel(); _connectionStateSubscription = null;
    _connectionStateSubscription = device.connectionState.listen(
            (state) {
          print("Device $deviceId Connection State Stream Update: $state");
          if (state == fbp.BluetoothConnectionState.disconnected) {
            print("Device $deviceId reported disconnected state via stream.");
            // Only handle unexpected disconnects here
            if (_connectionState != DeviceConnectionState.disconnecting && !_isConnecting) {
              _handleDisconnect(showError: true);
            }
          }
        }, onError: (e) {
      print("Error in connection state stream for $deviceId: $e");
      // Treat stream errors as disconnects if we weren't already disconnecting
      if (_connectionState != DeviceConnectionState.disconnecting) {
        _handleDisconnect(showError: true);
      }
    }
    );

    try {
      // Connect with timeout
      await device.connect(timeout: const Duration(seconds: 15));

      // Check connection status immediately after connect returns
      if (device.isConnected == false) {
        print("Device $deviceId disconnected immediately after connect() call. Aborting.");
        // Ensure cleanup happens, don't show error as connect itself failed clearly
        await _handleDisconnect(showError: false);
        return false;
      }

      print("Platform connection seems established for $deviceId, proceeding to setup...");
      bool setupOk = await _postConnectionSetup(device);

      // Check connection status again after setup attempt
      if (device.isConnected == false || _connectionState == DeviceConnectionState.disconnected || _selectedDevice?.remoteId != device.remoteId) {
        print("Device $deviceId disconnected during or immediately after setup. Aborting.");
        // If setup failed, it likely caused the disconnect, show error context
        await _handleDisconnect(showError: !setupOk);
        return false;
      }

      if (setupOk) {
        _connectionState = DeviceConnectionState.connected; _isConnecting = false;
        print("✅ Device $deviceId setup complete and connected.");
        notifyListeners();
        return true;
      } else {
        print("❌ Post-connection setup failed for $deviceId.");
        // Disconnect if setup failed but connection somehow remained
        await _handleDisconnect(showError: true);
        return false;
      }
    } catch (e) {
      print("❌ Error during connect() or setup for device $deviceId: $e");
      // Ensure cleanup on error
      await _handleDisconnect(showError: true);
      return false;
    }
    finally {
      // If connection didn't reach 'connected' state, ensure 'isConnecting' is false
      if (_connectionState != DeviceConnectionState.connected && _isConnecting) {
        _isConnecting = false;
        notifyListeners();
      }
    }
  }

  Future<bool> _postConnectionSetup(fbp.BluetoothDevice device) async {
    try {
      print("PostConnect: Requesting MTU 184 for ${device.remoteId}..."); // Keep MTU 184
      await device.requestMtu(184);
      await Future.delayed(const Duration(milliseconds: 100)); // Small delay

      print("PostConnect: Requesting Connection Priority High for ${device.remoteId}...");
      await device.requestConnectionPriority(connectionPriorityRequest: fbp.ConnectionPriority.high);
      await Future.delayed(const Duration(milliseconds: 100)); // Small delay

      print("PostConnect: Discovering services for ${device.remoteId}...");
      List<fbp.BluetoothService> services = await device.discoverServices();
      print("PostConnect: Found ${services.length} services.");
      await Future.delayed(const Duration(milliseconds: 100)); // Small delay

      _dataCharacteristic = null; _modCharacteristic = null;
      fbp.BluetoothService? targetService;

      // Find the target service
      for (var s in services) {
        if (s.uuid == _BleConstants.serviceUuid) {
          targetService = s;
          break;
        }
      }

      if (targetService == null) {
        print("PostConnect: ❌ Error: Required service ${_BleConstants.serviceUuid} not found.");
        return false;
      }
      print("PostConnect: ✅ Found Required Service: ${targetService.uuid}");

      // Find characteristics within the target service
      for (fbp.BluetoothCharacteristic c in targetService.characteristics) {
        if (c.uuid == _BleConstants.characteristicUuidData) {
          _dataCharacteristic = c;
          print("PostConnect:     * ✅ Found Data Characteristic: ${c.uuid}");
        } else if (c.uuid == _BleConstants.characteristicUuidMod) {
          _modCharacteristic = c;
          print("PostConnect:     * ✅ Found Modulation Characteristic: ${c.uuid}");
        }
      }

      // Validate characteristics
      if (_dataCharacteristic == null) {
        print("PostConnect: ❌ Error: Data characteristic ${_BleConstants.characteristicUuidData} not found.");
        return false;
      }
      if (_modCharacteristic == null) {
        print("PostConnect: ❌ Error: Modulation characteristic ${_BleConstants.characteristicUuidMod} not found.");
        return false; // Or make this optional if modulation isn't critical
      }

      // Check properties (Notify for data, Write for mod)
      if (!_dataCharacteristic!.properties.notify) {
        print("PostConnect: ❌ Error: Data characteristic does NOT support Notify.");
        _dataCharacteristic = null; // Invalidate it
        return false;
      }
      if (!_modCharacteristic!.properties.write) {
        // Warning only, maybe modulation isn't always needed
        print("PostConnect: ⚠️ Warning: Modulation characteristic does NOT support Write.");
      }

      print("PostConnect: ✅ Service discovery and characteristic validation successful.");
      return true;

    } catch (e) {
      print("PostConnect: ❌ Error during post-connection setup: $e");
      return false;
    }
  }

  Future<void> disconnectAndTurnOffDevice({bool showError = false}) async {
    final deviceToDisconnect = _selectedDevice;
    if (deviceToDisconnect == null || _connectionState == DeviceConnectionState.disconnected) {
      print("Not connected or no device selected.");
      _isConnecting = false; // Ensure connecting flag is false
      if (_connectionState != DeviceConnectionState.disconnected) {
        _connectionState = DeviceConnectionState.disconnected;
        notifyListeners();
      }
      return;
    }

    print("Disconnecting & Turning Off ${deviceToDisconnect.platformName}...");

    // Ensure we are not trying to connect while disconnecting
    if (_isConnecting) _isConnecting = false;

    final wasRecording = _isRecording;
    _connectionState = DeviceConnectionState.disconnecting;
    notifyListeners(); // Notify UI about disconnecting state

    // Attempt to send turn off command *before* stopping recording/disconnecting
    if (_modCharacteristic != null && _modCharacteristic!.properties.write) {
      try {
        print("Sending Turn Off command (0x02)...");
        // Use write without response for potentially faster execution if device supports it
        await _modCharacteristic!.write([0x02], withoutResponse: _modCharacteristic!.properties.writeWithoutResponse);
        print("Turn Off command sent.");
        await Future.delayed(const Duration(milliseconds: 200)); // Give time for command processing
      } catch (e) {
        print("Error writing Turn Off command: $e");
        // Continue disconnection even if command fails
      }
    } else {
      print("Modulation characteristic unavailable or unwritable, skipping Turn Off command.");
    }

    // Stop recording and handle CSV file *before* full disconnect cleanup
    if (wasRecording) {
      await stopRecording(saveData: true); // Assume save data on manual disconnect
    } else {
      // Ensure subscription is cancelled and CSV closed even if not recording formally
      await _dataSubscription?.cancel(); _dataSubscription = null;
      if (_csvWriter.isInitialized) { await _csvWriter.close();}
    }

    // Cancel connection state listener *before* calling disconnect
    await _connectionStateSubscription?.cancel(); _connectionStateSubscription = null;

    // Perform platform disconnect
    try {
      print("Calling platform disconnect for ${deviceToDisconnect.remoteId}...");
      if (deviceToDisconnect.isConnected == true) {
        await deviceToDisconnect.disconnect();
        print("Platform disconnect completed.");
      } else {
        print("Device reported as not connected before platform disconnect call.");
      }
    } catch (e) {
      print("Error during disconnect call: $e");
      // Ensure cleanup still happens
      _handleDisconnect(showError: showError || true); // Show error if disconnect call failed
    } finally {
      // Final cleanup, regardless of disconnect success/failure
      // Use showError flag passed initially OR true if disconnect call threw error
      if (_connectionState != DeviceConnectionState.disconnected) {
        print("Manually ensuring disconnected state after disconnect attempt.");
        _handleDisconnect(showError: showError);
      }
    }
  }


  // Centralized disconnect cleanup logic
  Future<void> _handleDisconnect({required bool showError}) async {
    // Prevent multiple cleanup runs if called rapidly
    if (_connectionState == DeviceConnectionState.disconnected && !_isConnecting) return;

    print("Executing disconnection cleanup logic...");
    final deviceId = _selectedDevice?.remoteId.toString() ?? "Unknown";

    final wasRecording = _isRecording;
    // Update state immediately to prevent race conditions
    _connectionState = DeviceConnectionState.disconnected;
    _isRecording = false; // Recording stops on disconnect
    _isConnecting = false; // Cannot be connecting if disconnected

    // Stop recording tasks if it was active
    if (wasRecording) {
      print("Stopping recording tasks due to disconnect...");
      await _dataSubscription?.cancel(); _dataSubscription = null;
      // Decide whether to save data on unexpected disconnect (showError=true)
      // Defaulting to false (discard) on error, true otherwise might be safer
      await _csvWriter.close(); // Close first
      if (!showError) {
        print("Data possibly saved (check CSV writer close log).");
      } else {
        // Consider deleting or renaming the file to indicate partial data
        print("Data saving aborted due to error. Check file state.");
        // await _csvWriter.deleteCurrentFile(); // Uncomment to discard on error
      }
    } else {
      // Ensure resources are cleaned even if not formally recording
      await _dataSubscription?.cancel(); _dataSubscription = null;
      if (_csvWriter.isInitialized) { await _csvWriter.close();}
    }

    // Clean up BLE resources
    await _connectionStateSubscription?.cancel(); _connectionStateSubscription = null;
    _dataCharacteristic = null;
    _modCharacteristic = null;

    // Clear local data and state
    _currentSamples = [];
    _selectedDevice = null; // Clear selected device

    print("Cleanup after disconnect for device $deviceId complete.");
    if (showError) {
      print("Disconnect reason: Error or unexpected device disconnection.");
      // Potentially show a user-facing message here or via state change
    }

    notifyListeners(); // Notify UI about the final disconnected state
  }

  // --- Recording & Data Handling ---
  Future<bool> startRecording() async {
    if (!isConnected || _selectedDevice == null || _dataCharacteristic == null) {
      print("Cannot start recording: Not connected or data characteristic not found.");
      return false;
    }
    if (_isRecording) { print("Recording is already in progress."); return true; }

    print("Attempting to start recording...");

    // Request STORAGE permissions just before initializing CSV writer
    bool storagePermissionsGranted = await _requestStoragePermissions();
    if (!storagePermissionsGranted) {
      print("Storage permissions not granted, cannot start recording.");
      // Show error to user
      return false;
    }

    bool csvReady = await _csvWriter.initialize();
    if (!csvReady) {
      print("Failed to initialize CSV writer. Check permissions and storage path.");
      // Show error to user
      return false;
    }

    _currentSamples = []; // Clear previous live samples

    try {
      // Ensure notifications are enabled
      if (!_dataCharacteristic!.isNotifying) {
        await _dataCharacteristic!.setNotifyValue(true);
        print("Subscribed to data characteristic notifications.");
        // Add a small delay after enabling notifications if needed
        await Future.delayed(const Duration(milliseconds: 100));
      } else {
        print("Data characteristic notifications already enabled.");
      }


      await _dataSubscription?.cancel(); // Cancel any previous subscription
      _dataSubscription = _dataCharacteristic!.onValueReceived.listen(
              (data) {
            // --- Start: Data Processing Logic ---
            // Check if packet has the CORRECTED expected size (180 bytes)
            if (data.length == _expectedPacketSize) {
              bool samplesAddedForPlotting = false;
              // Loop the CORRECTED number of times (10)
              for (int i = 0; i < _samplesPerPacket; i++) {
                int offset = i * _bytesPerSample;
                try {
                  // Create DataSample directly using byte offsets
                  final sample = DataSample(
                    transNum: data[offset + 0] + (256 * data[offset + 1]),
                    eog:      data[offset + 2] + (256 * data[offset + 3]),
                    hr:       data[offset + 4] + (256 * data[offset + 5]),
                    accX:     data[offset + 6] + (256 * data[offset + 7]),
                    accY:     data[offset + 8] + (256 * data[offset + 9]),
                    accZ:     data[offset + 10] + (256 * data[offset + 11]),
                    gyroX:    data[offset + 12] + (256 * data[offset + 13]),
                    gyroY:    data[offset + 14] + (256 * data[offset + 15]),
                    gyroZ:    data[offset + 16] + (256 * data[offset + 17]),
                    timestamp: DateTime.now(), // Timestamp when sample is processed
                  );

                  // Append to CSV immediately
                  _csvWriter.appendSample(sample);

                  // Add first sample of packet to live data list for plotting
                  // NO CHANGE HERE - Keep adding only 1 sample per packet based on user request
                  if (i == 0) {
                    _currentSamples.add(sample);
                    samplesAddedForPlotting = true;
                  }

                } catch (e) {
                  print("Error parsing sample $i from packet at offset $offset: $e");
                  // Consider adding more details like packet bytes on error
                  break; // Stop processing this packet on error
                }
              }

              // Manage live samples buffer size
              if (samplesAddedForPlotting && _currentSamples.length > _maxLiveSamples) {
                _currentSamples.removeRange(0, _currentSamples.length - _maxLiveSamples);
              }

              // Notify listeners *once* per processed packet if a sample was added
              if (samplesAddedForPlotting) {
                notifyListeners();
              }

            } else {
              // Log the differing size
              print("Warning: Received data packet with unexpected size. Expected $_expectedPacketSize, got ${data.length}. Ignoring packet.");
            }
            // --- End: Data Processing Logic ---
          },
          onError: (error) {
            print("Error in data subscription stream: $error");
            // Treat stream errors as disconnects
            _handleDisconnect(showError: true);
          },
          onDone: () {
            print("Data subscription stream closed by peripheral.");
            // Peripheral closed the stream, treat as disconnect
            _handleDisconnect(showError: false); // Not necessarily an error
          },
          cancelOnError: true // Cancel subscription on error
      );

      _isRecording = true;
      print("✅ Recording started. Saving data to: ${csvFilePath ?? 'N/A'}");
      notifyListeners(); // Notify UI that recording has started
      return true;

    } catch (e, stacktrace) {
      print("❌ Error starting recording or setting notifications: $e");
      print(stacktrace);
      _isRecording = false; // Ensure recording state is false on error
      await _dataSubscription?.cancel(); _dataSubscription = null;
      await _csvWriter.close(); // Close CSV writer on error
      // Attempt to disable notifications, ignore errors
      if (_dataCharacteristic != null && _dataCharacteristic!.properties.notify) {
        await _dataCharacteristic?.setNotifyValue(false).catchError((err) {
          print("Error disabling notifications after failed start: $err");
        });
      }
      notifyListeners(); // Notify UI about the failed state
      return false;
    }
  }


  Future<void> stopRecording({required bool saveData}) async {
    if (!_isRecording) return; // Only stop if recording

    print("Stopping recording...");
    final wasRecording = _isRecording; // Should be true here
    _isRecording = false; // Update state immediately
    notifyListeners(); // Notify UI recording stopped

    // Cancel the data stream subscription first
    await _dataSubscription?.cancel();
    _dataSubscription = null;

    // Attempt to unsubscribe from notifications (best effort)
    if (_dataCharacteristic != null && _selectedDevice?.isConnected == true) {
      try {
        if (_dataCharacteristic!.properties.notify && _dataCharacteristic!.isNotifying) {
          print("Unsubscribing from data characteristic...");
          await _dataCharacteristic!.setNotifyValue(false);
          print("Unsubscribed successfully.");
        }
      } catch (e) {
        print("Error unsubscribing from data characteristic: $e");
        // Continue cleanup even if unsubscribing fails
      }
    } else {
      print("Not connected or characteristic invalid, cannot unsubscribe.");
    }

    // Handle the CSV file based on saveData flag
    if (wasRecording) { // Redundant check, but safe
      if (saveData) {
        final savedPath = _csvWriter.currentFilePath;
        await _csvWriter.close(); // Flush and close the file
        print("Recording stopped. Data saved to: ${savedPath ?? 'path not available'}");
      } else {
        await _csvWriter.deleteCurrentFile(); // Close and delete the file
        print("Recording stopped. Data discarded.");
      }
    } else if (_csvWriter.isInitialized) {
      // If somehow stopRecording is called when not recording, ensure file is closed
      await _csvWriter.close();
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
      // Use withoutResponse based on characteristic property for potentially faster send
      await _modCharacteristic!.write([0x01], withoutResponse: _modCharacteristic!.properties.writeWithoutResponse);
      print("Modulation command sent.");
    } catch (e) {
      print("Error writing modulation command: $e");
      // Consider showing feedback to the user
    }
  }


  // --- Helpers for Plotting ---

  // MODIFICATION START: Made public
  // Get raw samples within the specified duration from the end of the list
  Iterable<DataSample> getRawSamplesInWindow(Duration duration) {
    // MODIFICATION END: Made public (removed leading underscore)
    if (_currentSamples.isEmpty) return [];
    // Ensure duration isn't negative or zero
    if (duration.isNegative || duration == Duration.zero) return [];

    final DateTime cutoffTime = DateTime.now().subtract(duration);

    // Optimization: If all samples are newer than cutoff, return all
    if (_currentSamples.isNotEmpty && !_currentSamples.first.timestamp.isBefore(cutoffTime)) {
      return List.unmodifiable(_currentSamples);
    }

    // Find the first index whose timestamp is NOT before the cutoff
    // Use binary search if _currentSamples is always sorted by timestamp (which it should be)
    // For simplicity, using indexWhere for now. Replace with binary search for performance if needed.
    int startIndex = _currentSamples.indexWhere((sample) => !sample.timestamp.isBefore(cutoffTime));

    // If no samples are within the window (all are too old), return empty
    if (startIndex == -1) return [];

    // Return the range from the start index to the end
    // Use sublist for safety if _currentSamples might be modified elsewhere concurrently (unlikely here)
    // return _currentSamples.sublist(startIndex);
    // Using getRange for potentially better performance if sublist creates copies
    return _currentSamples.getRange(startIndex, _currentSamples.length);
  }

  // Returns the raw samples within the specified time window.
  // The downsampleFactor parameter is ignored as downsampling is removed.
  List<DataSample> getDownsampledSamples(Duration duration) { // Removed downsampleFactor parameter
    // Get only the samples within the display window first
    final List<DataSample> relevantSamples = getRawSamplesInWindow(duration).toList();
    if (relevantSamples.isEmpty) return [];

    // Return all samples within the window (no downsampling)
    return relevantSamples;
  }

} // End of OssmmBluetoothService class