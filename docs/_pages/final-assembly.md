---
title: "Major Parts Assembly"
permalink: /final-assembly/
date: "2025-04-23"
classes: wide
read_time: true
sidebar:
  nav: "pages_sidebar_nav"
---

Now it's time for the final assembly! You should have before you the three major components for the OSSMM headband:

*1. The strap*
*2. The electronics case*
*3. The receiver*

Before we can assemble these components, we need to modify the heart-rate monitor
strap. Since it's designed to fit around the chest, it's too long for use as a 
headband and must be shortened. Then will connect the components together easily!

The modular design of the OSSMM system offers important benefits for future use. 
If any issues arise with the OSSMM headband, thse principal components can be
quickly replaced rather than the entire system being changed. For example, the
strap can be removed for washing or replaced entirely if needed.

Now let's combine the major components and create an OSSMM headband!

&nbsp;
# Prepare the Strap

In this section we will cover checking your strap for suitability for the OSSMM
system, and then on shortening it. Because of the difference in strap designs,
please consider this a general "How-To" as straps can use various buckle
implementations!

&nbsp;
## Step 0. Important Note on Strap Selection!

Not all heart-rate monitor straps on the market are equivalent. Importantly, the
conductance of the silicone electrodes varies significantly between brands. This
can affect the Signal-to-Noise Ratio (SNR) of the EOG/EEG signals.

To clarify what this means in practical terms: SNR describes how easily the 
electrodes transmit the signals we are looking for compared to unwanted 
electrical noise. The lower the electrode resistance (i.e., the higher the 
conductance), the better the SNR will be. Better SNR means clearer signals, 
which leads to more accurate data capture and sleep staging by the OSSMM system.


Unfortunately, it is difficult to know these conductance (or resistance values) 
without the manufacturer's data sheet. Polar Care has provided these details for
their Polar Pro Strap, specifying a surface resistance of 500 Ω.


You can measure an approximate surface resistance of your strap's electrodes 
using a quality multimeter on the resistance measurement setting:

*1. Set the multimeter to resistance measurement mode (2kΩ setting if applicable)*
*2. Place probes at a fixed distance on one silicone electrode*
*3. Apply sufficient pressure for good contact*
*4. Record the reading*

This reading will give you an idea of how conductive your heart-rate monitor 
strap is. Please be aware, however, that accurate measurements require 
specialized equipment! It is recommended where possible to find heart-rate 
monitor straps with the lowest resistance. 

Technical validation for sleep staging found that even electrodes with an 
approximate surface resistance of 620 Ω were adequate for EEG signature 
detection with machine learning classifiers. We have found that some brands 
produce straps with electrodes with resistance levels as low as 135 Ω.

Although we believe that most straps on the market should provide sufficient 
conductivity, it is not possible to confirm this for every possible option. 
Therefore, we recommend testing the straps in advance if you do not have the
relevant data sheet.

&nbsp;
## Step 1. Identify the types of buckles used in your strap

This guide is specifically for straps which have either a triglide slide (3 bars) 
or quad slide (4 bars) in combination with a G Hook slide as shown below. Look 
at your strap to identify the slides it has, but not you don't have to remove 
them to do this.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/slides-tri.jpg" style="width: 65%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Slides in strap: Triglide slide on left, G hook slide on right</figcaption>
</div>
&nbsp;

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/slides-quad.jpg" style="width: 60%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Slides in strap: Quad slide on left, G hook slide on right</figcaption>
</div>
&nbsp;

The following example will utilize a quad slide.

If you have slightly different slides, it is recommended to follow this guide in
order to get a general idea of how you may adjust your own.

## Step 2. Identify the Slide types, and stitched loop

Here we have cinched the strap so that both the G Hook Slide and Quad slide are
closer. We recommend doing the same and placing them in the same orientation as
shown below. Identify the stitched loop which will go through one of the slots
on the Quad/Tri slide.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/strap-identity.JPG" style="width: 60%;">
</div>
&nbsp;


## Step 3. Cut the stich loop, and remove it from the Quad/Tri Slide

&nbsp;
<div style="display: flex; flex-direction: row; align-items: flex-start;">
  <figure style="margin: 0; width: 42%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/loop-cut-1.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Pre-cut Sticthed Loop </figcaption>
  </figure>
  <figure style="margin: 0; width: 50%; margin-left: 4%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/loop-cut-2.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
  </figure>
</div>
&nbsp;


## Step 4. Shorten the strap by cutting at least 12 cm (5") above the seam.

The photos below this cut. Note, for illustrative purpose the scissor is shown
at a much shorter distance.

&nbsp;
<div style="display: flex; flex-direction: row; align-items: flex-start;">
  <figure style="margin: 0; width: 42%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/shortening-cut-1.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Pre-cut Sticthed Loop </figcaption>
  </figure>
  <figure style="margin: 0; width: 50%; margin-left: 4%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/shortening-cut-2.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
  </figure>
</div>
&nbsp;


Due to the difference length straps will have based on the brand, the length to 
cut will change. Remember, you can always cut more off, but you can't add it back.
In our case, a 15 cm (6") cut was suitable.

<figure style="margin: 0; width: 50%; margin-left: 4%;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/removed.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
</figure>

&nbsp;
## Step 5. Insert the cut end into the open slot making a new loop.

Take the newly cut end and insert it through the now open slot. The band should 
go towards the interior. This way when it is worn there is no band flopping in 
the back.

<figure style="margin: 0; width: 50%; margin-left: 4%;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/removed.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
</figure>
&nbsp;

Under typical circumstances the tension should hold this loose end in place. 
However, over time it may come loose with repeated use. We leave it to the user
to choose if they would like to employ additional methods to secure it. We
present two feasible options:

1. Create a new seam using a basic sewing kit.
2. Use a standard quality stapler with paper staples.

The stapler is the preferred method. When done properly with a quality stapler, 
staples are virtually invisible and are not felt at all. Staples should be done
with the legs initially pointing towards the interior of the bead, that is
towards the head area. When closed properly, the staple legs will clinch back
outward, facing away from the head area.

# Insert the Strap into the Receiver

Now that the strap is prepared, we will insert the strap into the receiver!

<figure style="margin: 0; width: 50%; margin-left: 4%;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/removed.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
</figure>
&nbsp;

# Install the Electronic Case

You're almost there! This section should be done with a table as a support, 
or an additional pair of human hands.

## Step 1. Pull excess strap through the receiver, loop over, and expose the PulseSensor slot

<figure style="margin: 0; width: 50%; margin-left: 4%;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/removed.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
</figure>
&nbsp;

## Step 2.Insert the PulseSensor



## Step 3. Connect the EOG/EEG electrodes



## Step 4. Slot in the electronics case

## Step 5. You've done it!



