---
title: "Getting Started - A Deep Dive Introduction"
permalink: /getting-started/
date: 2025-04-23T00:26:20+01:00
classes: wide
toc: true # Enable Table of Contents for this page
read_time: true
sidebar:
  nav: "pages_sidebar_nav"
---

This guide provides an in-depth introduction to the OSSMM system, explaining its
functionality, capabilities, cost, and the prerequisites for building your own.

**Please don't be intimidated by the Table of Contents (on any page)!**

Great care has been taken to explain each step in pedantic detail, so what may 
appear as complexity is actually comprehensive clarity. Each step has been 
broken down into many small parts to eliminate any confusion. You'll likely find 
yourself breezing through them much faster than you'd expect.The 
extensive detail is there to guide you, not to overwhelm you.

# How It All Works

## Major System Parts

The OSSMM system consists of 4 parts:

1. **The User (participant)**
2. **The OSSMM Headband**
3. **Android Device and Dedicated App**
4. **You - The Researcher**

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/system_ai.JPG" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">AI generated rendition of OSSMM System. 1) The User 2) OSSMM Headband 3) Android Device running OSSMM app</figcaption>
</div>
&nbsp;

Users wear the OSSMM headband each night during sleep. Version 1.0.4 of the 
headband collects:

* Head movement
* Eye movement (EOG)
* Frontal brain activity (EEG)
* Heart Rhythm data (PPG)

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/quick_pics.jpg" style="width: 75%;">
</div>
&nbsp;

This data is streamed via Bluetooth Low Energy (BLE) to the OSSMM companion app
on an Android device, which saves the data on local storage for later analysis.
The system can be used repeatedly (e.g. 20 nights) as long as the headband is 
charged, and there is enough storage on the Android device.

As a researcher, you can later collect the Android device and analyze the data as 
desired according to your study design.

## Modularity

The OSSMM headband can be built locally with basic tools and basic electronics
knowledge. It is possible to:

* Modify the hardware design using free, browser based CAD software (OnShape)
* Customize the Android app code or headband software
* Analyze the data with your own methods and algorithms

##  Future Possibilities

With future work it will be possible to have:

1. Near Real-Time Sleep Staging (on the Android device)
2. Automated Sleep Modulation Stimulus Delivery (based on sleep stage or custom signal detection)
3. App support beyond Android (iPhone, Raspberry Pi)
4. Audio Data Collection for additional analyses (e.g., sleep apnea detection)
5. Cloud Storage for remote collection and back-up (if desired)

&nbsp;

&nbsp;
# OSSMM Headband - Principal Components

The OSSMM Headband comprises 3 principal components: An electronic case, a headband, and a receiver.

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/front_annotated.jpg" style="width: 65%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Open view of the three major components, all disconnected: Headband, Receiver, and Electronic Case.</figcaption>
</div>
&nbsp;

The electronic case consists of two 3D printed parts which houses the electronics.
The headband is an adjustable strap with silicone electrodes for
EOG/EEG signal collection. These two components connect through the 3D printed
receiver made from soft filament.

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/back_annotated.jpg" style="width: 65%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Rear view of OSSMM headband.</figcaption>
</div>
&nbsp;

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/cad_parts_annotated.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Annotated Printables. TPE = Thermoplastic Elastomer, PLA = Polylactic Acid</figcaption>
</div>
&nbsp;

&nbsp;
# OSSMM App and Data

The companion app serves multiple purposes:

* Stores data collected by the headband
* Provides accurate date-time information
* Will support near real-time sleep staging in future versions

## v0.9.0 App Features

### Buttons, Toggles, and Connections

The app allows a scan of nearby Bluetooth devices with the 
"Select Device and Start Recording" button. Once the headband is selected,
the app establishes a establishes a BLE connection with the headband, initiates 
data collection upon connection, and stores data continuously, even if the
connection is temporarily lost.

The "Sleep Modulation" toggle enables BLE signals to be sent from the Android 
device to the headband. Once enabled, the "Test Modulation" button can be used
during an established connection to activated the headband's vibration 
motor in a double-blink pattern.

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/app-main.jpg" style="width: 25%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Main page of OSSMM app</figcaption>
</div>
&nbsp;

### Real-Time Data Visualization

Selecting "View Current Data" once a connection is established will open to a 
new page with live graphs of the accelerometer, gyroscope, eye movement (EOG), 
and pulse sensors (PPG) data. 

While both eye movement and brain activity are captured in the same signal, only
the EOG component can be reliably identified visually in real-time. Along with
the other signals like head movement and pulse, eyemovement can be used to
confirm that the headband is properly functioning.

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/app-data.jpg" style="width: 25%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Real Time Graph of EOG Data with several eye movements (spikes)</figcaption>
</div>
&nbsp;

### Data Collection

Data is continuously saved in CSV format. At a sampling rate of 250 Hz, 
approximately 500 MB of storage is required for an 8-hour sleep recording.

Each data sample collected by the headband and sent to the companion app includes
ten columns:


