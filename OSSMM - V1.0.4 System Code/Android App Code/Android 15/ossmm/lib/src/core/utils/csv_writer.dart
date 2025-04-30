// lib/src/core/utils/csv_writer.dart

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:ossmm/src/core/models/data_sample.dart';

// Define a constant for the subdirectory name
const String _deviceDirectoryName = "OSSMM";

class CsvWriterUtil {
  String? _currentFilePath;
  IOSink? _sink;
  bool _hasWrittenHeader = false;
  bool _isInitialized = false;

  String? get currentFilePath => _currentFilePath;
  bool get isInitialized => _isInitialized;

  // Request necessary permissions for Android
  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // For Android 13+ (API 33+), we need to request specific permissions
      if (await Permission.photos.status.isGranted) {
        print("Photos permission is already granted.");
        return true;
      }

      // Request the specific media permissions
      var status = await Permission.photos.request();
      print("Media permission request status: $status");

      // Also request storage permission for backward compatibility
      var storageStatus = await Permission.storage.request();
      print("Storage permission request status: $storageStatus");

      // Return true if either permission is granted
      return status.isGranted || storageStatus.isGranted;
    } else {
      // On non-Android platforms, assume permission is not needed or handled differently
      return true;
    }
  }

  // Prepare storage - uses the public Downloads directory
  Future<bool> _prepareStorage() async {
    bool permissionsGranted = await _requestStoragePermission();
    if (!permissionsGranted) {
      print("Storage permissions not granted. Cannot prepare storage.");
      return false;
    }

    try {
      // Get the Downloads directory path
      final Directory? downloadsDir = Directory('/storage/emulated/0/Download');
      if (downloadsDir == null) {
        print("Could not access Downloads directory");
        return false;
      }

      // Create the OSSMM subdirectory in Downloads
      final Directory dir = Directory("${downloadsDir.path}/$_deviceDirectoryName");
      print("Target directory path: ${dir.path}");

      if (!await dir.exists()) {
        print("Attempting to create directory: ${dir.path}");
        await dir.create(recursive: true);

        if (!await dir.exists()) {
          print("Error: Failed to create directory after attempting: ${dir.path}");
          return false;
        }
        print("Created directory: ${dir.path}");
      } else {
        print("Directory already exists: ${dir.path}");
      }
      print("Storage directory successfully prepared: ${dir.path}");
      return true;

    } catch (e, stacktrace) {
      // Catch errors during directory creation/checking
      print("Error preparing storage directory: $e");
      print("Stacktrace: $stacktrace");
      return false;
    }
  }

  // Initialize writer: Uses the prepared storage path
  Future<bool> initialize() async {
    if (_isInitialized) {
      print("CSV Writer already initialized.");
      return true;
    }

    bool storageReady = await _prepareStorage();
    if (!storageReady) {
      print("Storage not ready (permissions or creation failed), cannot initialize CsvWriterUtil.");
      return false;
    }

    try {
      String recordingStartTime = DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now());

      // Get the Downloads directory and append our subdirectory
      final downloadsDir = Directory('/storage/emulated/0/Download');
      final Directory dir = Directory("${downloadsDir.path}/$_deviceDirectoryName");
      _currentFilePath = "${dir.path}/$recordingStartTime.csv";

      // Verify directory exists before trying to create file
      if (!await dir.exists()) {
        print("Error: Target directory ${dir.path} does not exist before file creation.");
        return false;
      }

      final file = File(_currentFilePath!);
      _sink = file.openWrite();
      print("Opened CSV file for writing: $_currentFilePath");

      _writeRow(DataSample.csvHeader);
      _hasWrittenHeader = true;
      _isInitialized = true;
      return true;

    } catch (e, stacktrace) {
      print("Error initializing CSV writer at path '$_currentFilePath': $e");
      print("Stacktrace: $stacktrace");
      _currentFilePath = null;
      _sink = null;
      _isInitialized = false;
      return false;
    }
  }

  void _writeRow(List<String> row) {
    if (_sink == null || !_isInitialized) {
      print('Warning: CSV Writer not initialized or sink is null. Cannot write row.');
      return;
    }
    // Properly escape fields containing commas, quotes, or newlines
    final formattedRow = row.map((field) {
      String safeField = field ?? ""; // Handle null fields
      String escapedField = safeField.replaceAll('"', '""'); // Escape double quotes
      if (escapedField.contains(',') || escapedField.contains('"') || escapedField.contains('\n')) {
        return '"$escapedField"'; // Enclose in double quotes if necessary
      }
      return escapedField;
    }).join(',');
    try {
      _sink!.writeln(formattedRow);
    } catch (e) {
      print("Error writing line to CSV: $e");
    }
  }

  void appendSample(DataSample sample) {
    if (!_isInitialized || _sink == null) {
      print("Warning: Cannot append sample, writer not initialized.");
      return;
    }
    if (!_hasWrittenHeader) {
      print("Warning: Header not written before appending data. Writing header now.");
      _writeRow(DataSample.csvHeader);
      _hasWrittenHeader = true;
    }
    _writeRow(sample.toCsvRow());
  }

  Future<void> close() async {
    if (_sink != null) {
      final tempPath = _currentFilePath; // Store path before nulling sink
      try {
        await _sink!.flush();
        await _sink!.close();
        print("Closed CSV file: $tempPath");
      } catch(e) {
        print("Error closing CSV sink for file $tempPath: $e");
      }
    }
    _sink = null;
    _hasWrittenHeader = false;
    _isInitialized = false;
  }

  Future<void> deleteCurrentFile() async {
    final pathToDelete = _currentFilePath;
    await close();

    if (pathToDelete != null) {
      try {
        final file = File(pathToDelete);
        if (await file.exists()) {
          await file.delete();
          print("Deleted file: $pathToDelete");
        } else {
          print("File to delete not found: $pathToDelete");
        }
      } catch (e) {
        print("Error deleting file $pathToDelete: $e");
      }
      if(_currentFilePath == pathToDelete) {
        _currentFilePath = null;
      }
    }
  }
}