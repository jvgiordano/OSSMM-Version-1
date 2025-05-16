---
title: "Major Parts Assembly"
permalink: /final-assembly/
date: "2025-04-23"
classes: wide
read_time: true
sidebar:
  nav: "pages_sidebar_nav"
---

Now it's time for the final assembly! You should have before you the three major
components for the OSSMM headband:

1. The strap
2. The electronics case
3. The receiver

Before we can assemble these components, we need to modify the heart-rate monitor
strap. Since it's designed to fit around the chest, it's too long for use as a 
headband and must be shortened. Then will connect the components together easily!

The modular design of the OSSMM system offers important benefits for future use. 
If any issues arise with the OSSMM headband, these principal components can be
quickly replaced rather than the entire system being changed. For example, the
strap can be removed for washing or replaced entirely if needed.

Now let's combine the major components and create an OSSMM headband!

<br>
# Prepare the Strap

In this section we will cover checking your strap for suitability with the OSSMM
system, then guide you through shortening it. Because heart-rate monitor straps 
vary in build, please consider this a general guide. Your strap's buckle 
implementation may differ slightly from our examples.

<br>
## Step 0. Important Note on Strap Selection!

Not all heart-rate monitor straps on the market are equivalent. Importantly, the
conductance of the silicone electrodes varies significantly between brands, which
affects the Signal-to-Noise Ratio (SNR) of the EOG/EEG signals.

To clarify what this means in practical terms: SNR describes how easily the 
electrodes transmit the signals we want compared to unwanted 
electrical noise. Lower electrode resistance (i.e., higher conductance) results
in better SNR. Better SNR means cleaner signals and more accurate data capture
and sleep staging by the OSSMM system.


Unfortunately, it is difficult to know these conductance (or resistance values) 
without the manufacturer's data sheet. Polar Care has provided these details for
their Polar Pro Strap, specifying a surface resistance of 500 Ω.


You can measure an approximate surface resistance of your strap's electrodes 
using a quality multimeter:

1. Set the multimeter to resistance measurement mode (2kΩ setting if applicable)
2. Place probes at a fixed distance on one silicone electrode
3. Apply sufficient pressure for good contact
4. Record the reading
5. Repeat for the other electrode to confirm repeatable measurement

This measurement will give you an estimate of your strap's conductivity. Please
be aware that try surface resistance measurements required specialized equipment.
It is recommended where possible to find heart-rate 
monitor straps with the lowest resistance. 

Technical validation for sleep staging found that even electrodes with an 
approximate surface resistance of 620 Ω were adequate for EEG signature 
detection with machine learning classifiers. Some brands produce straps 
with electrodes with resistance levels as low as 135 Ω.

While most commercially available straps should provide sufficient conductivity,
we recommend testing your strap in advance if you don't have access to its data
sheet.

<br>
## Step 1. Identify the Buckle Types on Your Strap


This guide focuses on straps that use either a triglide slide (3 bars) or quad 
slide (4 bars) in combination with a G Hook slide, as shown in the images below.
Examine your strap to identify which type of slides it has. You don't need to 
remove the slides for this step.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <div style="display: flex; flex-direction: row; justify-content: space-between; align-items: flex-start;">
    <div style="margin: 0; width: 48%; display: flex; flex-direction: column; align-items: center;">
      <img src="{{ site.url }}/OSSMM/media/final-assembly/slides-tri.jpg" style="width: 100%;">
      <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Slides in strap: Triglide slide on left, G hook slide on right</figcaption>
    </div>
    <div style="margin: 0; width: 48%; display: flex; flex-direction: column; align-items: center;">
      <img src="{{ site.url }}/OSSMM/media/final-assembly/slide-quad.jpg" style="width: 100%;">
      <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Slides in strap: Quad slide on left, G hook slide on right</figcaption>
    </div>
  </div>
</figure>
<br>


The following example uses a quad slide and G Hook slide. If your strap has 
slightly different slides, use this guide as a general reference for 
making adjustments to your specific strap.

## Step 2. Locate the Slide Types and Stitched Loop

Cinch your strap so that both the G Hook Slide and Quad/Triglide slide are 
loser together, as shown below. Position them in the same orientation as in the 
image. Identify the stitched loop that passes through one of the slots on 
the Quad/Tri slide.

Note: The strap has two stitched loops. We're only working with the one
connected to the quad/tri slide. 

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/strap-identity.jpg" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


## Step 3. Cut the stiched loop and remove

Using scissors, carefully cut through the stitched loop, then remove it from the
Quad/Tri Slide.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <div style="display: flex; flex-direction: row; align-items: flex-start;">
    <div style="margin: 0; width: 48%;">
      <img src="{{ site.url }}/OSSMM/media/final-assembly/loop-cut-1.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
      <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Pre-cut Sticthed Loop </figcaption>
    </div>
    <div style="margin: 0; width: 48%; margin-left: 4%;">
      <img src="{{ site.url }}/OSSMM/media/final-assembly/loop-cut-2.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
      <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
    </div>
  </div>
</figure>
<br>


## Step 4. Shorten the Strap by at least 12 cm (5") to the above of the seam.

Cut the strap at least 12 cm (5") above the seam (to the left in our reference
image). The images below demonstrate this cut.

Note: for illustration purposes, the scissors are shown at a much shorter 
distance than recommended.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <div style="display: flex; flex-direction: row; align-items: flex-start;">
    <div style="margin: 0; width: 48%;">
      <img src="{{ site.url }}/OSSMM/media/final-assembly/shortening-cut-1.jpg" alt="Front view of OSSMM headband" style="width: 100%;">
      <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Pre-cut Sticthed Loop </figcaption>
    </div>
    <div style="margin: 0; width: 48%; margin-left: 4%;">
      <img src="{{ site.url }}/OSSMM/media/final-assembly/shortening-cut-2.jpg" alt="Back view of OSSMM headband" style="width: 100%;">
      <figcaption style="text-align: center; font-style: italic; margin-top: 5px;">Post-cut Sticthed Loop</figcaption>
    </div>
  </div>