| Column | Description |
|--------|-------------|
| Datetime | Precise timestamp when the sample was recorded by the app (down to millisecond) |
| transNum | Transmission number sequence (0-65,535) sent by the headband |
| eog | Combined EOG/EEG signal |
| hr | Heart rhythm/pulse data |
| accX, accY, accZ | Acceleration in three axes |
| gyroX, gyroY, gyroZ | Angular velocity in three axes |


Note: The transmission number resets to 0 after reaching 65,535 
(the maximum value for a 2-byte unsigned integer) and helps identify if BLE 
updates are being lost.

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/data.jpg" style="width: 65%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Portion of a sample CSV file</figcaption>
</div>
&nbsp;

Advanced note: Accelerometer and Gyroscope values have been shifted so that only
unsigned integers are used during BLE transmission. This ensures high speed BLE
transmission rates by decreasing the memory required for each update.

&nbsp;
# Build Your Own - What You Need to Know

The purpose of this section is to inform on the required knowledge for assembling
a complete OSSMM system (headband and Android App). It is out of the scope of 
this tutorial to explain all the background. Resources will be provided for some
areas, but all of the knowledge required to assemble OSSMM can be learned with
some patience and simple internet searches.

Building your own OSSMM System requires 4 principal areas of knowledge:

1. **Basic Electronics Knowledge (including how to solder)**
2. **3D Printer Fundamentals**
3. **Android System Familiarity**
4. **Arduino or Microcontroller Programming Basics**

If this seems like a lot, know these are the *general* areas of competency. 
Specific knowledge within each of these areas with resources is listed below:

## What you specifically need to know

### 1. Basic Electronics Knowledge (including how to solder)

