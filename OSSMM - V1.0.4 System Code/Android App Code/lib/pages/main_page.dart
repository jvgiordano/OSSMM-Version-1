/* ----------------------------------------------------------------
    IMPORT PACKAGES AND PAGES
   ----------------------------------------------------------------
*/
// Packages
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:ui' as ui;
import 'dart:io';

// Pages
import 'package:wakelift/ble/FindDevices.dart';
import 'package:wakelift/ble/BackgroundRecordingTask.dart';
import 'package:wakelift/ble/DisplayCurrentDataPage.dart';

/* ----------------------------------------------------------------
    Run FlutterBlueApp Class
    - First Class Called
   ----------------------------------------------------------------
*/
void main() {
  runApp(const Home());
}

/* ----------------------------------------------------------------
    FlutterBlueApp Class
    - If Bluetooth is off on App start -> open 'BluetoothOffScreen'
    - Otherwise -> opens 'MainPage
   ----------------------------------------------------------------
*/
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.lightBlue,
      home: StreamBuilder< BluetoothAdapterState>(
          stream: FlutterBluePlus.adapterState,
          initialData:  BluetoothAdapterState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            // Check if Bluetooth is enabled on Android Device
            print("Bluetooth State:" + state.toString());
            if (state !=  BluetoothAdapterState.on) {
              print("BT Off Screen test - this should print");
              print("State = " + state.toString());
              return BluetoothOffScreen(state: state);
            }
            return const MainPage();
          }),
    );
  }
}

