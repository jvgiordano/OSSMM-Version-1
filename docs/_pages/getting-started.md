---
title: "Getting Started - A Deep Dive Introduction"
permalink: /getting-started/
date: 2025-04-23T00:26:20+01:00
classes: wide
---


# Introduction to OSSMM and Pre-Requisites

On this page, the OSSMM system is introduced in depth. The system and headband's
functionality and capabilities are explained.

Pre-requisites for building your own are described towards the end.

# System Overview - How It All Works

The OSSMM system comprises 4 parts:

1. **The User (participant)**
2. **The OSSMM Headband **
3. **Android Device and Dedicated App **
4. **You - The Researcher **

<br>
<div align="center">
  <img src="media/introduction/system_ai.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">AI generated rendition of OSSMM System</figcaption>
</div>
<br>

Users wear the OSSMM headband each night during sleep. Version 1.0.4 of the 
headband collects head movement, eye movement (EOG), frontal brain signatures 
(EEG), and pulse (PPG) data. This data is transmitted to the dedicated OSSMM 
companion app built for Android devices. The app continually saves this data 
to local storage.

You the researcher can then collect the smartphone device and analyze the collected 
data as desired.

The OSSMM headband can be built locally with limited tools and basic electronics
knowledge. The hardware design can be modified using CAD software, and the code
for the dedicated Android app or headband can be adjusted for your use. Refer
to the [Build Your Own - What You Need to Know](#build-your-own---what-you-need-to-know)
below.

With future work it should be possible to:

1. **Have sleep data uploaded securely to the cloud for remote collection and/or backup.**
2. **Use other BLE supporting devices such as iPhone and Raspberry Pi computers.**
3. **Enable sound data collection for improved sleep analysis.**
4. **Enable near-real time sleep staging.**
5. **Use automated sleep staging or signal detection to activate stimuli for sleep modification.**

# OSSMM Headband - How it works

The OSSMM Headband comprises 3 principal components: An electronic case, a headband, and a receiver.

<br>
<div align="center">
  <img src="media/introduction/quick_pics.jpg" style="width: 75%;">
</div>
<br>

The electronic case consists of 2 3D printed parts which houses the electronics.
The headband is an adjustable strap with silicone electrodes for
EOG/EEG signal collection. These two components connect through the 3D printed
receiver made from soft filament.

<br>
<div align="center">
  <img src="media/introduction/front_annotated.jpg" style="width: 65%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Open view of the three major components, all disconnected: Headband, Receiver, and Electronic Case.</figcaption>
</div>
<br>

<div align="center">
  <img src="media/introduction/back_annotated.jpg" style="width: 65%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Rear view of OSSMM headband.</figcaption>
</div>
<br>

<br>
<div align="center">
  <img src="media/introduction/cad_parts_annotated.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Annotated Printables. TPE = Thermoplastic Elastomer, PLA = Polylactic Acid</figcaption>
</div>
<br>


# System Requirements

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
   - [MCU + PCB Resource](https://www.youtube.com/watch?v=yi29dbPnu28)
   - [Arduino MCUs in 100 seconds](https://www.youtube.com/watch?v=1ENiVwk8idM)
2. How to Solder
   - [Soldering Instructional #1](https://www.youtube.com/watch?v=6rmErwU5E-k&t=256s) (Note: Excellent instructional. However, We prefer an easier method for pin-hole soldering. This is shown in the Electronics Assembly section.)
   - [Soldering Instructional #2](https://www.youtube.com/watch?v=rK38rpUy568&t=167s)

### 2. 3D Printer Fundamentals

1. How 3D Printers work in principle
   - [3D Printer General](https://www.youtube.com/watch?v=f94CnlQ0eq4)
2. How to print a file if provided the .gcode files
   - In short, how to put this file on the 3D printer and print it
3. Difference in filament types: PLA and TPU
   - [PLA vs TPU Description](https://youtu.be/dYPW5Rlwn8g?t=43)
4. If your 3D printer is Direct-Drive or not

### 3. Android System Familiarity

1. What is Android and familiarity with the UI
2. How to install an APK file (i.e., how to install an app)
   - [Installing an APK on Android](https://www.youtube.com/watch?v=Ehlzt2OXI4c)
  
### 4. Arduino or Microcontroller Programming Basics
1. As per the above, what is Arduino and what is an MCU
2. How to upload a sketch from Arduino IDE to an Arduino (i.e., how to program an MCU with existing Arduino code)
   - [Learn Arduino in 15 minutes](https://www.youtube.com/watch?v=nL34zDTPkcs&t=93s)


# Build Your Own - What You Need to Have

## Required Tools:

<br>
<div align="center">
  <img src="media/introduction/required_tools.jpg" style="width: 75%;">
</div>
<br>

**Tools:**

1. **3D Printer** (Direct Drive Preferred)

2. **Soldering Iron Kit**

3. **Android Device** (which supports BLE, e.g. smartphone)

4. **Computer** (Mac, Linux, or Windows)

5. **12mm Snap Fastener Kit with Setter and Hammer<sup>a</sup>** (with metal snap-fasteners)

6. **Multimeter**

7. **Wirecutters**

<sup>a</sup>Note: We recommend purchasing the 12mm snap-fastener kit as a whole.
The installation tools (setter and hammer) and 12 mm snap-fasteners can be 
purchased separately but buying the kit together is easiest. 


## Required Expendables:

<br>
<div align="center">
  <img src="media/introduction/required_expendables.jpg" style="width: 75%;">
</div>
<br>

**Expendables:**

1. **Wires (22-30 AWG)<sup>a</sup>**

2. **PLA 3D Printer Filament<sup>b</sup>** (PLA = Polylactic Acid)

3. **TPU 3D Printer Filament<sup>b</sup>** (TPU-95 or TPU-85, TPU = Thermoplastic Polyurethane)

4. **Solder (lead free, with flux recommended)**


<sup>a</sup> We recommend  30 AWG wire that is color coded and silicone insulated.
Silicone coatings do not melt at normal soldering temperatures and make assembly 
cleaner, easier, and safer. Two 5" (13cm) thicker strands, no thicker than 22AWG
are recommended but not needed. The whole project can be completed with 30AWG.

<sup>b</sup> Filaments should be chosen based on their safety and data profiles.
Only the TPU filament will make prolonged dermal contact. Therefore, TPU materials with
bio-compatibility documentation should be used.

## Recommended Tools and Expendables:

<br>
<div align="center">
  <img src="media/introduction/recommended_tools.jpg" style="width: 75%;">
</div>
<br>


**Recommended Tools and Expendables:**

**1.  Helping Hands** (with Magnifier)

**2.  Fume Extractor** (if not working in a ventilated environment)

**3. Flux**

**4. Sandpaper<sup>a</sup>**

<sup>b</sup> Sandpaper is recommended for individuals using entry-level or older
3D printers who desire a more refined finish on their prints. Sandpaper may also
be beneficial for those who prefer a more forgiving approach to possible 
electronic component fitting, as sandpaper allows for gradual material removal
rather than the harsher scraps or snips using wire cutters."


## OSSMM Headband Required Parts:

<br>
<div align="center">
  <img src="media/introduction/required_parts.jpg" style="width: 75%;">
</div>
<br>

**Parts:**

1. **Heart Rate Monitor Strap**

2. **Seeed Xiao nRF52840 Sense**

3. **Pulse Sensor**

4. **AD8232 EKG Board**

5. **3.7V LiPo Battery (120 -- 220mAh, not exceeding: L=32, W=15, H=6 mm)**

6. **Vibration Motor Board**

7. **x2 Pair of 12mm Metal Snap-Fastener (not shown, these generally come with the snap-fastener kit mentioned above**

8. **Sheet of paper (not shown)**

Note: If you are only interested in sleep monitoring, the Vibration Motor Board
is not needed.

# The Cost

**One of the priorities in designing OSSMM was to address the prohibitive costs of sleep
research by providing an affordable solution.** By leveraging the capabilities of
an external Android device it was possible to significantly lower the device 
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
+98/
The original target cost of OSSMM headband was $150. To our surprise, **we 
achieved a cost of just €37.20 per unit ( and with some rounding up at that)**. 
This value represents the marginal cost ("ingredient cost") of building one unit,
not the total overhead cost ("shopping list cost")<sup>b</sup>. 

**We estimate the typical marginal cost of building a single unit 
at €40-60<sup>cd</sup>.**

When utilizing "premium" components from established brands without comparison 
shopping, the total expenditure should still not exceed the original 
$150 target cost within the USA (shipping included).

This estimate will vary depending on country, suppliers, and brands 
(and it seems political changes). 

<br>
<div align="center">
  <img src="media/introduction/cost.jpg" style="width: 75%;">
</div>
<br>

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

<sup>a</sup> The Android device provides storage, time tracking, and processing
capabilities for which it is well suited. Adding these functions directly to the 
headband would significantly increase the price, size, and weight. As previously mentioned,
lower cost alternatives like a Raspberry Pi could be used in lieu of Android devices
as a separate standalone "base station" providing these capabilities. We selected
Android smartphones due to their widespread availability and familiar 
user interfaces.

<sup>b</sup> Marginal costs refer to the expense of producing one additional unit.
For example, we calculate the filament cost per OSSMM headband by multiplying the
cost per gram by the grams used in a single headband—not by the cost of the entire
filament roll. For a familiar analogy: when calculating the cost of a batch of cookies,
we count only the portion of butter used (e.g., half a stick), not the full 
stick that had to be purchased to make the cookies in the first place.

<sup>c</sup> Purchasing some items in bulk quantities may result in
lower prices. Our price involved "bulk" quantities were some items were purchased
in quantities greater than 10. However, for some market places we have found 
day-to-day pricing to have a greater effect on pricing than bulk purchasing. It
is not necessary to buy in bulk for low-cost pricing. 

<sup>d</sup> This does not account for fixed costs: equipment, full rolls of 
solder, filament, etc.
