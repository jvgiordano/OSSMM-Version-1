/* ----------------------------------------------------------------
    IMPORT PACKAGES AND PAGES
   ----------------------------------------------------------------
*/
import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/* ----------------------------------------------------------------
    CREATE CSVWriter CLASS
    - Handles streaming data to CSV file
   ----------------------------------------------------------------
*/
class CSVWriter {
  final String filePath;
  final csvConverter = ListToCsvConverter();
  IOSink? _sink;
  bool _hasWrittenHeader = false;

  CSVWriter(this.filePath);

  Future<void> open() async {
    _sink = File(filePath).openWrite();
  }

  void appendRow(List<dynamic> row) {
    if (_sink == null) throw Exception('Writer not opened');

    if (!_hasWrittenHeader) {
      // Write header with newline
      _sink!.writeln(row.join(','));
      _hasWrittenHeader = true;
    } else {
      // Write data row with newline
      _sink!.writeln(row.join(','));
    }
  }

  Future<void> close() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
  }
}

/* ----------------------------------------------------------------
    CREATE DataSample CLASS
    - Temporarily holds all collected data
    - Needed for plotting data
   ----------------------------------------------------------------
*/
class DataSample {
  late int transNum;  // Transmission number
  late int accX;      // Acceleration variables
  late int accY;
  late int accZ;
  late int gyroX;     // Gyroscope variables
  late int gyroY;
  late int gyroZ;
  late int eog;       // EOG variables
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
  final String SERVICE_UUID = "5aee1a8a-08de-11ed-861d-0242ac120002";
  final String CHARACTERISTIC_UUID_Data = "405992d6-0cf2-11ed-861d-0242ac120002";
  final String CHARACTERISTIC_UUID_Mod = "018ec2b5-7c82-7773-95e2-a5f374275f0b";

  /// UUID Verification Variable
  bool isVerified = false;

  /// Initialize 'DataSamples' class for plotting
  List<DataSample> samples = List<DataSample>.empty(growable: true);

  /// Recording state variables
  bool inProgress = false;
  bool saveMyData = true;

  /// File handling variables
  CSVWriter? csvWriter;
  String? currentFilePath;