/* ----------------------------------------------------------------
    OPENING SCREEN - IF Bluetooth Adapter is OFF
   ----------------------------------------------------------------
*/
class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.state}) : super(key: key);

  final  BluetoothAdapterState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Welcome to OSSMM 5v0.4.0',
                style: Theme.of(context)
                    .primaryTextTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white)),
            const Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: Colors.white54,
            ),
            Text(
              'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
              style: Theme.of(context)
                  .primaryTextTheme
                  .titleSmall
                  ?.copyWith(color: Colors.white),
            ),
            ElevatedButton(
              child: const Text('TURN ON'),
              onPressed: Platform.isAndroid
                  ? () => FlutterBluePlus.turnOn()
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/* ----------------------------------------------------------------
    MAIN PAGE
   ----------------------------------------------------------------
*/
class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {

  /* ----------------------------------------------------------------
      Variables
     ----------------------------------------------------------------
  */
  /// Selected BLE device
  late BluetoothDevice mySelectedDevice;

  /// Set default BT Selected Device Name to "None"
  String mySelectedDeviceName = "None";

  /// Variable for recorded data
  BackgroundRecordingTask? _RecordingTask;

  /// Variable for sleep modulation
  bool wakeLiftEnabled = false;

  /// Variable for if BT is connected, data is recording and transferring
  // Set starting recording bool to false, since there is no recording
  bool isRecording = false;

  /// Option to save CSV Data, set to True as default
  bool saveData = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("OSSMM 5v0.4.0")),
        ),
        body: ListView(
          children: <Widget>[
            const Divider(),
            // "Mode" Center Text
            const ListTile(
                title: Center(
              child:
                  Text('Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            )),

      /// "Sleep Modulation Enable" Toggle (under Mode Section)
            SwitchListTile(
              title: const Text("Sleep Modulation"),
              subtitle: (wakeLiftEnabled)
                  ? const Text.rich(TextSpan(
                      children: <InlineSpan>[
                        TextSpan(text: "Enabled"),
                        WidgetSpan(
                          alignment: ui.PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.notifications_active_outlined,
                            color: Colors.blue,
                            size: 20,
                          ),
                        )
                      ],
                    ))
                  : const Text.rich(TextSpan(
                      children: <InlineSpan>[
                        TextSpan(text: "Disabled"),
                        WidgetSpan(
                          alignment: ui.PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.notifications_off_outlined,
                            color: Colors.blueGrey,
                            size: 20,
                          ),
                        )
                      ],
                    )),
              value: wakeLiftEnabled,
              onChanged: (_RecordingTask?.inProgress != true) ? (bool value) async {
                setState(() {
                  wakeLiftEnabled = value;
                });
              }
              : null,
            ),
            // "Connection" Center Text
            const ListTile(
                title: Center(
              child: Text('Connection',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )),
            // "Select Device and Start Recording" Button (under Connection Section)
            ListTile(
                title: ElevatedButton(
              /* ----------------------------------------------------------------
                      SELECT DEVICE AND START RECORDING   (button)
                                   or
                        STOP RECORDING and TURN OFF OSSMM    (button)
                 ----------------------------------------------------------------
               */

              /// If 'isRecording is 'false', then assume RecordingTask is not in progress
              /// Therefore, offer 'Select Device and Start Recording'
              /// Otherwise offer 'Disconnect and Stop Recording'
              child: (_RecordingTask?.inProgress ?? false) // 'isRecording' starts as 'false'
                  ? const Text('Stop Recording and Turn Off Headband')
                  : const Text('Select Device and Start Recording'),
              // Select BLE device from list
              onPressed: () async {
                /* ----------------------------------------------------------------
                        DISCONNECT AND STOP RECORDING
                        - if App is recording, then disconnect BLE and stop recording
                   ----------------------------------------------------------------
                */
                /// if _RecordTask?.inProgress is null, then set value of 'if' to false
                if (_RecordingTask?.inProgress ?? false) {
                  /// Ask the user if they want to save data, update 'saveData' variable
                  await openDialogSaveCSV();
                  print("Opened 'DialogSaveCSV' alert window");

                  /// Disconnect BLE Device and save CSV data with .cancel(saveData=True, mySelectedDevice)
                  /// Also changes .inProgress to FALSE
                  await _RecordingTask!.cancel(saveData, mySelectedDevice);

                  // Update BLE device name and 'Selected Device: ' text
                  mySelectedDeviceName = "None";

                  // Update screens
                  setState(() {});

                  print("Connected Devices: " + FlutterBluePlus.connectedDevices.toString());
                }
                /* ----------------------------------------------------------------
                        CONNECT AND START RECORDING
                        - if App is NOT recording, then connect BLE and start recording
                   ----------------------------------------------------------------
                */
                else {
                  try {
                    /// Select Device and get Device Name Back
                    mySelectedDevice = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const FindDevicesScreen();
                    }));

                    if (mySelectedDevice.platformName !="None") {
                      /// Call Alert Dialog to wait for connection
                      _connectingAlert();
                    }

                    /// Update  'Selected Device: ' text
                    mySelectedDeviceName = mySelectedDevice.platformName;

                    /// Start BLE Connection and Data Collection
                    await _startBackgroundTask(context, mySelectedDevice);

                    /// Closer _connectingAlert() once connected
                    Future.delayed(const Duration(seconds: 5));
                    Navigator.of(context, rootNavigator: true).pop();

                  }

                  /// NO DEVICE FOUND OR SELECTED
                  /// if no device is found, or we return to main without selection, catch 'null' device exception
                  catch (e) {
                    // print("Caught the exception");
                    mySelectedDeviceName = "None";
                  }

                  // Update screen
                  setState(() {});
                }
              },
            )),
            // "Selected Device: " Text
            ListTile(
              title: const Text('Selected Device: '),
              subtitle: Text(mySelectedDeviceName),
            ),
            /// Device Selection Text
            // "Actions" Center Text
            const ListTile(
                title: Center(
              child: Text('Actions',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            )),
            /// View Current" Data Button
            ListTile(
              title: ElevatedButton(
                child: const Text('View Current Data'),
                onPressed: (_RecordingTask != null) ? () {
                  print("Reached View Current Data");
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ScopedModel<BackgroundRecordingTask>(
                          model: _RecordingTask!,
                          child: DisplayCurrentDataPage(),
                        );
                      },
                    ),
                  );
                }
                    : null,
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('Test Modulation'),
                onPressed: ((_RecordingTask?.inProgress != false) && (_RecordingTask?.inProgress != null) && (wakeLiftEnabled == true) ) ? () async {
                    await _RecordingTask?.testModulate(mySelectedDevice);
                }
                    : null,
              ),/// "View Current Data" Button
            )
          ],
        ));
  }

  /* ----------------------------------------------------------------
      SAVE CSV Dialog
       -Ask user if they want to save sleep data as CSV
     ----------------------------------------------------------------
  */
  Future openDialogSaveCSV() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Do you want to save your sleep data?"),
          actions: [
            TextButton(
              child: const Text("No"),
              onPressed: () {
                saveData = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                saveData = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  /*----------------------------------------------------------------
      START BACKGROUND RECORDING TASK
        -Connects to BLE Device
        -Start recording BLE data
   ----------------------------------------------------------------
 */
  Future<void> _startBackgroundTask(
    BuildContext context,
    BluetoothDevice myDevice,
  ) async {
    try {
      _RecordingTask = await BackgroundRecordingTask.connectAndRecord(mySelectedDevice);
    } catch (ex) {
      print("Got to the exception");
      await mySelectedDevice.disconnect();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occurred while connecting. Please try again.'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  mySelectedDeviceName = "None";
                  setState(() {});
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  /*----------------------------------------------------------------
      CONNECTING ALERT DIALOG
       -Show alert dialog while BLE is connecting
       -Prevents user from affecting app
     ----------------------------------------------------------------
  */
  Future _connectingAlert() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
     return AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Transform.scale(
                  scale: 0.75,
                  child: const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 8.0,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Connecting...",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0),
                  ),
                )
              ],
            ));
      },
    );
  }
}
