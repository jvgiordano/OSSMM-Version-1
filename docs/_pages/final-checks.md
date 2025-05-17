---
title: "Final Checks"
permalink: /final-checks/
date: "2020-05-16"
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

To verify your OSSMM system we will run through the protocol shown in the
following GIF. The individual steps are described below:

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/long-demo.gif" alt="Front view of OSSMM headband" style="width: 30%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">Basic Verification Demo</figcaption>
</figure>
<br>

## Step 1. Turn on the OSSMM headband by pressing the ON/RESET button on the front face.

a. There should be a slight click when pressing the ON/RESET button down.
b. Hold the button for 1 second ("One Mississippi").
b. The blue LED will flash several times during start-up.
 
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/buttons.jpg" alt="Front view of OSSMM headband" style="width: 40%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">OSSMM Headband ON/Reset and Notification LED placements</figcaption>
</figure>
<br>
 
## Step 2. Put on the OSSMM headband.
<br>
## Step 3. Open the OSSMM app on your Android device.
<br>

## 4. Enable the BLE and Location requirements.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/requirements.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">System Requirements Screen</figcaption>
</figure>
<br>

## Step 5. To bond the app and headband, go to Settings >> Find Device.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/find-device.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">"Find Device" is in the collapsible Settings section.</figcaption>
</figure>
<br>

##Step 6. Connect the OSSMM device.
 a. The green LED will flash several times for a successful connection.
 
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/connect.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">Bluetooth Devices Scan Screen</figcaption>
</figure>

## Step 7. Move to the Live Data section (this should open automatically)
<br>

## Step 8. View the Accelerometer and Gyroscope and verify plots show turning of the head.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/acc-gyro.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">Accelerometer and Gyroscope Plots in the Live Data Section. Arrows point to distinct head turns, hence separate colors in the gyroscope plot.</figcaption>
</figure>
<br>

## Step 9. View the EOG section, and verify eye movement is detected with side-to-side saccades or roll your eyes.

In the plot below you can observe left-right saccade, right-left saccade, and clock-wise eye movement.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/eog.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">Eye Movement (EOG) plot in Live Data section. Arrows point to distinct eye movements: left-right saccade, right-left saccade, eye rolling.</figcaption>
</figure>
<br>


## Step 10. View the Heart Rate plot to see that your pulse is being detected.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/pulse.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">Pulse plot in the Live Data section. Each spike shows a heart beat. The EKG 'T Wave' is visible as a low bump after each spike. </figcaption>
</figure>
<br>

## Step 11. Press "Stop Recording and Turn Off"

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/stop.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">"Stop Recording and Turn Off" button on the OSSMM Dashboard during active Recording. </figcaption>
</figure>
<br>

# Bluetooth Bonding Verification

This will confirm the app has bonded to the OSSMM headband. Complete this after
"Basic Verification Procedure" and with the same OSSMM headband. BLE pairing
is specific to each headband and the "Reconnect" option will only work for that
bonded device.

## Step 1. Press "Reconnect and Record"
 a. The green LED will flash several times for a successful connection.
 
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/reconnect.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">"Reconnect and Record" button on the OSSMM dashboard. This button is only available after an OSSMM headband has bonded with the app.</figcaption>
</figure>
 
## Step 2. Verify the "Live Data" plot function correctly
## Step 3. Press "Stop Recording and Turn Off"

# Verify Data Saving and Encryption:

The following GIF shows the protocol for verifying data is being saved and
encrypted correctly. Individual steps are listed below:

Follow the video below for a demonstration:
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/decryption.gif" alt="Front view of OSSMM headband" style="width: 85%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">Decryption Protocol</figcaption>
</figure>

## Step 1. Connect the Android Device to a computer

Make sure "File Transfer/Android Auto" is enabled.

<br>
## Step 2. Access the internal file system and navigate to "Documents/OSSMM" on the Android device

<br>
## Step 3. Select the ZIP file corresponding to the time of your verification recording

<br>
## Step 4. Import the ZIP file to your computer, and open with appropriate decompression tool (WinRAR is recommended for Windows)

Note: Standard Windows extraction will not work. Winrar is "free".

<br>
## Step 5. Use the password under "Data Protection" >> "View Data Access Password" in the app


<br>
<figure style="display: inline-block; width: 30%; margin: 0 2%; text-align: center; vertical-align: top;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/data-protection.png" alt="Front view of OSSMM headband" style="width: 100%; display: block;">
  <figcaption style="font-style: italic; margin-top: 5px;">"View Data Access Password" in the Data Protection Section.</figcaption>
</figure>
<figure style="display: inline-block; width: 30%; margin: 0 2%; text-align: center; vertical-align: top;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/password.png" alt="Front view of OSSMM headband" style="width: 100%; display: block;">
  <figcaption style="font-style: italic; margin-top: 5px;">Semi-randomly generated OSSMM password for encrypted recording files.</figcaption>
</figure>
<br>

Note: Each time the application is installed, a new encryption password is
semi-randomly generated. This can be modified within the Android app code, so
that a chosen password is used instead.

<br>
# Advanced Verification - if interested in sleep modulation:

(After following the connection/reconnection steps above)

## Step 1. Go to "Sleep Modulation" and enable

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-checks/modulation.png" alt="Front view of OSSMM headband" style="width: 20%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="font-style: italic; margin-top: 5px; text-align: center;">"Modulation Mode" Toggle and "Test" button in Sleep Modulation section.</figcaption>
</figure>
<br>

## Step 2. Press Test Modulation during the connection
   - The OSSMM headband should vibrate in a double "blinky" pattern (On-Off...On-Off)