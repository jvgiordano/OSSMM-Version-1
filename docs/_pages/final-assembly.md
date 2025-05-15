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

1. The strap
2. The electronics case
3. The receiver

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

1. Set the multimeter to resistance measurement mode (2kΩ setting if applicable)
2. Place probes at a fixed distance on one silicone electrode
3. Apply sufficient pressure for good contact
4. Record the reading

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
at your strap to identify the slides it has. It is not necessary to remove
the slides for this.

&nbsp;
<div style="display: flex; flex-direction: row; align-items: flex-start;">
  <figure style="margin: 0; width: 48%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/slides-tri.jpg" style="width: 65%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Slides in strap: Triglide slide on left, G hook slide on right</figcaption>
  </figure>
  <figure style="margin: 0; width: 48%; margin-left: 4%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/slide-quad.jpg" style="width: 60%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Slides in strap: Quad slide on left, G hook slide on right</figcaption>
  </figure>
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
  <img src="{{ site.url }}/OSSMM/media/final-assembly/strap-identity.jpg" style="width: 60%;">
</div>
&nbsp;


## Step 3. Cut the stich loop, and remove it from the Quad/Tri Slide

&nbsp;
<div style="display: flex; flex-direction: row; align-items: flex-start;">
  <figure style="margin: 0; width: 48%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/loop-cut-1.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Pre-cut Sticthed Loop </figcaption>
  </figure>
  <figure style="margin: 0; width: 48%; margin-left: 4%;">
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
  <figure style="margin: 0; width: 48%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/shortening-cut-1.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Pre-cut Sticthed Loop </figcaption>
  </figure>
  <figure style="margin: 0; width: 48%; margin-left: 4%;">
    <img src="{{ site.url }}/OSSMM/media/final-assembly/shortening-cut-2.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
    <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
  </figure>
</div>
&nbsp;


Due to the difference length straps will have based on the brand, the length to 
cut will change. Remember, you can always cut more off, but you can't add it back.
In our case, a 15 cm (6") cut was suitable.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/removed.jpg" alt="Back view of OSSMM headband" style="width: 60%;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Removed Portion</figcaption>
</div>

&nbsp;
## Step 5. Insert the cut end into the open slot making a new loop.

Take the newly cut end and insert it through the now open slot. The band should 
go towards the interior. This way when it is worn there is no band flopping in 
the back.


<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/new-loop.jpg" alt="Back view of OSSMM headband" style="width: 60%;">
</div>
&nbsp;


Under typical circumstances the tension should hold this loose end in place. 
However, over time it may come loose with repeated use. We leave it to the user
to choose if they would like to employ additional methods to secure it. We
present two feasible options:

*1. Create a new seam using a basic sewing kit.*
*2. Use a standard quality stapler with paper staples.*

The stapler is the preferred method. When done properly with a quality stapler, 
staples are virtually invisible and are not felt at all. Staples should be done
with the legs initially pointing towards the interior of the bead, that is
towards the head area. When closed properly, the staple legs will clinch back
outward, facing away from the head area.

# Insert the Strap into the Receiver

Now that the strap is prepared, we will insert the strap into the receiver!

## Step 1. Learn the Squeeze

To insert the strap, the receiver must be squeezed in two directions in order to
expand one of the slots. Press down on the back of the receiver on the lateral
side of one of the slots. At the same time, squeeze the top and bottom edges
of the receiver so that is compresses. If done correctly, this will cause
the middle section in the back of the receiver to slightly pop out. You can 
maintain this expansion by simply continuing to press down from the top and 
bottom.

Please refer to the GIF below on how to do this. It is recommended to practice
this a few times.


<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/receiver-squeeze-1.gif" alt="Back view of OSSMM headband" style="width: 50%;">
</div>
&nbsp;


## Step 2. Thread the strap through the first slot

Squeeze the receiver in the manner described, and maintain the slot expansion.
Take the end of heart-monitor chest strap without the G Hook, and the silicone
electrodes facing away from the back, and thread it through the expanded slot.
Thread the strap through until it emerges from the other side with enough length
to pull on. Pull the strap through, and continue to do so until both button
connections have gone through.


<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/strap-insert.gif" alt="Back view of OSSMM headband" style="width: 50%;">
</div>
&nbsp;


## Step 3. Thread the strap through the last slot.

Now thread the strap back through the remaining slot. You can use your finger to
expand the slot or use the original squeeze method shown in Step 1. When you are
the silicone electrodes should be spaced roughly equally when emerging from the
back of the receiver, and the button contacts should be also be equally spaced
apart in the inner compartment.


<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/last-strap.gif" alt="Back view of OSSMM headband" style="width: 60%;">
</div>
&nbsp;



# Install the Electronic Case

You're almost there! 2 out of 3 components are connected. Now let's add the final
piece: the electronic case!

This section should be done with a table as a support, 
or an additional pair of human hands. 

## Step 1. Pull excess strap through the receiver, loop over, and expose the PulseSensor slot

The first part of the installation is inserting the PulseSensor into its 
dedicated slot in the receiver. Before we can do this we need to clear a path. In
this step we are going to prepare the combined receiver and headband strap for
the pulse sensor. We need to expose the pulse sensor slot. To do this, pull
more of strap through, and loop this over the receiver. After completion, no 
strap should be blocking access.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/new-loop.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
</div>
&nbsp;

## Step 2.Insert the PulseSensor

Start by matching the version number text on the receiver and the electronic
case so both are facing upwards. Having the receiver correctly oriented means the pulse
sensor slot's wire notch will be on the bottom. This notch is important for
providing space for the wires coming off the pulse sensor.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/receiver-view.jpg" alt="Back view of OSSMM headband" style="width: 60%;">
</div>
&nbsp;

The PulseSensor should be forced into the slot. Instead, the slot is meant to
expand when force is applied to the back, and the inner walls of the receiver
are pulled slightly outward. It is recommended to practice this squeezing motion
before attempting to insert the PulseSensor.

To complete the install, lightly press the PulseSensor into the slot with the
orientation, such that the wires will eventually sit in the notch. Then, squeeze
the receiver in the indicated manner. You can then hold the position of the 
PulseSensor and as you release the squeeze the receiver should "swallow" the
PulseSensor. You may have to give a little press at the end for it to meet the
face of the receiver.

<div align="center">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/receiver-view.jpg" alt="Back view of OSSMM headband" style="width: 60%;">
</div>
&nbsp;

## Step 3. Connect the EOG/EEG electrodes



## Step 4. Slot in the electronics case

## Step 5. You've done it!