  /// BLE related variables
  BluetoothCharacteristic? modCharacteristic;
  late StreamController<List<int>> myController = StreamController();
  late Stream<List<int>> myStream = myController.stream;
  late StreamSubscription<List<int>> mySubscription;

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
     connectAndRecord FUNCTION
     - Initiates BLE Connection and Recording
     ----------------------------------------------------------------
  */
  static Future<BackgroundRecordingTask> connectAndRecord(BluetoothDevice mySelectedDevice) async {
    late Stream<List<int>> myStream;
    bool isVerified = false;

    const String SERVICE_UUID = "5aee1a8a-08de-11ed-861d-0242ac120002";
    const String CHARACTERISTIC_UUID_Data = "405992d6-0cf2-11ed-861d-0242ac120002";
    const String CHARACTERISTIC_UUID_Mod = "018ec2b5-7c82-7773-95e2-a5f374275f0b";

    /// Start Connection
    print("Attempting Connection");
    await mySelectedDevice.connect();
    print("Connection complete. Attempting MTU change request");
    await mySelectedDevice.requestMtu(184);
    print("MTU Change complete. Requesting Priority Change");
    await mySelectedDevice.requestConnectionPriority(connectionPriorityRequest: ConnectionPriority.high);
    print("Priority Change complete");

    /// Verify Service and Characteristics
    List<BluetoothService> services = await mySelectedDevice.discoverServices();
    await Future.delayed(const Duration(milliseconds: 50));

    if (!isVerified) {
      for (var service in services) {
        print("Service ID is: ${service.serviceUuid}");
        if (service.serviceUuid.toString() == SERVICE_UUID) {
          print("Service UUID Check Passed");
          await Future.delayed(const Duration(milliseconds: 50));

          for (var characteristic in service.characteristics) {
            print("Characteristic ID is: ${characteristic.characteristicUuid}");

            if (characteristic.characteristicUuid.toString() == CHARACTERISTIC_UUID_Data) {
              await Future.delayed(const Duration(milliseconds: 50));
              characteristic.setNotifyValue(!characteristic.isNotifying);
              print("Characteristic ID for Sleep Data Check Passed");
              myStream = characteristic.lastValueStream;
              isVerified = true;
            }
            else if (characteristic.characteristicUuid.toString() == CHARACTERISTIC_UUID_Mod) {
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

    /// Check Verification Result
    if (!isVerified) {
      await mySelectedDevice.disconnect();
      return Future.error("Device Verification Failed. Please select an OSSMM Device.");
    }
    else {
      print("BLE Verification passed!");
      await Future.delayed(const Duration(milliseconds: 50));
      return BackgroundRecordingTask._dataRecording(myStream);
    }
  }

  /* ----------------------------------------------------------------
     _dataRecording Constructor and Initialization
     ----------------------------------------------------------------
  */
  BackgroundRecordingTask._dataRecording(Stream<List<int>> myStream) {
    _initializeRecording(myStream);
  }

  Future<void> _initializeRecording(Stream<List<int>> myStream) async {
    print("Reached _dataRecording");
    inProgress = true;
    samples.clear();

    try {
      if (await Permission.storage.request().isGranted) {
        final dir = Directory("storage/emulated/0/OSSMM");
        if (!await dir.exists()) {
          await dir.create();
        }

        String recordingStartTime = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
        currentFilePath = "storage/emulated/0/OSSMM/$recordingStartTime.csv";

        csvWriter = CSVWriter(currentFilePath!);
        await csvWriter!.open();

        // Write headers
        csvWriter!.appendRow(['DateTime', 'transNum', 'eog', 'hr', 'accX', 'accY', 'accZ', 'gyroX', 'gyroY', 'gyroZ']);

        mySubscription = myStream.listen(
              (data) {
            for (var i = 0; i < 9; i++) {
              final sample = DataSample(
                  transNum: data[18*i] + (256 * data[18*i+1]),
                  eog: data[18*i+2] + (256 * data[18*i+3]),
                  hr: data[18*i+4] + (256 * data[18*i+5]),
                  accX: data[18*i+6] + (256 * data[18*i+7]),
                  accY: data[18*i+8] + (256 * data[18*i+9]),
                  accZ: data[18*i+10] + (256 * data[18*i+11]),
                  gyroX: data[18*i+12] + (256 * data[18*i+13]),
                  gyroY: data[18*i+14] + (256 * data[18*i+15]),
                  gyroZ: data[18*i+16] + (256 * data[18*i+17]),
                  timestamp: DateTime.now()
              );

              if (i == 0) {
                samples.add(sample);
              }

              csvWriter?.appendRow([
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
            }
            notifyListeners();
          },
          onError: (error) {
            print("Error in data recording: $error");
            _cleanup();
          },
          onDone: () => _cleanup(),
        );
      }
    } catch (e) {
      print("Exception in data recording: $e");
      _cleanup();
      rethrow;
    }
  }

  /* ----------------------------------------------------------------
     Cleanup and Cancel Functions
     ----------------------------------------------------------------
  */
  Future<void> _cleanup() async {
    await csvWriter?.close();
    csvWriter = null;
  }

  Future<void> cancel(bool saveData, BluetoothDevice mySelectedDevice) async {
    print("Arrived at cancel");

    await mySubscription.cancel();
    print("Subscription now cancelled");

    if (saveData) {
      await _cleanup();
      print("Saved the Data");
    } else {
      await _cleanup();
      /// UNCOMMENT TO DELETE FILE IF YOU DONT WANT TO SAVE IN THE END!
      /*
      if (currentFilePath != null) {
        await File(currentFilePath!).delete();
      }
       */
    }

    print("Going to cancel connection");
    await mySelectedDevice.disconnect();
    print("Cancelled device connection");

    inProgress = false;
    notifyListeners();
  }

  /* ----------------------------------------------------------------
     testModulate FUNCTION
     - Activates Sleep Modulator
     ----------------------------------------------------------------
  */
  Future<void> testModulate(BluetoothDevice mySelectedDevice) async {
    print("Arrived at modulate");

    if (modCharacteristic == null) {
      List<BluetoothService> services = await mySelectedDevice.discoverServices();

      services.forEach((service) {
        print("Service ID is: ${service.serviceUuid}");
        if (service.serviceUuid.toString() == SERVICE_UUID) {
          service.characteristics.forEach((characteristic) {
            if (characteristic.characteristicUuid.toString() == CHARACTERISTIC_UUID_Mod) {
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
     getLastOf Function
     - For Plotting Data
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