</figure>
<br>


Due to variations in strap length between brands, the amount to cut may differ. 
Remember: you can always cut more off, but you can't add it back. In our example,
a 15 cm (6") cut was suitable.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/removed.jpg" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 5px; display: block;">Removed Portion</figcaption>
</figure>

<br>
## Step 5. Insert the cut end into the open slot making a new loop.

Take the newly cut end and insert it through the now-open slot in the slide. The
band should go toward the interior so that when worn, there is no excess strap
flopping at the back.


<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/new-loop.jpg" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


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

Under normal circumstances, tension should hold this loose end in place. 
However, it may come loose with repeated use. We leave it to the user to decide
if they would like to employ additional methods to secure the band. We propose
two feasible options:

1. Create a new seam using a basic sewing kit
2. Use a standard quality stapler with paper staples (preferred method)

If using staples, they should be positioned with the legs initially pointing
toward the interior of the band (toward the head area). When properly closed, 
the staple legs will clinch back outward, facing away from the head.  When done
properly staples provide a strong seam, and are virtually invisible and 
imperceptible to the touch. 


# Insert the Strap into the Receiver

Now that the strap is prepared, we'll insert it into the receiver.

## Step 1. Learn the Squeeze

To insert the strap, you'll need to squeeze the receiver in two directions to 
expand the width of one of the slots:
- Press down on the back of the receiver on the lateral side of one slot
- Simultaneously, squeeze the top and bottom edges of the receiver to compress it
- If done correctly, the middle section in the back of the receiver will pop out
- Maintain this expansion by continuing to press from the top and bottom

Please refer to the GIF below on how to do this. It is recommended to practice
this a few times. Do not be afraid to use adequate pressure.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/receiver-squeeze-1.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


## Step 2. Thread the Strap Through the First Slot

Squeeze the receiver in the manner described above and maintain the slot expansion.
Take the end of heart-monitor chest strap without the G Hook, and with the silicone
electrodes facing away from the back, thread it through the expanded slot.
Thread the strap through until it emerges from the other side with enough length
to pull on. Then, pull the strap through until both button connections have 
passed through.


<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/strap-insert.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


## Step 3. Thread the Strap Through the Second Slot


Thread the strap back through the remaining slot. You can either use your finger
to expand the slot or use the squeeze method from Step 1. When finished, the
silicone electrodes should be spaced roughly equally when emerging from the 
back of the receiver, and the button contacts should be equally spaced apart 
in the inner compartment.


<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/last-strap.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>



# Install the Electronic Case

You're almost there! 2 out of 3 components are connected. Now let's add the final
piece: the electronic case!

You're almost there! Two of the three components are now connected. Let's add 
the final piece: the electronics case.

This section is best performed with a table for support. 

## Step 1. Prepare Access to the PulseSensor Slot

To install the PulseSensor, first we need to clear a path to the slot in the
receiver. Pull excess strap through a receiver slot. Loop this strap back over
the receiver so it is no longer blocking the front. No part of the strap should
now be blocking access.

Refer to the GIF below:

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/loop-over.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

## Step 2.Identify the Wire Notch and Orient the Receiver

The PulseSensor slot in the receiver is notched on one side to accommodate the
connecting wires. To organize a proper installation, match the version number
text on both the receiver and the electronics case so they face upward. When
correctly oriented, the PulseSensor's wire notch will be on the bottom.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/receiver-view.jpg" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

## Step 3. Learn the Squeeze

The PulseSensor shouldn't be forced into the slot. Instead, the slot is meant to
expand when force is applied to the back of the receiver, and the inner walls 
are pulled slightly outward. Practice this squeezing motion before attempting to
insert the PulseSensor.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/receiver-squeeze-2.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

## Step 4. Squeeze and Insert the Pulse Sensor


To complete the installation, first lay the electronic case on a table. This way
when lifted the PulseSensor will only bear its own weight. Lightly press the 
PulseSensor into the beginning of the slot, oriented so the wires will sit in
the notch.

Now, squeeze the receiver as demonstrated in the previous step. You can use a
thumb to hold the PulseSensor in position. As you release the squeeze the 
receiver should "swallow" the PulseSensor. You may need to apply gentle pressure
after for the PulseSensor to completely mate with the back surface of the slot.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/pulse-sensor-insert.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


## Step 5. Unloop the strap

Unloop the strap and return it to its original position.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/unloop.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


## Step 6. Connect the Snap-Fastener Electrodes

Now it's time to mate the electrode connections on the electronics case and
the strap. 

Ensure that the Version text on the receiver and electronic case are facing the
same direction. Button the male snap-fastener on the electronic case to the
female snap-fasteners in the strap. There should be an audible click,
indicating a snug connection. 

If there is no click, or the connection is obviously loose, then the OSSMM will
not function. 

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/button.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


## Step 7. Insert the Electronics Case into the Receiver

Slot the electronics case into the receiver as shown in the GIF below:

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/final-assembly/case-insert.gif" alt="Back view of OSSMM headband" style="width: 50%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


## Step 8. You've done it!

Reconnect the G Hook and you're done!

You've completed the physical assembly of the OSSMM headband. 

Proceed to [Step 4. Software](https://jvgiordano.github.io/OSSMM/software/)
to complete the required software installations.