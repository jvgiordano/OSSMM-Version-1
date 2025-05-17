---
title: "Final Checks"
permalink: /final-checks/
date: "2025-05-16"
classes: wide
read_time: true
sidebar:
  nav: "pages_sidebar_nav"
---

You've assembled the OSSMM system! Now let's verify that it works as intended:

# Basic Verification Procedure

Requisites:
1. Android Device with OSSMM App
2. OSSMM Headband
3. Both devices are charged

To verify your OSSMM system we will run through the following protocol:

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/long-demo.gif" alt="Front view of OSSMM headband" style="width: 30%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Basic Verification Demo</figcaption>
</figure>


## Step 1. Turn on the OSSMM headband by pressing the ON/RESET button on the front face.

a. There should be a slight click when pressing the ON/RESET button down.
b. Hold the button for 1 second ("One Mississippi").
b. The blue LED will flash several times during start-up.
 
<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/buttons.jpg" alt="Front view of OSSMM headband" style="width: 40%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">OSSMM Headband ON/Reset and Notification LED placements</figcaption>
</figure>
 
2. Put on the OSSMM headband.
3. Open the OSSMM app on your Android device.
4. Enable the BLE and Location requirements.

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/requirements.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">System Requirements Screen</figcaption>
</figure>

5. To bond the app and headband, go to Settings >> Find Device.

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/find-device.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">"Find Device" is in the collapsible Settings section.</figcaption>
</figure>

6. Connect the OSSMM device.
 a. The green LED will flash several times for a successful connection.
 
<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/connect.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Bluetooth Devices Scan Screen</figcaption>
</figure>

7. Move to the Live Data section
8. View the Accelerometer and Gyroscope and verify plots show turning of the head.

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/acc-gyro.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Accelerometer and Gyroscope Plots in the Live Data Section. Arrows point to distinct head turns, hence separate colors in the gyroscope plot.</figcaption>
</figure>

9. View the EOG section, and verify eye movement is detected with side-to-side saccades or roll your eyes.

In the plot below you can observe left-right saccade, right-left saccade, and clock-wise eye movement.

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/eog.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Eye Movement (EOG) plot in Live Data section. Arrows point to distinct eye movements: left-right saccade, right-left saccade, eye rolling.</figcaption>
</figure>

10. View the Heart Rate plot to see that your pulse is being detected.

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/pulse.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Pulse plot in the Live Data section. Each spike shows a heart beat. The EKG 'T Wave' is visible as a low bump after each spike. </figcaption>
</figure>

11. Press "Stop Recording and Turn Off"

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/stop.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">"Stop Recording and Turn Off" button on the OSSMM Dashboard during active Recording. </figcaption>
</figure>


# Bluetooth Bonding Verification

This will confirm the app has bonded to the OSSMM headband. Complete this after
"Basic Verification Procedure" and with the same OSSMM headband. BLE pairing
is specific to each headband and the "Reconnect" option will only work for that
bonded device.

1. Press "Reconnect and Record"
 a. The green LED will flash several times for a successful connection.
 
<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/reconnect.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">"Reconnect and Record" button on the OSSMM dashboard. This button is only available after an OSSMM headband has bonded with the app.</figcaption>
</figure>
 
2. Verify the "Live Data" plot function correctly
3. Press "Stop Recording and Turn Off"

# Verify Data Saving and Encryption:

1. Connect the Android Device to a computer
2. Access the internal file system and navigate to "Documents/OSSMM" on the Android device
3. Select the ZIP file corresponding to the time of your verification recording
4. Import the ZIP file to your computer, and open with appropriate decompression tool (WinRAR is recommended for Windows)
5. Use the password under the "Data Protection" >> View Data Access Password in the app

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/data-protection.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">"View Data Access Password"  in the Data Protection Section.</figcaption>
</figure>

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/password.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Semi-randomly generated OSSMM password for encrypted recording files.</figcaption>
</figure>


Follow the video below for a demonstration:
<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/shortening-cut-1.jpg" alt="Front view of OSSMM headband" style="width: 40%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Verification Demo</figcaption>
</figure>

Note: Each time the application is installed, a new encryption password is
semi-randomly generated. This can be modified within the Android app code, so
that a chosen password is used instead.

# Advanced Verification - if interested in sleep modulation:

(After following the steps above)

1. Go to "Sleep Modulation" and enable

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-checks/modulation.png" alt="Front view of OSSMM headband" style="width: 25%; display: block; margin: 0 auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">"Modulation Mode" Toggle and "Test" button in Sleep Modulation section.</figcaption>
</figure>

2. Press Test Modulation during the connection
   - The OSSMM headband should vibrate in a double "blinky" pattern (On-Off...On-Off)