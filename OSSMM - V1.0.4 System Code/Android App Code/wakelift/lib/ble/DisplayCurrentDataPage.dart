/* ----------------------------------------------------------------
    IMPORT PACKAGES and PAGES
   ----------------------------------------------------------------
*/

import 'package:flutter/material.dart';
import 'package:wakelift/ble/BackgroundRecordingTask.dart';

import 'package:wakelift/helpers/LineChart.dart';
import 'package:wakelift/helpers/PaintStyle.dart';



class DisplayCurrentDataPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BackgroundRecordingTask task =
    BackgroundRecordingTask.of(context, rebuildOnChange: true);

    // Arguments shift is needed for timestamps as miliseconds in double could loose precision.
    final int argumentsShift =
        task.samples.first.timestamp.millisecondsSinceEpoch;

    final Duration showDuration =
    Duration(seconds: 20); // @TODO . show duration should be configurable
    final Iterable<DataSample> lastSamples = task.getLastOf(showDuration);

    final Iterable<double> arguments = lastSamples.map((sample) {
      return (sample.timestamp.millisecondsSinceEpoch - argumentsShift)
          .toDouble();
    });

    // Step for argument labels
    final Duration argumentsStep =
    Duration(minutes: 15); // @TODO . step duration should be configurable

    // Find first timestamp floored to step before
    final DateTime beginningArguments = lastSamples.first.timestamp;
    DateTime beginningArgumentsStep = DateTime(beginningArguments.year,
        beginningArguments.month, beginningArguments.day);
    while (beginningArgumentsStep.isBefore(beginningArguments)) {
      beginningArgumentsStep = beginningArgumentsStep.add(argumentsStep);
    }
    beginningArgumentsStep = beginningArgumentsStep.subtract(argumentsStep);
    final DateTime endingArguments = lastSamples.last.timestamp;

    // Generate list of timestamps of labels
    final Iterable<DateTime> argumentsLabelsTimestamps = () sync* {
      DateTime timestamp = beginningArgumentsStep;
      yield timestamp;
      while (timestamp.isBefore(endingArguments)) {
        timestamp = timestamp.add(argumentsStep);
        yield timestamp;
      }
    }();

    // Map strings for labels
    final Iterable<LabelEntry> argumentsLabels =
    argumentsLabelsTimestamps.map((timestamp) {
      return LabelEntry(
          (timestamp.millisecondsSinceEpoch - argumentsShift).toDouble(),
          ((timestamp.hour <= 9 ? '0' : '') +
              timestamp.hour.toString() +
              ':' +
              (timestamp.minute <= 9 ? '0' : '') +
              timestamp.minute.toString()));
    });

    return Scaffold(
        appBar: AppBar(
          title: Text('Collected data'),
          actions: <Widget>[]
            /*
            // Progress circle
            (task.inProgress
                ? FittedBox(
                child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white))))
                : Container(/* Dummy */)),
            // Start/stop buttons
            (task.inProgress
                ? IconButton(icon: Icon(Icons.pause), onPressed: task.pause)
                : IconButton(
                icon: Icon(Icons.play_arrow), onPressed: task.reasume)),
          ],

             */
        ),
        body: ListView(
          children: <Widget>[
            const Divider(),
            const ListTile(
              leading: Icon(Icons.memory),
              title: Text('Accelerometer'),
              subtitle: Text('Range = [0, 1600], Zeroed Value = 800'),
           ),
            /// FOR DEBUGGING PURPOSES, HERE ARE ACC, GYRO, EOG PLOTS
            LineChart(
              constraints: const BoxConstraints.expand(height: 350),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.accX.toDouble()),
                lastSamples.map((sample) => sample.accY.toDouble()),
                lastSamples.map((sample) => sample.accZ.toDouble()),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: const [
                null,
                null,
                //const PaintStyle(style: PaintingStyle.stroke, strokeWidth: 1.7*3, color: Colors.indigo, strokeCap: StrokeCap.round),
              ],
              seriesLinesStyles: const [
                PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 4,
                    color: Colors.indigoAccent),
                PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 4,
                    color: Colors.pink),
                PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 4,
                    color: Colors.black),

              ],
            ), // PLOT FOR ACCELEROMETER
            Divider(),
            const ListTile(
              leading: Icon(Icons.memory),
              title: Text('Gyroscope'),
              subtitle: Text('Range = [0, 4000], Zeroed value = 2000'),
            ),
            LineChart(
              constraints: const BoxConstraints.expand(height: 350),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.gyroX.toDouble()),
                lastSamples.map((sample) => sample.gyroY.toDouble()),
                lastSamples.map((sample) => sample.gyroZ.toDouble()),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: const [
                null,
                null,
                //const PaintStyle(style: PaintingStyle.stroke, strokeWidth: 1.7*3, color: Colors.indigo, strokeCap: StrokeCap.round),
              ],
              seriesLinesStyles: const [
                PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 4,
                    color: Colors.indigoAccent),
                PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 4,
                    color: Colors.pink),
                PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 4,
                    color: Colors.black),

              ],
            ), // PLOT FOR GYROSCOPE
            Divider(),
            ListTile(
              leading: const Icon(Icons.memory),
              title: const Text('EOG'),
              subtitle: const Text('Eye Movement Data'),
            ),
            LineChart(
              constraints: const BoxConstraints.expand(height: 350),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.eog.toDouble()),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: const [
                null,
                null,
                //const PaintStyle(style: PaintingStyle.stroke, strokeWidth: 1.7*3, color: Colors.indigo, strokeCap: StrokeCap.round),
              ],
              seriesLinesStyles: const [
                PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 4,
                    color: Colors.indigoAccent),
              ],
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.memory),
              title: const Text('Heart Rate'),
              subtitle: const Text('Pulse Sensor Data'),
            ),
            LineChart(
              constraints: const BoxConstraints.expand(height: 350),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.hr.toDouble()),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: const [
                null,
                null,
                //const PaintStyle(style: PaintingStyle.stroke, strokeWidth: 1.7*3, color: Colors.indigo, strokeCap: StrokeCap.round),
              ],
              seriesLinesStyles: const [
                PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 4,
                    color: Colors.pink),

              ],
            ),
          ],
        ));


  }
}
