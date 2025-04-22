<meta http-equiv='cache-control' content='no-cache'> 
<meta http-equiv='expires' content='0'> 
<meta http-equiv='pragma' content='no-cache'>

# **O**pen-**S**ource **S**leep **M**onitor and **M**odulator (OSSMM)

## THIS REPOSITORY IS A WORK IN PROGRESS! PLEASE REFRAIN FROM USAGE UNTIL THIS TEXT IS REMOVED (Aprl 17th, 2025)

### Table of Contents

The full guide provides the necessary information to build, set up, and 
understand the OSSMM System. Please follow the sections below in order:

0.  **[Quick Intro (this page)](index.md)**
1.  **[Full Introduction and Prerequisites](01-introduction.md)**: Detailed introduction and requirement list of software, tools, components, and background skills.
2.  **[3D Printables](02-printables.md)**: Instructions for printing the device's 3D printed parts.
3.  **[Electronics Assembly](03-electronics-assembly.md)**: Step-by-step guide for soldering and assembling the electronic hardware components.
4.  **[Final Assembly](04-final-assembly.md)**: Integrating the electronics into the parts, and attaching the headband.
5.  **[Software Setup & Completion](05-software.md)**: Instructions for uploading code onto the microcontroller (MCU), setting up the smartphone application and final checks.

## Quick Intro

Welcome! We present **OSSMM**, an **O**pen-**S**ource **S**leep **M**onitor and **M**odulator platform.
The world's first open-source hardware and software system for sleep monitoring and modulation!

The goal of OSSMM is to provide researchers and sleep enthusiasts with an 
affordable platform for conducting sleep research which can be built in the 
"home" lab. This cost-effective solution and local assembly encourages larger and
longer scale sleep research.  It is a cost-effective solution for reaching 
numerous participants, while permitting data collection within their natural 
home environment.

The OSSMM headband can be built for below below €40 (as of 12/2024)! All 
components are either commercially available at affordable prices, or 
3D printed. However, this cost does not include the Android device* required
for data collection.

This system aims to assess sleep staging more accurately than many commercially 
available devices, like smart watches and rings, at a fraction of the cost. 

**Importantly, OSSMM is designed to permit researchers and enthusiasts to conduct
sleep modulation experiments, addressing a gap where no comparable system is
currently available off-the-shelf.**

*The system currently requires an Android device for data collection. In theory,
any device which supports high priority BLE transmission can be made to work.

*OSSMM is currently under assessment for 4-stage sleep classification accuracy.*

Key design considerations for OSSMM include:

* **Reusable silicone wet-dry electrodes.** (no conductive gel needed)
* **Quick-change parts for easy repair and hygiene.**
* **Battery powered with no exposed wiring.** (est. 15+ hour run-time)
* **Fully open-source hardware designs and software code.**
  - Full access for researcher desired modification.
  - Full transparency of code and classification algorithms used for sleep staging.
  
  
## Device Overview (V1.0.4)

In short, OSSMM consists of a wearable headband that collects physiological data
and transmits it wirelessly via Bluetooth Low Energy (BLE) to a dedicated 
smartphone application. Only Android is supported at this time.

<div style="display: flex; flex-direction: row; align-items: flex-start;">
  <figure style="margin: 0; width: 45%;">
    <img src="media/index/front.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Fig 1: Front of the OSSMM headband compared with a €1 coin.</figcaption>
  </figure>
  <figure style="margin: 0; width: 50%; margin-left: 4%;">
    <img src="media/index/back.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Fig 2: Back of the OSSMM headband, with the silicone electrodes and PPG sensor visible.</figcaption>
  </figure>
</div>
<br><br>

The headband comprises:

* **11 Components** (Total part count excluding wires)
* **3D printed housing**
* **Four Commercial-Off-The-Shelf boards**
* **USB-C Rechargeable battery**
* **Electrode head band** (Elastic band with integrated silicone wet-dry 
electrodes, commercially available as a 'heart rate monitor strap')

Specifications:

* **Dimensions: 79.1 x 45.2 x 30 mm** (3.114 x 1.780 x 1.181 in)
* **Weight: 76.5 grams** ( or 2.7 ounces with a 150 mAh battery)
* **Sampling Frequency: up to 250Hz** (produces 500MB for 8 hour recording)
* **Battery: 120-220 mAh** (est. 15-27.5 hour run time of only sleep monitoring)

