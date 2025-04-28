/* ----------------------------------------------------------------
    IMPORT PACKAGES
   ----------------------------------------------------------------
*/
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/* ----------------------------------------------------------------
    IMPORT PAGES
   ----------------------------------------------------------------
*/
import 'package:wakelift/widgets/widgets.dart';

/* ----------------------------------------------------------------
    Bluetooth Device Search - find BLE devices and connect
   ----------------------------------------------------------------
*/

class FindDevicesScreen extends StatefulWidget {
  /// If true, discovery starts on page start, otherwise user must press action button.
  final bool start;
  const FindDevicesScreen({this.start = true});

  @override
  _FindDevicesScreen createState() => _FindDevicesScreen();
}

class _FindDevicesScreen extends State<FindDevicesScreen> {

  _FindDevicesScreen();

  @override
  void initState() {
    super.initState();
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 3));
    //print("initState is called");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
      ),
      body: RefreshIndicator(
        onRefresh: () => FlutterBluePlus.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              /* ----------------------------------------------------------------
                  LIST BLE SCAN RESULTS AND CONNECT TO DEVICE
                 ----------------------------------------------------------------
              */
              StreamBuilder<List<ScanResult>>(
                stream: FlutterBluePlus.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map(
                        (r) => ScanResultTile(
                      result: r,
                          onTap: ()
                          {
                            print(r.device.toString());
                            //print("Connected to " + r.device.name.toString());
                            Navigator.of(context).pop(r.device);
                          }
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: FlutterBluePlus.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: () => FlutterBluePlus.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => FlutterBluePlus.startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}
