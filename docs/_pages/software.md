---
title: "Software"
permalink: /software/
date: "2025-04-23"
read_time: true
classes: wide
toc: true # Enable Table of Contents for this page
sidebar:
  nav: "pages_sidebar_nav"
---

Congratulations on assembling your OSSMM headband! Now let's set up the software 
needed to bring it to life.

The OSSMM system requires two software components:

1. **Arduino Code for Headband** - Manages the sensors, data collection, and Bluetooth communication on the Seeed Xiao nRF52840 Sense microcontroller (MCU)
2. **Android Application** - Software that receives and stores the data Bluetooth stream while providing a user interface (UI) for system control

These instructions are provided using Windows 11, but the process follows the
same principles on macOS and Linux.


# Arduino Code for the OSSMM Headband

The OSSMM headband is powered by a Seeed Xiao nRF52840 Sense MCU, which performs
three critical functions:

1. Regulates power to all components
2. Digitizes analog sensor signals
3. Transmits collected data via Bluetooth Low Energy (BLE)

Before the headband can function, you must install the necessary Arduino 
code (a C++ variant) on to the MCU. 

This section provides step-by-step instructions for setting up the Arduino 
development environment and uploading the code. If you already have the Arduino
IDE installed, you can 
[skip directly to "Install the nRF52 Seeed Board Library"](https://jvgiordano.github.io/OSSMM/software/#install-the-seeed-nrf52-library).

## Install Arduino IDE

Arduino Integrated Development Environment (IDE) is a code-editor used for 
working with Arduino Code and associated libraries.

Please install the latest version from the [Arduino Website](https://www.arduino.cc/en/software ).


## Install the Seeed nRF52 Library and Configure for the Xiao Sense nRF52840 MCU

The Arduino IDE requires the Seeed nRF52 Library in to order to communicate and
compile code for the Xiao Sense MCU. Following the steps below to install this 
library and configure the Arduino IDE to be used with the MCU:

### Step 1. With the Arduino IDE open, go to 'File >> Preferences’

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-pref.jpg" style="width: 50%;">
</div>
&nbsp;

### Step 2. Go to go “Additional Boards Manager URLS” Section and paste in the following:

https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json

If you already have another Board Manager URL for a different library, use a ‘,’ to separate the URLS.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-json.JPG" style="width: 65%;">
</div>
&nbsp;

Exit the preferences window.

### Step 3. Go to 'Tools >> Board: "HelloWorld" >>  Board's Manager' to the ‘Boards Manager’. 
Type in the search bar at the top, ‘seeed nrf52’. Two board manager options 
should appear. Install the one that says “Seeed nRF52 Boards."

Note: Under Tools, "Board: " may be empty or contain other names. It does not matter.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-boards.jpg" style="width: 50%;">
</div>
&nbsp;

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-search.jpg" style="width: 50%;">
</div>
&nbsp;

### Step 4. Select 'Tools >> Board: "HelloWorld" >>  Seeed nRF52 Boards >> Seeed XIAO nRF52840 Sense'

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-seeed.jpg" style="width: 60%;">
</div>
&nbsp;

## Install the code to the MCU

Now that the Arduino IDE is configured for the the MCU, it's time to download
and install the code:

### Step 1. Download (or Clone with Git) the Arduino Code from the OSSMM Repository

The code is located under "Micronctroller Code" in the
[OSSMM - System Code](https://github.com/jvgiordano/OSSMM/tree/main/OSSMM%20-%20V1.0.4%20System%20Code) folder.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-location.jpg" style="width: 60%;">
</div>
&nbsp;

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-mcu.jpg" style="width: 60%;">
</div>
&nbsp;

### Step 2. Open the Arduino File with the Arduino IDE

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-code.jpg" style="width: 60%;">
</div>
&nbsp;

### Step 3. Connect the OSSMM Headband to your PC using a USB-C cable

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/ports.JPG" style="width: 50%;">
</div>
&nbsp;

### Step 4. Select 'Tools >> Port >>  COM_X_ (Seeed Xiao nRF52840 Sense)'

Where COM_X_ will be some port number (e.g., COM7)

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-port.jpg" style="width: 60%;">
</div>
&nbsp;

### Step 5. Click "Upload"

This will take some time as the code compiles, and then uploads to the MCU.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-upload.jpg" style="width: 60%;">
</div>
&nbsp;

### Step 6. Confirm Upload

Succesful code upload will show the following response in the Arduino IDE:

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-complete.jpg" style="width: 60%;">
</div>
&nbsp;

Congratulations! You're OSSMM headband is complete. Now it's time to install the
Android companion app!

## Android App Code


