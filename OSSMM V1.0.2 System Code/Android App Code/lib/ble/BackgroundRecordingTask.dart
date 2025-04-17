/* ----------------------------------------------------------------
    IMPORT PACKAGES AND PAGES
   ----------------------------------------------------------------
*/
// Packages
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/* ----------------------------------------------------------------
    CREATE DataSample CLASS
    - Temporarily holds all collected data
    - Needed for plotting data
   ----------------------------------------------------------------
*/
class DataSample {

  late int transNum;  // Transmission number (this number will eventually repeat, but useful for identify gaps in transmission)

  late int accX;      // Acceleration variables
  late int accY;
  late int accZ;

  late int gyroX;     // Gyroscope variables
  late int gyroY;
  late int gyroZ;

  late int eog;      // EOG variables (vertical, horizontal)
  late int hr;

  DateTime timestamp; // Get local time stamp (from phone)

  DataSample({
    required this.transNum,
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.eog,
    required this.hr,
    required this.timestamp,
  });

}

class BackgroundRecordingTask extends Model {

  /* ----------------------------------------------------------------
     INITIALIZE NECESSARY VARIABLES
     ----------------------------------------------------------------
  */

  /// NECESSARY BLE UUID INFORMATION
  final String SERVICE_UUID = "5aee1a8a-08de-11ed-861d-0242ac120002";              // Service UUID

  final String CHARACTERISTIC_UUID_Data = "405992d6-0cf2-11ed-861d-0242ac120002";  // Sleep Data Characteristic UUID
  final String CHARACTERISTIC_UUID_Mod = "018ec2b5-7c82-7773-95e2-a5f374275f0b";   // Sleep Modulator Characteristic UUID


  /// UUID Verification Variable, Assume at start BLE connection is NOT verified
  bool isVerified = false;

  /// List of Lists to then convert to CSV for storage,
  /// this takes in and separate items from 'DataSample' class
  List<List<String>> csvData = [
    // CSV Headers
    <String>['DateTime', 'transNum', 'eog', 'hr', 'accX', 'accY', 'accZ', 'gyroX', 'gyroY', 'gyroZ'],
  ];

  /// Initialize 'DataSamples' class called 'samples'
  List<DataSample> samples = List<DataSample>.empty(growable: true);

  /// if BLE Data Recording is in progress, default is FALSE
  bool inProgress = false;

  /// Decide if CSV data is saved, default is TRUE
  bool saveMyData = true;

  ///  Sleep Modulation Characteristic, allows for WRITE to MCU
  BluetoothCharacteristic? modCharacteristic;                                  // Sleep Modulator Characteristic Variable

  /// Stream from receiving BLE data
  late StreamController<List<int>> myController = StreamController();
  late Stream<List<int>> myStream = myController.stream;
  late StreamSubscription<List<int>> mySubscription;

  /* ----------------------------------------------------------------
      CREATE getCSV() FUNCTION
      - Creates 'WakeLift' folder for files on Android, if it does not exist
      - Converts received data over BLE to CSV Format
      - Saves data to 'WakeLift' folder
     ----------------------------------------------------------------
  */

  getCSV(List<List<dynamic>> myList) async {

    /// Testing Permissions
    var status = await Permission.storage.status;
    print("Storage Permission Status:" + status.toString());

    /// If we have storage permission, then continue
    if (await Permission.storage.request().isGranted) {

      /// Create a 'WakeLift' folder in internal storage (if it doesn't exist)
      final dir = Directory("storage/emulated/0/WakeLift");
      if ((await dir.exists())){
        //Test Print
        print("WakeLift folder already exists");
      }
      else {
        //Test Print
        print("Creating WakeLift folder");
        dir.create();
      }

      /// Get Datetime and create new CSV name by this
      /// NOTE: This is actually the END time of the recording, this must be fixed!
      DateTime now = DateTime.now();
      String recordingStartTime = DateFormat('yyyy-MM-dd – kk:mm').format(now);

      /// Put together folderPath and new CSV file name
      String dirStr = dir.toString(); // Convert directory to string
      String path = ("storage/emulated/0/WakeLift/$recordingStartTime.csv");

      ///Test Print
      print("Directory of CSV:" + path);

      /// Convert my List (or in future Streamable) to CSV
      String myCSV = const ListToCsvConverter().convert(myList);

      /// Create CSV File and write CSV contents
      final File myFile = File(path);
      await myFile.writeAsString(myCSV);

      /// Test Print
      print("CSV file written");

    }
    else{
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }

  }


  /* ----------------------------------------------------------------
     REQUIRED FOR SCOPED MODEL USAGE
     ----------------------------------------------------------------
  */
  static BackgroundRecordingTask of(
      BuildContext context, {
        bool rebuildOnChange = false,
      }) =>
      ScopedModel.of<BackgroundRecordingTask>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  /* ----------------------------------------------------------------
       CREATE connectAndRecord FUNCTION
       - Initiates BLE Connection from App to MCU
       - Verifies Service UUID and Sleep Characteristic UUID
       - Initiates BLE Data Collection on BLE Sleep Characteristic
     ----------------------------------------------------------------
  */

