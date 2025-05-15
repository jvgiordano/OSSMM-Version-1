---
title: "Final Checks"
permalink: /final-checks/
date: "2025-04-23"
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

To verify your OSSMM system:

1. Turn on the OSSMM headband byu pressing the ON/RESET button on the front face.
2. Put on the OSSMM headband.
3. Open the OSSMM app on your Android device.
4. Enable the BLE and Location requirements.
5. Go to Settings >> Find Device.
6. Connect the the OSSMM device.
7. Move to the Live Data section
8. Move your head and confirm the Accelerometer and Gyroscope plots show your movement.
9. Quickly move your eyes left-to-right, right-to-left, or in circles to verify your eye movement is detected.
10. View the Heart Rate plot to see that your pulse is being detected.
11. Press "Stop Recording and Turn Off"

Follow the video below for a demonstration:

<figure>
  <img src="{{ site.url }}/OSSMM/media/final-assembly/shortening-cut-1.jpg" alt="Front view of OSSMM headband" style="width: 40%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Verification Demo</figcaption>
</figure>


&nbsp;
# Bluetooth Bonding Verification

(after completing "Basic Verification Procedure" and using the same OSSMM headband)

1. Press "Reconnect and Record"
2. Verify "Live Data" plots correctly
3. Press "Stop Recording and Turn Off"

Note: The app will pair to a specific headband, and the "Reconnect" option will
only work for that bonded device.


&nbsp;
# Verify Data Saving and Encryption:


1. Connect the Android Device to a computer
2. Access the internal file system and navigate to Documents/OSSMM on the Android device
3. Select the ZIP file corresponding to the time of your verification recording
4. Import the ZIP file to your computer, and open with appropriate decompresser (WinRAR is recommended for Windows)
4. Use the password under the "Data Protection" >> View Data Access Password in the app


Note: Each time the application is instead, a new encryption password is
semi-randomly generated. This can be modified within the Android app code, so
that a chosen password is used instead.

&nbsp;
# Advanced Verification - if interested in sleep modulation:

(After following the steps above)

1. Go to "Sleep Modulation" and enable
2. Press Test Modulation during the connection
   - The OSSMM headband should vibrate in a double "blinky" pattern (On-Off...On-Off)
