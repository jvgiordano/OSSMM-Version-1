---
title: "Software"
permalink: /software/
date: "2025-04-23"
read_time: true
classes: wide
---

# Software Installation

Congratulations on assembling your OSSMM headband! Now let's set up the software 
needed to bring it to life.

The OSSMM system requires two software components:

1. **Arduino Code for Headband** - Manages the sensors, data collection, and Bluetooth communication on the Seeed Xiao nRF52840 Sense microcontroller (MCU)
2. **Android Application** - Software that receives and stores the data Bluetooth stream while providing a user interface (UI) for system control

These instructions are provided using Windows 11, but the process follows the
same principles on macOS and Linux.


# Microcontroller Code


# Arduino Code for the OSSMM Headband

The OSSMM headband is powered by a Seeed Xiao nRF52840 Sense MCU, which performs
three critical functions:

1. Regulates power to all components
2. Digitizes analog sensor signals
3. Transmits collected data via Bluetooth Low Energy (BLE)

Before the headband can function, you must install the necessary Arduino 
code (a C++ variant) on the MCU. 

This section provides step-by-step instructions for setting up the Arduino 
development environment and uploading the code. If you already have the Arduino
IDE installed, you can 
[skip directly to "Install the Seeed Board Library"](https://jvgiordano.github.io/OSSMM/software/#install-the-seeed-nrf52-library).

## Install Arduino IDE

Arduino Integrated Development Environment (IDE) is a code-editor used for 
working with Arduino Code and associated libraries.

Please install the latest version from the [Arduino Website](https://www.arduino.cc/en/software ).


## Install the Seeed nRF52 Library

1. With the Arduino IDE installed, go to 'File >> Preferences’

<div align="center">
  <p><strong>Side with USB-C:</strong></p>
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/arduino-pref.jpg" style="width: 50%;">
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

Note: Under Tools, "Board: " may be empty or contain other names. It does not matter.

<div align="center">
  <p><strong>Side with USB-C:</strong></p>
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/arduino-boards.jpg" style="width: 50%;">
</div>

<div align="center">
  <p><strong>Side with USB-C:</strong></p>
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/arduino-search.jpg" style="width: 50%;">
</div>



## Android App Code
