---
title: "Software"
permalink: /software/
date: "2025-04-23"
read_time: true
classes: wide
---

# Software

You've assembled the OSSMM headband. Not let's install the software to use it!

The OSSMM system requires two pieces of software to work. The software that
controls the headband, and the software which controls the Android device.

We provide instructions using Windows 11, however both Mac and Linux should
have similar set-ups.

# Microcontroller Code

OSSMM uses a Seeed Xiao nRF52840 Sense microcontroller unit (MCU) to manage 
operations. These operations are primarily to regulate power to other components,
digitize analog signals from the sensors, and transmit this information over BLE.
To perform these operations, the MCU requires dedicated software, and this 
software must be loaded onto the MCU before it can be used. This software is 
written using Arduino code, a variant of C++, and uses a library from the 
manufacturer Seeed. 

In this section directions are provided on how to upload this software from 
scratch. However, if you already have the Arduino IDE installed, please skip 
below to “Install the Seeed Board Library.”

## Install Arduino IDE

Arduino Integrated Development Environment (IDE) is a code-editor used for 
working with Arduino Code and associated libraries.

Please install the latest version from the [Arduino Website](https://www.arduino.cc/en/software ).


## Install the Seeed nRF52 Library

1. With the Arduino IDE installed, go to 'File >> Preferences’

<div align="center">
  <p><strong>Side with USB-C:</strong></p>
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/arduino-pref.jpeg" style="width: 50%;">
</div>

2. Go to go “Additional Boards Manager URLS” Section and paste in the following:

https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json

If you already have another Board Manager URL for a different library, use a ‘,’ to separate the URLS.

<div align="center">
  <p><strong>Side with USB-C:</strong></p>
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/arduino-json.jpeg" style="width: 50%;">
</div>

Exit the preferences window.

3. 'Tools >> Board: "HelloWorld" >>  Board's Manager' to the ‘Boards Manager’. 
Type in the search bar at the top, ‘seeed nrf52’. Two board manager options 
should appear. Install the one that says “Seeed nRF52 Boards."

<div align="center">
  <p><strong>Side with USB-C:</strong></p>
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/arduino-boards.jpeg" style="width: 50%;">
</div>

<div align="center">
  <p><strong>Side with USB-C:</strong></p>
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/arduino-search.jpeg" style="width: 50%;">
</div>




## Android App Code
