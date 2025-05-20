---
title: "3D Printables"
permalink: /printables/
date: "2025-05-16"
classes: wide
toc: true # Enable Table of Contents for this page
read_time: true
sidebar:
  nav: "pages_sidebar_nav"
---

Welcome to the 3D Printable Guide! Here the basics of creating the 3D prints
for the OSSMM are covered.

Please note, this is not a general "How To" guide for 3D printing. Because of
significant variation in printers, slicing software, and filament choices, it's
not possible to create a straightforward, "cookbook" guide. Some information, 
such as optimal printing temperatures, will need to be determined by yourself.

We recommend following best printing practices. This includes printing a 
[Temperature Tower](https://www.youtube.com/watch?v=NEnVQKX-_N8) to determine 
the optimal slicing parameters for your specific setup. This step is 
particularly important if you're working with TPU filament and don't have 
previous experience with this material in your printer. Other best practices 
include ensuring filament is kept dried and choosing appropriate supports.

We remind users that direct-drive 3D printers are highly recommended.

# Printables Overview

The OSSMM requires three 3D-printed components: the receiver, the electronic
case lid, and the electronic case bottom. A labeled CAD image of these is shown
below:

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/printables/cad-parts.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Labeled OnShape CAD for the OSSMM 3D Printables</figcaption>
</div>
&nbsp;

As denoted in the image, and previously mentioned, the receiver is printed using
TPU (Thermoplastic Polyurethane), a flexible filament. The electronic case is 
printed in using PLA (Polylactic Acid).


Because these components use different filament types, the receiver must be
printed on a separate print run from the electronic case's top and bottom 
(unless you have a multi-filament 3D printer with independent extruders). 
Therefore, there is one STL file for the receiver, and one STL file for the
electronic case. 

All three parts are drawn in a publicly available 
[OnShape Document located here](https://cad.onshape.com/documents/9770a63668febc8c28355357/w/080415be9bd2ce05fb700580/e/ca5bfcf86b2d6d5dd97a01c1?renderMode=0&uiState=680bf8be89fa246ebf943572_).
You can fork this CAD document and modify as needed.


&nbsp;
# 3D Print File - STLs and GCODE

The STL file for the receiver and electronic case is located in the OSSMM Github
repository under "STL Files" within the 
[OSSMM - V1.0.4 Printables](https://github.com/jvgiordano/OSSMM/tree/main/OSSMM%20V1.0.4%20Printables)
folder. 

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/printables/location.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">3D Printing Files in the OSSMM Github Repo</figcaption>
</div>
&nbsp;

The STL files will need to be sliced by your slicing software of choice, and 
then the Gcode loaded to your 3D printer for printing. 

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/printables/PrusaSlicer.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Receiver in PrusaSlicer with "snug" supports and 8% infill.</figcaption>
</div>
&nbsp;

For (possible) convenience, we have provided the GCode from Prusa Slicer that 
we used on a Prusa MKS3+ 3D printer. However, it is still recommended to go 
through the proper 3D printing best practices and starting with the STL files 
and adjusting the slicer parameters to your own printer (even if you own a MKS3+ 
and use the same filament as us).

&nbsp;
# Printing the Receiver

## Filament
Print the receiver with TPU grades from 85 to 95 shore A hardness 
(TPU-85 to TPU-95). Softer filaments may work but have not been tested.

We recommend TPU-85 for optimal comfort, though TPU-95 works sufficiently well. 
Be aware that TPU-85 is more challenging to print due to its softness 
compared to TPU-95.

We used Siraya Tech Flex TPU85A filament because of safety considerations. 
Since the receiver makes prolonged dermal contact, we prioritized Siraya Tech 
for their multiple biocompatibility certifications. These certifications can be 
found on the company's website or in the 
[OSSMM - Data and Safety docs](https://github.com/jvgiordano/OSSMM/tree/main/OSSMM%20-%20Data%20and%20Safety%20docs)
folder in the OSSMM repository.

## Slicer Settings

**Important: When printing with TPU, two critical slicer settings must be configured:**

1. **Set "Infill Density" to 8%**
2. **Set "Infill Pattern" to "Gyroid"**

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/printables/infill.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Required Infill Settings for TPU-85</figcaption>
</div>
&nbsp;

The receiver was specifically designed using TPU with these infill settings to 
create an "air cushion" effect that comfortably distributes pressure. If 
printing with TPU-95 (higher hardness), we recommend reducing the infill 
percentage to 7%. Optimal values may vary depending on your specific printer, 
filament brand, and slicer parameters such as flow rate. The goal is to create 
a receiver that provides soft cushioning for comfort without collapsing or 
breaking.

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/printables/receiver.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Printed Receiver on MK3S+ using Siraya Tech TPU-85A with a print time of nearly 7 hours.</figcaption>
</div>
&nbsp;


# Printing the Electronic Case

## Filament
Print the receiver with standard PLA.

We used Prusament PLA for both its fine printing quality, and its safety
considerations. Although PLA material does not make any prolong dermal contact,
safety is still a priority and Prusament provides suitable safety information.

## Slicer Settings
The electronics case is a typical 3D print and there are no required slicing 
parameters. Because of the fine structures within the case we recommend 
printing at the highest printing quality possible.

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/printables/electronic-case-black.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Printed Electronic Case on a MKS3+ in Prusament Galaxy Black with a print time of nearly 3 hours</figcaption>
</div>
&nbsp;

&nbsp;
<div align="center">
  <img src="{{ site.url }}/OSSMM/media/printables/electronic-case-black-2.jpg" style="width: 75%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px;">Close Up of Print Electronic Case</figcaption>
</div>
&nbsp;

# Finishing 3D Prints

The 3D prints should be inspected, and any support material, stringing, or printing
burrs removed. Light sanding with sandpaper may be used to improve the finish of 
prints. In particular, the rear of the receiver should be smooth.

If glue was used for bed adhesion, make sure to properly clean any residue off
the prints. We recommend avoiding glue for bed adhesion where possible.

# Time for the Electronics Assembly!

The next step to building your OSSMM device is assembling the electronics.
Head over to the [Electronics Assembly](https://jvgiordano.github.io/OSSMM/electronics-assembly)
page to begin!

