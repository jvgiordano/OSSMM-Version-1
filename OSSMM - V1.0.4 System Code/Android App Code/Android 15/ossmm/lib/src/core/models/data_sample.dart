// lib/src/core/models/data_sample.dart

class DataSample {
  final int transNum;
  final int accX;
  final int accY;
  final int accZ;
  final int gyroX;
  final int gyroY;
  final int gyroZ;
  final int eog;
  final int hr;
  final DateTime timestamp;

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

  factory DataSample.fromBytes(List<int> bytes) {
    if (bytes.length != 18) {
      // Consider logging this instead of throwing if partial data is possible
      print("Warning: Received ${bytes.length} bytes, expected 18 for DataSample. Ignoring.");
      throw ArgumentError('Byte list must contain exactly 18 bytes for DataSample');
    }
    // Using try-catch for potential range errors if list length check fails somehow
    try {
      return DataSample(
        transNum: bytes[0] + (256 * bytes[1]),
        eog:      bytes[2] + (256 * bytes[3]),
        hr:       bytes[4] + (256 * bytes[5]),
        accX:     bytes[6] + (256 * bytes[7]),
        accY:     bytes[8] + (256 * bytes[9]),
        accZ:     bytes[10] + (256 * bytes[11]),
        gyroX:    bytes[12] + (256 * bytes[13]),
        gyroY:    bytes[14] + (256 * bytes[15]),
        gyroZ:    bytes[16] + (256 * bytes[17]),
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print("Error parsing bytes for DataSample: $e");
      rethrow; // Rethrow after logging
    }
  }

  List<String> toCsvRow() {
    return [
      timestamp.toIso8601String(),
      transNum.toString(),
      eog.toString(),
      hr.toString(),
      accX.toString(),
      accY.toString(),
      accZ.toString(),
      gyroX.toString(),
      gyroY.toString(),
      gyroZ.toString(),
    ];
  }

  static List<String> get csvHeader => [
    'DateTime', 'transNum', 'eog', 'hr', 'accX', 'accY', 'accZ', 'gyroX', 'gyroY', 'gyroZ'
  ];
}

Iterable<DataSample> parseMultipleSamples(List<int> data) sync* {
  const sampleSize = 18;
  if (data.length % sampleSize != 0) {
    print("Warning: Received data length (${data.length}) is not a multiple of sample size ($sampleSize). Processing complete samples only.");
  }

  for (var i = 0; (i + sampleSize) <= data.length; i += sampleSize) {
    try {
      // Create a sublist defensively
      final sampleBytes = data.sublist(i, i + sampleSize);
      yield DataSample.fromBytes(sampleBytes);
    } catch (e) {
      // Log error but continue processing next potential sample
      print("Error parsing sample at index $i: $e. Skipping sample.");
    }
  }
}