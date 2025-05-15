---
title: "Quick Introduction"
permalink: /quick-intro/
date: 2025-04-23T00:26:20+01:00
classes: wide
read_time: true
sidebar:
  nav: "pages_sidebar_nav"
---

# Welcome to OSSMM!

**OSSMM** (Open-Source Sleep Monitor and Modulator) is the world's first 
open-source hardware and software system designed for both sleep monitoring 
and modulation.

<br>

# **The Goal:** 
OSSMM was created to address the prohibitive entry cost into 
quality sleep research. By providing researchers and sleep enthusiasts with an
affordable platform that can be assembled locally this accessible system 
promotes:

- Cost-effective large-scale, long-term sleep studies
- Data collection in participants' natural home environments
- Effective monitoring for under €40 per unit (as of 12/2024)[^note1]

**Most importantly, OSSMM enables sleep modulation experiments — filling a gap 
where no comparable off-the-shelf system currently exists.**


<br>
<div style="display: flex; flex-direction: row; align-items: flex-start;">
  <figure style="margin: 0; width: 42%;">
    <img src="{{ site.url }}/OSSMM/media/quick-intro/stretch.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">OSSMM Headband on display with strap fully stretched out.</figcaption>
  </figure>
  <figure style="margin: 0; width: 50%; margin-left: 4%;">
    <img src="{{ site.url }}/OSSMM/media/quick-intro/ports.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Macro photo of OSSMM Headband. USB-C, LED port, ON/Reset switch, and Microhone port are visible. €1 euro coin for size reference.</figcaption>
  </figure>
</div>
<br>
<br>

# Performance:

OSSMM promises to offer more accurate sleep staging than many commercial wearables 
(smart watches, rings) at a fraction of the price. 


*Note: OSSMM is currently under assessment for 4-stage sleep classification accuracy.*

<br>

# Key Design Features:

* **Reusable silicone wet-dry electrodes.** - no conductive gel needed
* **Quick-change parts** - easy repair and hygiene
* **Battery powered with no exposed wiring.** - 15+ hour run-time
* **Fully open-source hardware designs and software code.**
  - Complete access for researcher modifications
  - Full transparency of sleep staging algorithms and hardware code
  

*Note: An Android device[^note1] is required for data collection and is not included in the cost estimate.*

<br>

# Device Overview (V1.0.4)

In short, OSSMM consists of a wearable headband that collects physiological data
and transmits it wirelessly via Bluetooth Low Energy (BLE) to a dedicated 
Android application. Only Android is supported at this time.

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
<br>

## Benefits:

* **Minimal Design**: Just 11 components (excluding wires) for simplicity
* **Comfortable Electrodes**: Elastic band with integrated silicone wet-dry electrodes (commercial heart rate monitor strap)
* **Standard Electronics**: Four readily available off-the-shelf circuit boards
* **Locally Manufacturable Housing**: 3D printable design that can be produced anywhere with basic equipment
* **Convenient Power**: USB-C rechargeable battery for easy charging


## Technical Specifications:

* Dimensions: 79.1 x 45.2 x 30 mm  (3.114 x 1.780 x 1.181 in)
* Weight: 76.5 grams ( or 2.7 ounces with a 150 mAh battery)
* Sampling Frequency: 250 Hz (produces 500MB for 8 hour recording)
* Battery: 120-220 mAh (est. 15-27+ hour run time, sleep monitoring only)

## Physiological Measurements:

* Brain Activity: Frontal Electroencephalography (EEG)
* Eye Movement: Electrooculography (EOG)
* Head Movement: Via onboard Inertial Measurement Unit (IMU)
* Heart Rhythm: Photoplethysmography (PPG)

*Note: While the hardware includes a microphone for sound data collection, 
this feature is not activated in version 1.0.4.*

<br>

## Sleep Modulation Capabilities

OSSMM V1.0.4 incorporates a commercial off-the-shelf vibration motor 
(similar to those in mobile phones) as a stimulus mechanism for sleep 
modification experiments. The vibration motor was chosen as the reference 
stimulus because:

1. It demonstrates the system's robust power handling (60+ mA during operation)
2. It proves the platform can easily accommodate other stimulus methods 
including speakers, LEDs, tDCS, and tACS

Future versions aim to analyze sleep data in near-real-time 
(within 30-60 seconds) to potentially trigger sleep modulation 
based on detected sleep stages.

# Start Building Now

We recommend reviewing the 
[Getting Started](https://jvgiordano.github.io/OSSMM/getting-started/) before
beginning your OSSMM build. This page contains detailed information about OSSMM
and all the pre-requisites.

To build your own OSSMM system, follow these pages in order:

1. [3D Printables](https://jvgiordano.github.io/OSSMM/printables) - Print out the printable components
2. [Electronics Assembly Guide](https://jvgiordano.github.io/OSSMM/electronics-assembly/) - Combine the electronics and 3D printed case
3. [Major Parts Assembly](https://jvgiordano.github.io/OSSMM/final-assembly/) - Assemble the 3 principal components: headband, receiver, electronic case
4. [Software](https://jvgiordano.github.io/OSSMM/software/) - Upload OSSMM code to the MCU, and install the OSSMM apk on your Android device
5. [Final Checks & Completion](https://jvgiordano.github.io/OSSMM/final-checks) - Verify your OSSMM system collects data as intended

**Additional Notes:**

[^note1]: V1.0.4 requires an Android device with the dedicated companion app
to work. While currently requiring an Android device, any platform supporting 
high-priority BLE transmission could potentially work (iPhone, Raspberry Pi, etc.)
The cost estimate does not include the Android device.
