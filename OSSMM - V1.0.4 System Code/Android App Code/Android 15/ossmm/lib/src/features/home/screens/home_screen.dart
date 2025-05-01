// lib/src/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:provider/provider.dart';
import 'package:ossmm/src/core/services/bluetooth_service.dart';
import 'package:ossmm/src/features/data_display/widgets/live_data_chart.dart';
import 'package:ossmm/src/features/device_scan/screens/find_devices_screen.dart';
import 'dart:async';
import 'package:ossmm/src/core/models/data_sample.dart';

// Add this for global context access
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Local UI state
  bool _modulationEnabled = false;
  // Renamed variable to reflect its new purpose (controls both start and stop behavior)
  bool _startStopWithConnection = true; // Default to true

  // To manage the "Connecting..." dialog presentation logic
  bool _isConnectingDialogShowing = false;
  // Store the service instance for easy access in listeners
  late OssmmBluetoothService _bluetoothService;

  @override
  void initState() {
    super.initState();
    // Get service instance (don't listen here, use Consumer/watch elsewhere)
    _bluetoothService = Provider.of<OssmmBluetoothService>(context, listen: false);
    // Add listener to react to service state changes
    _bluetoothService.addListener(_handleServiceStateChange);
    // Initial check in case state is already 'connecting' when screen loads
    _handleServiceStateChange();
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    _bluetoothService.removeListener(_handleServiceStateChange);
    // Dismiss dialog if it's showing when screen is disposed
    if (_isConnectingDialogShowing && Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
      _isConnectingDialogShowing = false;
    }
    super.dispose();
  }

  // Listener callback for service state changes
  void _handleServiceStateChange() {
    // --- Manage Connecting Dialog ---
    final bool shouldShowDialog = _bluetoothService.isConnecting &&
        _bluetoothService.connectionState == DeviceConnectionState.connecting;

    if (shouldShowDialog && !_isConnectingDialogShowing) {
      // Show dialog if connecting and not already showing
      _showConnectingDialog(context);
    } else if (!shouldShowDialog && _isConnectingDialogShowing) {
      // Hide dialog if not connecting anymore and dialog is showing
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      // _isConnectingDialogShowing flag is reset in the dialog's .then() clause
    }

    // --- Handle Auto-Start Recording (if toggle is enabled) ---
    if (_bluetoothService.connectionState == DeviceConnectionState.connected &&
        _startStopWithConnection && // Check the toggle state
        !_bluetoothService.isRecording) {
      print("Auto-start condition met. Attempting to start recording...");
      // Use a short delay to ensure state propagation before starting recording
      Future.delayed(const Duration(milliseconds: 100), () {
        // Check connection state again inside the delayed future
        if (_bluetoothService.isConnected && !_bluetoothService.isRecording) {
          _bluetoothService.startRecording().then((success) {
            if (!success && mounted) {
              _showErrorDialog(context, "Auto-Recording Failed", "Could not automatically start recording.");
            } else if (success) {
              print("Auto-recording started successfully.");
            }
          });
        } else {
          print("Conditions for auto-start no longer met after delay (disconnected or already recording).");
        }
      });
    }
    // Note: Auto-stopping based on disconnect is handled implicitly by the service's _handleDisconnect logic.
  }

  // Helper to track if the *last known user action* was trying to connect
  bool _wasAttemptingConnect() {
    return _bluetoothService.isConnecting;
  }


  // --- Dialog Functions ---
  void _showConnectingDialog(BuildContext context) {
    if (!mounted || _isConnectingDialogShowing) return;
    _isConnectingDialogShowing = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return const PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Connecting..."),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      // Reset flag when dialog is closed
      if(mounted) _isConnectingDialogShowing = false;
    });
  }

  Future<bool?> _showSaveDataDialog(BuildContext context) async {
    if (!mounted) return null;
    return showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text("Save Recording?"),
            content: const Text("Do you want to save the collected data?"),
            actions: [
              TextButton( child: const Text("Discard"), onPressed: () => Navigator.of(dialogContext).pop(false), ),
              TextButton( child: const Text("Save"), onPressed: () => Navigator.of(dialogContext).pop(true), ),
            ],
          );
        }
    );
  }

  Future<void> _showErrorDialog(BuildContext context, String title, String content) async {
    if (!mounted) return;
    // Ensure connecting dialog is closed BEFORE showing error dialog
    if (_isConnectingDialogShowing && Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
      _isConnectingDialogShowing = false;
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[ TextButton( child: const Text("Close"), onPressed: () => Navigator.of(dialogContext).pop(), ), ],
        );
      },
    );
  }

  // --- Widget Build Method ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OSSMM Dashboard'),
        actions: [ Consumer<OssmmBluetoothService>( builder: (context, service, child) { return Padding( padding: const EdgeInsets.only(right: 16.0), child: Icon( service.isConnected ? Icons.bluetooth_connected : service.isConnecting ? Icons.bluetooth_searching : Icons.bluetooth_disabled, color: service.isConnected ? Colors.white : service.isConnecting ? Colors.yellow : Colors.white54, ), ); } ) ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          // --- Connection Section ---
          _buildSectionTitle(context, 'Connection'),
          Consumer<OssmmBluetoothService>( builder: (context, service, child) { return ListTile( leading: const Icon(Icons.bluetooth), title: Text('Status: ${service.connectionState.name}'), subtitle: Text('Device: ${service.selectedDeviceName}'), ); } ),

          // --- Start/Stop with Connection Toggle ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
            child: SwitchListTile(
              title: const Text("Start/Stop with Connection"),
              value: _startStopWithConnection,
              // Disable toggle while connecting/disconnecting
              onChanged: (_bluetoothService.isConnecting || _bluetoothService.connectionState == DeviceConnectionState.disconnecting)
                  ? null
                  : (bool value) {
                setState(() { _startStopWithConnection = value; });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),

          // --- Connect / Disconnect Buttons ---
          Consumer<OssmmBluetoothService>( builder: (context, service, child) { return Padding( padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), child: Row( mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // Find Device Button
            ElevatedButton.icon( icon: const Icon(Icons.search), label: const Text('Find Device'),
              onPressed: (service.isConnected || service.isConnecting || service.connectionState == DeviceConnectionState.disconnecting) ? null : () async {
                final selectedDevice = await Navigator.of(context).push<fbp.BluetoothDevice?>( MaterialPageRoute(builder: (ctx) => const FindDevicesScreen()), );
                if (selectedDevice != null && mounted) {
                  bool success = await context.read<OssmmBluetoothService>().connectToDevice(selectedDevice);
                  if (!success && mounted && !_isConnectingDialogShowing) {
                    _showErrorDialog(context, "Connection Failed", "Could not connect to ${selectedDevice.platformName}. Please check device.");
                  }
                }
              },
            ),
            // Connect / Disconnect Button
            ElevatedButton.icon(
              icon: Icon(service.isConnected ? Icons.power_settings_new : Icons.link),
              label: Text(service.isConnected ? 'Disconnect & Turn Off' : 'Connect'), // Disconnect always turns off now
              style: ElevatedButton.styleFrom( backgroundColor: service.isConnected ? Colors.red : null),
              // Enable Connect only if NOT connected and a device IS selected and NOT already connecting/disconnecting
              onPressed: (!service.isConnected && service.selectedDevice != null && !service.isConnecting && service.connectionState != DeviceConnectionState.disconnecting) ? () async {
                final deviceToConnect = service.selectedDevice;
                if (deviceToConnect != null) {
                  bool success = await context.read<OssmmBluetoothService>().connectToDevice(deviceToConnect);
                  if (!success && mounted && !_isConnectingDialogShowing) {
                    _showErrorDialog(context, "Connection Failed", "Could not connect to ${service.selectedDeviceName}. Please check device.");
                  }
                }
              } : (service.isConnected && !service.isConnecting && service.connectionState != DeviceConnectionState.disconnecting) ? () async {
                // Always call disconnectAndTurnOffDevice when disconnecting via this button
                await context.read<OssmmBluetoothService>().disconnectAndTurnOffDevice();
              } : null,
            ),
          ], ), ); }
          ),
          const Divider(),

          // --- Recording Section ---
          _buildSectionTitle(context, 'Recording'),
          Consumer<OssmmBluetoothService>(
              builder: (context, service, child) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(service.isRecording ? Icons.stop_circle_outlined : Icons.play_circle_outline),
                      title: Text(service.isRecording ? 'Recording Active' : 'Recording Stopped'),
                      subtitle: Text(service.isRecording ? 'Saving to: ${service.csvFilePath ?? "..."}' : 'Press Start to begin recording'),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: ElevatedButton.icon(
                        icon: Icon(service.isRecording ? Icons.stop : Icons.play_arrow),
                        label: Text(service.isRecording
                            ? (_startStopWithConnection
                            ? "Stop Recording and Turn Off OSSMM"
                            : "Stop Recording")
                            : "Start Recording"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: service.isRecording ? Colors.orange : Colors.green
                        ),
                        onPressed: service.isRecording
                            ? (_startStopWithConnection
                            ? (service.isRecording && !service.isConnecting && service.connectionState != DeviceConnectionState.disconnecting)
                            ? () async {
                          await context.read<OssmmBluetoothService>().disconnectAndTurnOffDevice();
                        }
                            : null
                            : (service.isRecording && !service.isConnecting && service.connectionState != DeviceConnectionState.disconnecting)
                            ? () async {
                          bool? saveData = await _showSaveDataDialog(context);
                          if (saveData != null && mounted) {
                            await context.read<OssmmBluetoothService>().stopRecording(saveData: saveData);
                          }
                        }
                            : null)
                            : (service.isConnected && !service.isRecording && !service.isConnecting && service.connectionState != DeviceConnectionState.disconnecting)
                            ? () async {
                          bool success = await context.read<OssmmBluetoothService>().startRecording();
                          if(!success && mounted) {
                            _showErrorDialog(context, "Recording Failed", "Could not start recording. Check permissions/connection/device.");
                          }
                        }
                            : null,
                      ),
                    ),
                  ],
                );
              }
          ),
          const Divider(),

          // --- Modulation Section ---
          _buildSectionTitle(context, 'Sleep Modulation'),
          Consumer<OssmmBluetoothService>( builder: (context, service, child) { return SwitchListTile(
            secondary: const Icon(Icons.bedtime_outlined),
            title: const Text("Modulation Mode"),
            subtitle: Text(_modulationEnabled ? "Enabled (Test button active)" : "Disabled"),
            value: _modulationEnabled,
            onChanged: (service.isConnecting || service.connectionState == DeviceConnectionState.disconnecting)
                ? null
                : (bool value) { setState(() { _modulationEnabled = value; }); },
          );
          }
          ),
          Consumer<OssmmBluetoothService>( builder: (context, service, child) { return Padding( padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), child: ElevatedButton.icon(
            icon: const Icon(Icons.send_outlined),
            label: const Text('Test Modulation'),
            onPressed: service.isConnected && _modulationEnabled && !service.isConnecting && service.connectionState != DeviceConnectionState.disconnecting
                ? () => context.read<OssmmBluetoothService>().testModulate()
                : null,
          ), ); }
          ),
          const Divider(),

          // --- Live Data Section ---
          ExpansionTile(
            title: _buildSectionTitle(context, 'Live Data'),
            leading: const Icon(Icons.auto_graph),
            initiallyExpanded: true, // Keep collapsed initially
            children: <Widget>[
              Consumer<OssmmBluetoothService>(
                  builder: (context, service, child) {
                    final List<DataSample> chartSamples = service.getDownsampledSamples(
                        const Duration(seconds: 20)); // Pass only the duration

                    bool hasChartData = chartSamples.isNotEmpty;
                    bool showChart = service.isConnected && hasChartData;

                    if (!service.isConnected && !service.isConnecting) {
                      return const Padding( padding: EdgeInsets.all(16.0), child: Text("Connect to a device to see live data."), );
                    } else if (service.isConnecting) {
                      return const Padding( padding: EdgeInsets.all(16.0), child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [ CircularProgressIndicator(), SizedBox(width: 15), Text("Connecting..."), ],), );
                    } else if (!service.isRecording && !hasChartData && service.isConnected) {
                      return const Padding( padding: EdgeInsets.all(16.0), child: Text("Start recording to view live data."), );
                    } else if (!hasChartData && service.isRecording) {
                      return const Padding( padding: EdgeInsets.all(16.0), child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [ CircularProgressIndicator(), SizedBox(width: 15), Text("Waiting for data..."), ],),);
                    } else if (showChart) {
                      return LiveDataChart(
                        samples: chartSamples,
                        displayDuration: const Duration(seconds: 20),
                      );
                    } else {
                      return const Padding( padding: EdgeInsets.all(16.0), child: Text("Connect and start recording to view live data."), );
                    }
                  }
              )
            ],
          ),
          const Divider(),

          // --- Changed to ExpansionTile for Data Protection Section ---
          ExpansionTile(
            title: _buildSectionTitle(context, 'Data Protection'),
            leading: const Icon(Icons.security),
            initiallyExpanded: false, // Start expanded for visibility
            children: <Widget>[
              Consumer<OssmmBluetoothService>(
                  builder: (context, service, child) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              "Data is encrypted with a password when stored. You'll need this password to access recorded files.",
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.password),
                            label: const Text('View Data Access Password'),
                            onPressed: () => service.showDataAccessPassword(context),
                          ),
                        ],
                      ),
                    );
                  }
              ),
            ],
          ),

          // Added extra padding at the bottom for navigation bar clearance
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  // Helper for section titles
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}