  static Future<BackgroundRecordingTask> connectAndRecord (BluetoothDevice mySelectedDevice) async {

    /// CREATE VARIABLES
    late Stream<List<int>> myStream; // Create Stream variable

    bool isVerified = false; // If UUIDs have been verified


    /// NECESSARY BLE PROFILE INFORMATION AND VARIABLES
    const String SERVICE_UUID = "5aee1a8a-08de-11ed-861d-0242ac120002"; // Service UUID

    const String CHARACTERISTIC_UUID_Data = "405992d6-0cf2-11ed-861d-0242ac120002"; // Sleep Data Characteristic UUID
    const String CHARACTERISTIC_UUID_Mod = "018ec2b5-7c82-7773-95e2-a5f374275f0b";  // Sleep Modulator Characteristic UUID

    /// START THE CONNECTION, ADJUST MTU AND SET PRIORITY HIGH
    print("Attempting Connection");
    await mySelectedDevice.connect(); // Connect to BLE Device
    print("Connection complete. Attempting MTU change request");
    await mySelectedDevice.requestMtu(184); // Request MTU increase
    print("MTU Change complete. Requesting Priority Change");
    await mySelectedDevice.requestConnectionPriority(connectionPriorityRequest: ConnectionPriority.high);  // Request HIGH connection priority
    print("Priority Change complete");


    /// VERIFY SERVICE AND SLEEP CHARACTERISTIC UUIDs
    List<BluetoothService> services = await mySelectedDevice
        .discoverServices(); // Gather Service Information

    await Future.delayed(const Duration(milliseconds: 50));

    if (!isVerified) {
      for (var service in services)  { // Verify Service UUID (there's 1)
        print("Service ID is: " + service.serviceUuid.toString());
        if (service.serviceUuid.toString() == SERVICE_UUID) { // Check Service UUID
          print("Service UUID Check Passed");
          await Future.delayed(const Duration(milliseconds: 50));

          for (var characteristic in service.characteristics) { // Verify Sleep Characteristic UUIDs (there's 2)
            print("Characteristic ID is: " + characteristic.characteristicUuid.toString());

            if (characteristic.characteristicUuid.toString() == CHARACTERISTIC_UUID_Data) // Verify SLEEP DATA Characteristic
                {
              await Future.delayed(const Duration(milliseconds: 50));
              characteristic.setNotifyValue(!characteristic.isNotifying);
              print("Characteristic ID for Sleep Data Check Passed");
              myStream = characteristic.lastValueStream;
              isVerified = true;
            }
            else if (characteristic.characteristicUuid.toString() == CHARACTERISTIC_UUID_Mod) // Verify SLEEP MODULATOR Characteristic
               {
              await Future.delayed(const Duration(milliseconds: 250));
              characteristic.setNotifyValue(!characteristic.isNotifying);
              print("Characteristic ID for Modulation Data Check Passed");
              isVerified = true;
            }
            else {
              print("A characteristic ID Check Failed");
              isVerified = false;
            }
          }
        }
        else {
          print("Service UUID Check Failed");
        }
      }
    }

    /// CHECK BLE VERIFICATION
    if (!isVerified) {                                                               // If failed then DISCONNECT and return error
      await mySelectedDevice.disconnect();
      return Future.error("Device Verification Failed. Please select a WakeLift Device.");
    }
    else {                                                                           // If BLE Verification passed
      print("BLE Verification passed!");
      await Future.delayed(const Duration(milliseconds: 50));
      return BackgroundRecordingTask._dataRecording(myStream);                       // Call _dataRecording and START RECORDING
    }
  }

  /* ----------------------------------------------------------------
       dataRecording Function
       - Initiates BLE Data Collection on BLE Sleep Characteristic
       - Collect BLE Data and adds to CSV
     ----------------------------------------------------------------
  */

