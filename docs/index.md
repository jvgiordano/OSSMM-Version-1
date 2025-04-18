# **O**pen-**S**ource **S**leep **M**onitor and **M**odulator (OSSMM)

## THIS REPOSITORY IS A WORK IN PROGRESS! PLEASE REFRAIN FROM USAGE UNTIL THIS TEXT IS REMOVED (Aprl 17th, 2025)

## Introduction

Welcome! We present **OSSMM**, an **O**pen-**S**ource **S**leep **M**onitor and **M**odulator platform. This is the world's first open-source sleep monitoring and modulation platform

The goal of OSSMM is to provide researchers and sleep enthusiasts with an affordable hardware and software platform for conducting sleep research which can be built at the "home" lab. This cost-effective solution and local assembly encourages research across numerous participants within their natural home environment.

The target cost of OSSMM is below €40 (as of 12/2024) and we have achieved this! All components used are either commercially available at affordable prices, or 3D printed.

This system aims to assess sleep staging more accurately than many commercially available devices, like smartwatches and rings, at a fraction of the cost. Importantly, OSSMM is designed to permit researchers and enthusiasts to conduct experiments requiring sleep modulation, addressing a gap where no comparable system is currently available off-the-shelf.

*OSSMM is currently under assessment for 4-stage sleep classification accuracy.*

Key design considerations for OSSMM include:

* Reusable and washable silicone wet-dry electrodes.
* Quick-change parts for easy repair and hygiene.
* Battery Powered with no exposed wiring
* Fully open-source hardware designs and software code.
  - Full access for user desired modification.
  - Full transparency of code and classification algorithms used for sleep staging.

## System Overview (V1.0.2)

In short, OSSMM consists of a wearable headband that collects physiological data and transmits it wirelessly via Bluetooth Low Energy (BLE) to a dedicated smartphone application. Only Android is supported at this time.

<img src="media/index/front.jpg" alt="Front view of OSSMM headband" width="45%" style="display:inline-block; margin-right:4%"> <img src="media/index/back.jpg" alt="Back view of OSSMM headband" width="50%" style="display:inline-block">

The bounding dimensions of the headband, excluding the strap, are 79.1 x 45.2 x 30 mm (3.114 x 1.780 x 1.181 in). The headband weighs 76.5 grams (2.7 ounces) with a 150 mAh battery.

The headband comprises:

* **11 Components** (Total part count excluding wires)
* **3D printed housing**
* **Four COTS boards**
* **Rechargeable battery**
* **Electrode band** (Elastic band with integrated silicone wet-dry electrodes, commercially available as a 'heart rate monitor strap')

The device currently collects the following data:

* **Head movement**: Via onboard Inertial Measurement Unit (IMU)
* **Eye movement**: Electrooculography (EOG)
* **Brain signatures**: Frontal Electroencephalography (EEG)
* **Heart rate**: Photoplethysmography (PPG)

While the hardware supports sound data collection (microphone), this feature is not activated in version 1.0.2.

Collected data is transmitted via BLE to a smartphone running the OSSMM app. The app stores the raw data locally. Future versions aim to analyze data in near-real-time to potentially trigger sleep modulation if desired within the experimental protocol.

OSSMM V1.0.2 uses a COTS vibration motor (similar to those in mobile phones) as a stimulus mechanism for sleep modification experiments. The Vibration Motor serves as an ideal example stimulus due to its heavy power demands. Since the system can successfully handle a vibration motor that consumes large amounts of current during operation, it can easily accommodate other stimulus methods: speaker, LEDs, tDCS, and tACS.

With the smallest recommended battery (120 mAh) and only sleep monitoring functionality enabled, the device's runtime should exceed 15 hours.

The OSSMM device can sample at up to 250Hz. Recording 8 hours of sleep at this rate produces ~500 MB of data.


## Documentation Guide

This documentation provides the necessary information to build, set up, and understand the OSSMM V1.0.2. Please follow the sections below in order:

1.  **[Prerequisites](01-prerequisites.md)**: Detailed introduction and required software, tools, components, and background skills.
2.  **[3D Printables](02-printables.md)**: Instructions for printing the device's 3D printed casing.
3.  **[Electronics Assembly](03-electronics-assembly.md)**: Step-by-step guide for soldering and assembling the electronic hardware components.
4.  **[Software Setup](04-software.md)**: Instructions for uploading code onto the microcontroller (MCU) and setting up the smartphone application.
5.  **[Final Assembly & Completion](05-completion.md)**: Integrating the electronics into the casing, attaching the headband, and final checks.

## Safety Considerations

User safety was a fundamental priority throughout the development of OSSMM. The design incorporates several important safety features:

* **Low-voltage electronics**: All electronic components are commercially available, hobbyist-grade parts commonly used in wearable maker projects. The system operates entirely on low voltage, minimizing electrical risks.

* **Limited battery capacity**: The small-capacity battery (120-150 mAh) significantly reduces potential risks associated with battery malfunctions or thermal issues.

* **Non-invasive sensors**: With the exception of the pulse sensor, all measurement systems are passive and do not introduce any current into the body. The pulse sensor uses photoplethysmography (PPG) - the same light-based technology found in consumer smartwatches - which emits only low-intensity light to detect blood flow beneath the skin.

* **Biocompatible materials**: We carefully selected specific 3D printing filament brands based on their published safety data to ensure skin contact compatibility. Safety data sheets for all components are included in this repository for your reference.

While we've made every effort to design a safe system, users assume responsibility for their implementation. We cannot be held liable for any use, misuse, or adverse events resulting from the construction or operation of an OSSMM device. It remains the user's responsibility to properly assemble their device using appropriate components from reputable sources and to ensure proper operation.

## Data Privacy and Security

OSSMM was designed with data protection as a priority, incorporating multiple layers of security:

* **Secure BLE connection**: The smartphone-to-device Bluetooth Low Energy connection implements a 3-unique-UUID verification protocol before any data transmission can occur. This significantly reduces the risk of unauthorized access to your physiological data.

* **User-customizable security**: Each user can modify these UUID values to create their own unique security profile, providing an additional layer of personalization and protection.

* **Local data storage**: All data collected by OSSMM is stored locally on your smartphone in a dedicated "/OSSMM" directory. No data is automatically transmitted to external servers or cloud services.

* **Device security recommendations**: Due to the sensitive nature of sleep and physiological data, we strongly recommend that smartphones used with OSSMM be secured with PIN codes, biometric authentication, or other access controls.

To further enhance your data security, consider regularly backing up and then purging old sleep data that is no longer needed for your research or personal analysis. Remember that physiological data, including sleep patterns, is considered sensitive personal information in many jurisdictions.

---
*Current Version: V1.0.2*