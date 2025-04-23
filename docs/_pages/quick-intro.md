---
title: "Quick Introduction"
permalink: /quick-intro/
date: 2025-04-23T00:26:20+01:00
classes: wide
toc: true # Enable Table of Contents for this page
sidebar:
  nav: "pages_sidebar_nav"
---

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
    <img src="{{ site.url }}/OSSMM/media/quick-intro/front.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Fig 1: Front of the OSSMM headband compared with a €1 coin.</figcaption>
  </figure>
  <figure style="margin: 0; width: 50%; margin-left: 4%;">
    <img src="{{ site.url }}/OSSMM/media/quick-intro/back.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Fig 2: Back of the OSSMM headband, with the silicone electrodes and PPG sensor visible.</figcaption>
  </figure>
</div>
<br><br>

The headband comprises:

* **11 Components** (Total part count excluding wires)
* **3D Printed Housing**
* **Four Commercial-Off-The-Shelf Boards**
* **USB-C Rechargeable Battery**
* **Electrode Head Band** (Elastic band with integrated silicone wet-dry 
electrodes, commercially available as a 'heart rate monitor strap')

Specifications:

* **Dimensions: 79.1 x 45.2 x 30 mm** (3.114 x 1.780 x 1.181 in)
* **Weight: 76.5 grams** ( or 2.7 ounces with a 150 mAh battery)
* **Sampling Frequency: up to 250Hz** (produces 500MB for 8 hour recording)
* **Battery: 120-220 mAh** (est. 15-27+ hour run time, sleep monitoring only)

The device currently collects the following data:

* **Brain Signatures**: Frontal Electroencephalography (EEG)
* **Eye Movement**: Electrooculography (EOG)
* **Head Movement**: Via onboard Inertial Measurement Unit (IMU)
* **Pulse**: Photoplethysmography (PPG)

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