The device currently collects the following data:

* **Head movement**: Via onboard Inertial Measurement Unit (IMU)
* **Eye movement**: Electrooculography (EOG)
* **Brain signatures**: Frontal Electroencephalography (EEG)
* **Heart rate**: Photoplethysmography (PPG)

Additional Notes:

While the hardware supports sound data collection via a microphone, this feature 
is not activated in version 1.0.4.

Collected data is transmitted via BLE to a smartphone running the OSSMM app. 
The app stores the raw data locally. Future versions aim to analyze data in 
near-real-time (e.g. after 1-2 epochs, or 30-60seconds) to potentially trigger 
sleep modulation if desired within the experimental protocol.

OSSMM V1.0.4 uses a COTS vibration motor (similar to those in mobile phones) as 
a stimulus mechanism for sleep modification experiments. The vibration motor 
serves as an ideal example stimulus from an engineering perspective due to its 
heavy power demands. 

In other words, since the system can successfully handle a vibration motor that 
consumes large amounts of current during operation (+60 mA), it can easily 
accommodate other stimulus methods: speaker, LEDs, tDCS, and tACS.

Although we initially demonstrate support for Android devices 
(smartphones, tablets) via a dedicated app, any device which supports high 
priority BLE transmissions can be used to record data. Therefore it should be
possible to work with iPhone, Raspberry Pi, etc.

## Documentation Guide

This documentation provides the necessary information to build, set up, and 
understand the OSSMM V1.0.4. Please follow the sections below in order:

0.  **[Quick Intro (this page)](index.md)**
1.  **[Full Introduction and Prerequisites](01-introduction.md)**: Detailed introduction and requirement list of software, tools, components, and background skills.
2.  **[3D Printables](02-printables.md)**: Instructions for printing the device's 3D printed parts.
3.  **[Electronics Assembly](03-electronics-assembly.md)**: Step-by-step guide for soldering and assembling the electronic hardware components.
4.  **[Final Assembly](04-final-assembly.md)**: Integrating the electronics into the parts, and attaching the headband.
5.  **[Software Setup & Completion](05-software.md)**: Instructions for uploading code onto the microcontroller (MCU), setting up the smartphone application and final checks.

## Safety Considerations

User safety was a fundamental priority throughout the development of OSSMM. 
The design incorporates several important safety features:

* **Low-voltage electronics**: All electronic components are commercially 
available, hobbyist-grade parts commonly used in wearable maker projects. The 
system operates entirely on low voltage (3.3V), minimizing electrical risks.

* **Limited battery capacity**: The small-capacity battery (120-220 mAh) 
significantly reduces potential risks associated with battery malfunctions.

* **Non-invasive sensors**: With the exception of the pulse sensor, all 
measurement systems are passive. The pulse sensor uses photoplethysmography 
(PPG) - the same light-based technology found in consumer smartwatches - which
emits only low-intensity light to detect blood flow beneath the skin. At no
point is current injected into the body

* **Biocompatible materials**: We selected specific 3D printing filaments based 
on their published safety data to ensure skin contact compatibility. Safety 
data sheets for all components and filaments are included in this repository 
for your reference.

While we've made every effort to design a safe system, users assume 
responsibility for their implementation. We cannot be held liable for any use,
misuse, or adverse events resulting from the construction or operation of an 
OSSMM system. It remains the user's responsibility to properly assemble their
device using appropriate components from reputable sources and to ensure proper
operation. This is not a medical device.

## Data Privacy and Security

OSSMM was designed with data protection in mind: 

* **Secure BLE connection**: The app-to-device BLE connection requires 
verification of 3 unique UUIDs before data transmission occurs.

* **User-customizable security**: Each user can modify these UUID values to 
create their own unique security "profile".

* **Local data storage**: All data collected by OSSMM is stored locally on a 
companion Android device in a dedicated "/OSSMM" directory. No data is 
automatically transmitted to external servers or cloud services, unless you 
choose to do so.

* **Device security recommendations**: Due to the nature of sleep and 
physiological data, we recommend that companion devices used with OSSMM be 
secured with PIN codes or other access controls.

---
*Current Version: V1.0.4*