  BackgroundRecordingTask._dataRecording(Stream<List<int>> myStream){

    /* ----------------------------------------------------------------
        INITIALIZE NECESSARY VARIABLES
       ----------------------------------------------------------------
    */
    print("Reached _dataRecording");

    /// Prepare Data Variables for Recording
    inProgress = true;
    samples.clear();
    csvData.clear();

    /// Reinstate headers on CSV file
    csvData = [
      /// Headers
      <String>['DateTime', 'transNum', 'eog', 'hr', 'accX', 'accY', 'accZ', 'gyroX', 'gyroY', 'gyroZ'],
    ];

    /* ----------------------------------------------------------------
         START COLLECTING DATA
       ----------------------------------------------------------------
    */

    mySubscription = myStream.listen((data){
      // This should be 9 to optimize throughput for 184  MTU size
      // 0-9 => 10 loops
      for (var i = 0; i < 9; i++) {
        final DataSample sample = DataSample(

            transNum: data[18*i] + (256 * data[(18*i)+1]),
            eog: data[(18*i)+2] + (256 * data[(18*i)+3]),
            hr: data[(18*i)+4] + (256 * data[(18*i)+5]),
            accX: data[(18*i)+6] + (256 * data[(18*i)+7]),
            accY: data[(18*i)+8] + (256 * data[(18*i)+9]),
            accZ: data[(18*i)+10] + (256 * data[(18*i)+11]),
            gyroX: data[(18*i)+12] + (256 * data[(18*i)+13]),
            gyroY: data[(18*i)+14] + (256 * data[(18*i)+15]),
            gyroZ: data[(18*i)+16] + (256 * data[(18*i)+17]),
            timestamp: DateTime.now()

          /// Original with single MTU packet (18 bytes)
          /// Kept for posterity
          /*
            transNum: data[0] + (256 * data[1]),
            eog: data[2] + (256 * data[3]),
            hr: data[4] + (256 * data[5]),
            accX: data[6] + (256 * data[7]),
            accY: data[8] + (256 * data[9]),
            accZ: data[10] + (256 * data[11]),
            gyroX: data[12] + (256 * data[13]),
            gyroY: data[14] + (256 * data[15]),
            gyroZ: data[16] + (256 * data[17]),
            timestamp: DateTime.now()
             */
        );

        /// Check every 10th value through print for debugging
        /*
          if (i == 0) {
            print("Transmission Number: " + sample.transNum.toString());
            print("Accelerometer_X: " + sample.accX.toString());
            print("Accelerometer_Y: " + sample.accY.toString());
            print("Accelerometer_Z: " + sample.accZ.toString());
            print("Gyroscope_X: " + sample.gyroX.toString());
            print("Gyroscope_Y: " + sample.gyroY.toString());
            print("Gyroscope_Z: " + sample.gyroZ.toString());
            print("EOG: " + sample.eog.toString());
            print("HR: " + sample.hr.toString());
            print(i.toString());
          }
          */

        /// Only record 1/10 points for Plotting - Use less resource
        /// This plots at ~25 Hz
        /// 'samples' is for plotting, 'sample' (without ending 's') is for CSV
        if (i == 0) {
          samples.add(sample); // Also, can I add to csvData this way?
        }

        /// Add data to CSV
        csvData.add([
          sample.timestamp.toString(),
          sample.transNum.toString(),
          sample.eog.toStringAsFixed(0),
          sample.hr.toStringAsFixed(0),
          sample.accX.toStringAsFixed(0),
          sample.accY.toStringAsFixed(0),
          sample.accZ.toStringAsFixed(0),
          sample.gyroX.toStringAsFixed(0),
          sample.gyroY.toStringAsFixed(0),
          sample.gyroZ.toStringAsFixed(0),
        ]);

        notifyListeners(); // This should only be done as necessary, not on every datasample
      }
    });

  }

  /* ----------------------------------------------------------------
     cancel() FUNCTION
     - Closes BLE connection
     - Initiates getCSV() to save recorded data
     ----------------------------------------------------------------
  */

  Future<void> cancel(bool saveData, BluetoothDevice mySelectedDevice) async {
    print("Arrived at cancel");

    /// Close stream subscription
    await mySubscription.cancel();
    print("Subscription now cancelled");

    /// Section to Save CSV
    if (saveData == true){
      getCSV(csvData);
      print("Saved the Data");
    }

    /// Disconnect BLE
    print("Going to cancel connection");
    await mySelectedDevice.disconnect();
    print("Cancelled device connection");

    /// Set inProgress to False
    inProgress = false;

    notifyListeners();
  }

  /* ----------------------------------------------------------------
     testModulate() FUNCTION
     - Purpose: Activate Sleep Modulator (vibration disc) momentarily
     - Assigns BLE Characteristic for Modulation to variable 'modCharacteristic'
     if not yet done
     - Writes '0x01' (true) to modCharacteristic
     ----------------------------------------------------------------
  */

  Future<void> testModulate(BluetoothDevice mySelectedDevice) async {
    print("Arrived at modulate");

    /// Close stream subscription
    if (modCharacteristic == null) {
      List<BluetoothService> services = await mySelectedDevice
          .discoverServices(); // Gather Service Information

      services.forEach((service) { // Verify Service UUID (there's 1)
        print("Service ID is: " + service.serviceUuid.toString());
        if (service.serviceUuid.toString() ==
            SERVICE_UUID) { // Check Service UUID
          service.characteristics.forEach((
              characteristic) { // Verify Characteristic UUIDs (there's 2)
            if (characteristic.characteristicUuid.toString() == CHARACTERISTIC_UUID_Mod) // Verify MODULATOR Characteristic
                {
                characteristic.setNotifyValue(!characteristic.isNotifying);
                modCharacteristic = characteristic;

                print("modCharacteristic Identified");
            }
          });
        }
      });
    }

    await modCharacteristic?.write([0x01]);

  }

  /* ----------------------------------------------------------------
     getLastOf() function
     - Passes Recorded data to plots
     ----------------------------------------------------------------
  */

  Iterable<DataSample> getLastOf(Duration duration) {
    DateTime startingTime = DateTime.now().subtract(duration);
    int i = samples.length;
    do {
      i -= 1;
      if (i <= 0) {
        break;
      }
    } while (samples[i].timestamp.isAfter(startingTime));
    return samples.getRange(i, samples.length);
  }

}