1. What a microcontroller (MCU) and Printer Circuit Board (PCB) are:
   - [MCU + PCB Resource](https://www.youtube.com/watch?v=yi29dbPnu28) (Video)
   - [Arduino MCUs in 100 seconds](https://www.youtube.com/watch?v=1ENiVwk8idM) (Video)
2. How to Solder
   - [Soldering Instructional #1](https://www.youtube.com/watch?v=6rmErwU5E-k&t=256s) (Video, Note: Excellent instructional. However, We prefer an easier method for pin-hole soldering. This is shown in the Electronics Assembly section.)
   - [Soldering Instructional #2](https://www.youtube.com/watch?v=rK38rpUy568&t=167s) (Video)
   - [Arduino Guide to Soldering](https://docs.arduino.cc/learn/electronics/soldering-basics/) (Non-video)

### 2. 3D Printer Fundamentals

1. How 3D Printers work in principle
   - [3D Printer General](https://www.youtube.com/watch?v=f94CnlQ0eq4) (Video)
2. How to print a file if provided the .gcode files
   - In short, how to put this file on the 3D printer and print it
3. Difference in filament types: PLA and TPU
   - [PLA vs TPU Description](https://youtu.be/dYPW5Rlwn8g?t=43) (Video)
4. If your 3D printer is Direct-Drive or not
5. How to adjust your printer to print TPU

### 3. Android System Familiarity

1. What is Android and familiarity with the UI
2. How to install an APK file (i.e., how to install an app)
   - [Installing an APK on Android](https://www.youtube.com/watch?v=Ehlzt2OXI4c) (Video)
  
### 4. Arduino or Microcontroller Programming Basics
1. As per the above, what is Arduino and what is an MCU
2. How to upload a sketch from Arduino IDE to an Arduino (i.e., how to program an MCU with existing Arduino code)
   - [Learn Arduino in 15 minutes](https://www.youtube.com/watch?v=nL34zDTPkcs&t=93s) (Video)

&nbsp;
# Build Your Own - What You Need to Have

## Required Tools:

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/required_tools.jpg" style="width: 75%;">
</div>
&nbsp;

**Tools:**

1. **3D Printer** (Direct Drive Preferred)
2. **Soldering Iron Kit**
3. **Android Device** (which supports BLE, e.g. smartphone)
4. **Computer** (Mac, Linux, or Windows)
5. **12mm Snap Fastener Kit with Setter and Hammer[^snapfastener]** (with metal snap-fasteners)
6. **Multimeter**
7. **Wirecutters**

[^snapfastener]: We recommend purchasing the 12mm snap-fastener kit as a whole. The installation tools (setter and hammer) and 12 mm snap-fasteners can be purchased separately but buying the kit together is easiest.

## Required Expendables:

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/required_expendables.jpg" style="width: 75%;">
</div>
&nbsp;

**Expendables:**

1. **Wires (22-30 AWG)[^wires]**
2. **PLA 3D Printer Filament[^filaments]** (PLA = Polylactic Acid)
3. **TPU 3D Printer Filament[^filaments]** (TPU-95 or TPU-85, TPU = Thermoplastic Polyurethane)
4. **Solder (lead free, with flux recommended)**

[^wires]: We recommend 30 AWG wire that is color coded and silicone insulated. Silicone coatings do not melt at normal soldering temperatures and make assembly cleaner, easier, and safer. Two 5" (13cm) thicker strands, no thicker than 22AWG are recommended but not needed. The whole project can be completed with 30AWG.

[^filaments]: Filaments should be chosen based on their safety and data profiles. Only the TPU filament will make prolonged dermal contact. Therefore, TPU materials with bio-compatibility documentation should be used.

## Recommended Tools and Expendables:

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/recommended_tools.jpg" style="width: 75%;">
</div>
&nbsp;

**Recommended Tools and Expendables:**

1. **Helping Hands** (with Magnifier)
2. **Fume Extractor** (if not working in a ventilated environment)
3. **Flux**
4. **Sandpaper[^sandpaper]**

[^sandpaper]: Sandpaper is recommended for individuals using entry-level or older 3D printers who desire a more refined finish on their prints. Sandpaper may also be beneficial for those who prefer a more forgiving approach to possible electronic component fitting, as sandpaper allows for gradual material removal rather than the harsher scraps or snips using wire cutters.

## OSSMM Headband Required Parts:

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/required_parts.jpg" style="width: 75%;">
</div>
&nbsp;

**Parts:**

1. **Heart Rate Monitor Strap**
2. **Seeed Xiao nRF52840 Sense**
3. **Pulse Sensor**
4. **AD8232 EKG Board**
5. **3.7V LiPo Battery (120 -- 220mAh, not exceeding: L=32, W=15, H=6 mm)**
6. **Vibration Motor Board**
7. **x2 Pair of 12mm Metal Snap-Fastener (not shown, these generally come with the snap-fastener kit mentioned above)**
8. **Sheet of paper (not shown)**

Note: If you are only interested in sleep monitoring, the Vibration Motor Board
is not needed.

&nbsp;
# The Cost

**One of the priorities in designing OSSMM was to address the prohibitive costs of sleep
research by providing an affordable solution.** By leveraging the capabilities of
an external Android device[^android] it was possible to significantly lower the device 
cost of the OSSMM headband.

Most tools needed to build the OSSMM are standard equipment found in university 
laboratories. The only specialized tool required is a snap-fastener installation
kit, which costs less than $15 or €12 (as of 12/2024). One kit will provide
enough snap-fasteners for more than 30 OSSMM headbands.

3D printing is essential for creating the OSSMM headband. While 3D printers are 
increasingly accessible in universities and public libraries, it's important to
note that a direct-drive extrude is strongly recommended. This type of printer 
pushes filament directly into the hot end (where filament melts for printing) and
is the best method for printing flexible filaments (like the TPU used 
in OSSMM). While not impossible, printing TPU with other 3D printer types will
likely be challenging.

The original target cost of OSSMM headband was $150. To our surprise, **we 
achieved a cost of just €37.20 per unit ( and with some rounding up at that)**. 
This value represents the marginal cost ("ingredient cost") of building one unit,
not the total overhead cost ("shopping list cost")[^marginal]. 

**We estimate the typical marginal cost of building a single unit 
at €40-60[^bulk][^fixed].**

When utilizing "premium" components from established brands without comparison 
shopping, the total expenditure should still not exceed the original 
$150 target cost within the USA (shipping included).

This estimate will vary depending on country, suppliers, and brands 
(and it seems political changes). 

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/getting-started/cost.jpg" style="width: 75%;">
</div>
&nbsp;

When using the OSSMM in formal research settings, regulatory compliance may 
require technical and safety documentation for all components, including the 
headband (i.e., heart rate monitor strap). This documentation requirement 
can affect costs. Currently, only one manufacturer—PolarCare—has provided 
comprehensive safety information for their Pro Strap, which costs approximately 
$37 or €36 (as of 04/2025). For comparison, generic commercial heart monitor 
straps without documentation can be purchased for less than $6 or €5. They can 
even be purchased for about $1 or €1 in some circumstances. All pricing 
reflects actual marketplace offerings rather than currency conversions.

The repository will be updated with additional brand headband data and safety 
documentation as more manufacturers provide this information.

[^android]: The Android device provides storage, time tracking, and processing capabilities for which it is well suited. Adding these functions directly to the headband would significantly increase the price, size, and weight. As previously mentioned, lower cost alternatives like a Raspberry Pi could be used in lieu of Android devices as a separate standalone "base station" providing these capabilities. We selected Android smartphones due to their widespread availability and familiar user interfaces.

[^marginal]: Marginal costs refer to the expense of producing one additional unit. For example, we calculate the filament cost per OSSMM headband by multiplying the cost per gram by the grams used in a single headband—not by the cost of the entire filament roll. For a familiar analogy: when calculating the cost of a batch of cookies, we count only the portion of butter used (e.g., half a stick), not the full stick that had to be purchased to make the cookies in the first place.

[^bulk]: Purchasing some items in bulk quantities may result in lower prices. Our price involved "bulk" quantities where some items were purchased in quantities greater than 10. However, for some market places we have found day-to-day pricing to have a greater effect on pricing than bulk purchasing. It is not necessary to buy in bulk for low-cost pricing.

[^fixed]: This does not account for fixed costs: equipment, full rolls of solder, filament, etc.

# I'm ready - let's begin!

The first physical step to building your OSSMM device is creating the 3D prints.
Head over to the [3D Printables](https://jvgiordano.github.io/OSSMM/printables)
page to begin!