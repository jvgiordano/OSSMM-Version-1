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

There is an Advanced section at the end for those interested in modifying the 
Android App. This is not required!


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
[skip directly to "Install the nRF52 Seeed Board Library"](https://jvgiordano.github.io/OSSMM/software/#install-the-seeed-nrf52-library-and-configure-for-the-xiao-sense-nrf52840-mcu).

## Install Arduino IDE

Arduino Integrated Development Environment (IDE) is a code-editor used for 
working with Arduino Code and associated libraries.

Please install the latest version from the [Arduino Website](https://www.arduino.cc/en/software ).


## Install the Seeed nRF52 Library and Configure for the Xiao Sense nRF52840 MCU

The Arduino IDE requires the Seeed nRF52 Library in to order to communicate and
compile code for the Xiao Sense MCU. Follow the steps below to install this 
library and configure the Arduino IDE to be used with the MCU:

### Step 1. With the Arduino IDE open, go to 'File >> Preferences’

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-pref.jpg" style="width: 50%;">
</div>
&nbsp;

### Step 2. Locate the “Additional Boards Manager URLS” Section and paste in the following:

https://files.seeedstudio.com/arduino/package_seeeduino_boards_index.json

If you already have another Board Manager URL for a different library, use a ‘,’ to separate the URLS.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-json.jpg" style="width: 65%;">
</div>
&nbsp;

Press "Ok" and exit the preferences window.

### Step 3. Go to 'Tools >> Board: >>  Board's Manager' and install Seeed nRF52 Board Manager.

First go to 'Tools >> Board: >>  Board's Manager' and click on Board's Manager.

Note: Under Tools, "Board: " may be empty or contain other names. It does not matter.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-boards.jpg" style="width: 50%;">
</div>
&nbsp;


In the search bar at the top, type ‘seeed nrf52’. Two board manager options 
should appear. Install the one that says “Seeed nRF52 Boards."

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-search.jpg" style="width: 50%;">
</div>
&nbsp;

### Step 4. Select 'Tools >> Board: >>  Seeed nRF52 Boards >> Seeed XIAO nRF52840 Sense'

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-seeed.jpg" style="width: 60%;">
</div>
&nbsp;

Great! Now the Arduino IDE has the proper software configurations to work with
the Seeed nRF52840 Sense. Now the IDE can interact with our board, we can upload
the MCU code on to it.

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
  <img src="{{ site.url }}/OSSMM/media/software/ports.jpg" style="width: 50%;">
</div>
&nbsp;


### Step 4. Select 'Tools >> Port >>  COM_X_ (Seeed Xiao nRF52840 Sense)'

Where COM_X_ will be some port number (e.g., COM7)

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/arduino-port.jpg" style="width: 60%;">
</div>
&nbsp;

This tells the Arduino IDE which port the MCU is connected to. Normally it
should automatically detect the port. 


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

# Install the Android App

The OSSMM system requires a companion app, designed for Android devices, to
function. The application performs three critical functions:

1. Provides a User Interface
2. Records data to storage
3. Provides Date-Time information 

This section provides step-by-step instructions for installing the Arduino apk
file onto an Android device. Please note, we used a PC running Windows 11 and
a Google Pixel 9 running Android 15 for this demo.

## Step 1. Connect your Android Device to a computer via USB with File Transfer Enabled

There are many methods to transfer files to Android devices, but a USB to 
computer is convenient and fast. We demonstrate this with a Windows 11 machine,
but this can be accomplished with Mac OS or Linux. If using Mac OS, you will
require a 3rd party File Transfer software [like this one](https://apps.apple.com/us/app/macdroid-manager-for-android/id1476545828?mt=12)


Ensure that "File Transfer" is enabled on your Android device so that the
internal memory can be accessed through your computer. You should be automatically
prompted to make this selection When you connect the Android device. 

Note: If you are not prompted or cannot access the internal memory, your USB
cable may only support power transfer and not data transfer. Try with another
cable. This may be true even for newer USB-C cables.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/usb-file-transfer.png" style="width: 25%;">
</div>
&nbsp;

## Step 2. Access your "Download" folder on your Android Device

Got to "This PC" >> Android Device >> Internal Shared Storage >> "Download"

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/access-download.gif" style="width: 70%;">
</div>
&nbsp;

Note: You may choose to use other folders, but we assume the "Download" folder
is used here.

## Step 3. Move the OSSMM APK to your Android Device

Move the OSSMM APK file from the repository to the "Download" folder on the 
Android device. You can disconnect the Android device from the computer when
the file transfer is complete.

**Please use the Android 15 or newer APK file**. The Android 9 APK is there for
historical posterity. The Android 15 APK contains significant updates, including
improved safety features.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/apk-transfer.png" style="width: 100%;">
</div>
&nbsp;

## Step 4. Open the "Files" app, navigate to "Download", and click on the "OSSMM-Installer"

On the Android device, open the "Files" app. This is a standard app for Android
and should come with any Android phone released after 2018. 

Inside the Files app, navigate to "Downloads". You will find the "OSSMM-Installer"
APK file there. Click on it, then accept the pop-up window which asks if you want
to install it.

If you are queried to perform a scan, please do so. 


<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/ossmm-install.gif" style="width: 25%;">
</div>
&nbsp

## Step 5. You've installed the OSSMM App!

You can now open the OSSMM app!

You will likely encounter a "System Requirements" screen first. Usage of the app 
requires both Bluetooth and Location settings to be enabled. 

Bluetooth is required because the app receives data wirelessly from the OSSMM 
headband via Bluetooth. Location is needed because it is an Android security 
requirement for Bluetooth scanning, not because the app actually uses location data.
Android requires this because BLE beacons can theoretically be used to determine
your location (like in stores or museums), so Google mandates location permission
as a privacy protection measure for all apps that scan for Bluetooth devices. The 
OSSMM headband and app DO NOT collect any kind of location information.


# (Advanced Only) Editing Android Application

If you are interested in editing the Android application for your own research, 
we briefly outline the set-up requirements for doing so. Please note, these are 
the general steps which must be undertaken and not a step-by-step guide on how 
to modify the files. Modifying these files requires some familiarity of
(or willingness to learn) dart.

## Step 1 - Install Android Studio IDE

You can install the latest version of [Android Studio here](https://developer.android.com/studio)

## Step 2 - Install Flutter SDK

Go to [this link](https://docs.flutter.dev/get-started/install) for Flutter Installation.

## Step 3 - Install Java

Go to [this link](https://www.java.com/en/download/help/download_options.html)) for Java Installation instructions.

## Step 5 - Configure Flutter and Dart Plugin for Android Studio in Settings

## Step 6 - Download (or pull) the OSSMM App Files

These are located under "\OSSMM\OSSMM - V1.0.4 System Code\Android App Code\Android 15"
in a folder called "ossmm"

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/android-app-code.png" style="width: 60%;">
</div>
&nbsp

## Step 7 - Open the Project with Android Studio

## Step 8 - Locate modifiable Android app code within project:

For Android 15 and above, pertinent files are located under the "\ossmm\lib" 
directory: 

Full Directory: "OSSMM\OSSMM - V1.0.4 System Code\Android App Code\Android 15\ossmm\lib"

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/software/android-studio-files.png" style="width: 60%;">
</div>
&nbsp

There are 10 .dart files at the time of publishing (May 13th, 2025). This is
likely to expand as more features are developed for the application (e.g., 
active sleep staging, automated sleep modulation)
