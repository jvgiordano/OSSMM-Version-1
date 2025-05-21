---
title: "Electronics Assembly Guide"
permalink: /electronics-assembly/
date: 2025-05-16T04:20:20+01:00
classes: single
toc: true # Enable Table of Contents for this page
read_time: true
---

# Electronics Assembly

Welcome to the Electronics Assembly guide! In this section, you will learn how 
to combine the electronic components and install them in the 3D printed case 
to create the "electronic module." 

The photos below show the completed assembly from different angles. Some images 
display the case with the lid open to reveal the internal component arrangement.
Please note that the PulseSensor intentionally remains outside the electronic 
case in the final assembly.

**Build Time:**  
\- First-time: expect 2-2.5 hours  
\- Experienced: comfortably under 50 minutes

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <div style="display: flex; justify-content: center; gap: 10px;">
    <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image1.jpeg" style="width: 30%;">
    <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image2.jpeg" style="width: 30%;">
    <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image3.jpeg" style="width: 17%;">
  </div>
</figure>
<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <div style="display: flex; justify-content: center; gap: 10px;">
    <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image4.jpeg" style="width: 30%;">
    <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image5.jpeg" style="width: 30%;">
  </div>
</figure>

**Note:** Edges may appear curved in some photos due to lens distortion 
during the documentation process. Please be aware that these edges, like the sides
of the electronics case, are actually straight.

<br><br>

## Step 1. Gather Relevant Tools and Materials:

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image6.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>

**Parts:**

1. **3D Printed Electronics case Bottom**

2. **3D Printed Electronics case Lid**

3. **x2 Pair of 12mm Metal Snap-Fastener (2 male, 2 female)**

4. **3.7V LiPo Battery (120 -- 220mAh, not exceeding: L=32, W=15, H=6 mm)**

5. **AD8232 EKG Board**

6. **Vibration Motor Board**

7. **Pulse Sensor**

8. **Seeed Xiao nRF52840 Sense (MCU)**

9. **Sheet of paper (not shown)**

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image7.png" style="width: 80%; display: block; margin-left: auto; margin-right: auto;">
</figure>

**Required Tools:**

1. **Soldering Iron**

2. **Snap Fastener Hammer and Setter**

3. **Wire Cutters**

4. **Multimeter**

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image8.jpeg" style="width: 80%; display: block; margin-left: auto; margin-right: auto;">
</figure>

**Recommended Tools:**

**5.  Helping Hands with Magnifier**

**6.  Fume Extractor (if not working in a ventilated environment)**

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image9.jpeg" style="width: 80%; display: block; margin-left: auto; margin-right: auto;">
</figure>

**Expendables:**

1. **Wires (30 AWG is recommended with color coded, silicone coating. We also recommend two 5" (13cm) thicker strands, no bigger than 22AWG. The whole project can be completed with 30AWG however)**

2. **Solder (lead free recommended)**

3. **Flux (particularly if not in solder)**

4. **Sandpaper (Recommended)**

**Preliminary notes on soldering:**

1. **Soldering temperature should be set to 380-400℃.**

2. **When using solder, especially leaded solder, use appropriate ventilation and wash hands afterwards.**

Please refer to this [Arduino documentation on
soldering](https://docs.arduino.cc/learn/electronics/soldering-basics/)
for best practices and more information.

<br><br>

## Step 2. Test-Fit Electronic Components in 3D Printed Case Bottom

<br>

**Goal: Verify that all electronic components properly fit into the 3D printed case bottom.**

In this step, you'll test if your components fit correctly in the case.

Refer to the photos directly below to identify the position of each component. 
Don't force anything into place at this stage—we're only checking fit, not 
installing components permanently.

If components appear too large:
1. Check if the case was printed to correct specifications
2. If the case dimensions are correct, then some PCBs* may need minor adjustments
3. Carefully sand edges of PCBs using sandpaper or scrape with wire cutters (use caution!)

**Important fit check:** The AD8232 and Vibration Motor boards have holes that 
should align with the pegs in the case. This alignment should confirm proper case 
dimensions.

*PCBs (Printed Circuit Boards) refer to the component boards such as the Seeed 
Xiao Sense, Vibration Motor Board, AD8232, and Pulse Sensor.

The photo directly below shows a properly positioned Vibration Motor,
along with the designated positions for the battery and MCU.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image10.jpg" style="width: 50%; transform: rotate(90deg); display: block; margin-left: auto; margin-right: auto;">
</figure>

Please note that the Seeed Xiao Sense inserts bottom-side facing up, so that the
USB port inserts into the electronics case's USB slot.

The Vibration Motor Board may need minor adjustment to fit properly. The 
vibration disk's orientation might cause wires to extend beyond the board's 
boundaries, preventing insertion into the electronics case. Simply lift the 
vibration disk from the board (it's attached with double-sided adhesive) using 
the wire cutters or your fingers, reorient it so wires stay within the board 
dimensions, and press it back down gently to reattach.

The following photos highlight this issue. The left image shows the problem: 
the vibration disc orientation causes wiring to extend beyond the board's 
boundary. The right image shows the solution: rotating the disc keeps all wiring
contained within the board dimensions.

<br>

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <div style="display: flex; justify-content: center; gap: 10px;">
    <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image11.jpeg" style="width: 40%;">
    <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image12.jpeg" style="width: 40%;">
  </div>
</figure>

<br>

The photo below shows the inclusion of the AD8232, which should sit
above the Vibration Motor Board.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image13.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

If the components fit, move on to the next step. Otherwise, take the
time to reprint the case or gently modify the PCBs as needed.

<br><br>

## Step 3. Connect Snap-Fasteners to the Electronics case Lid

<br>

**Goal: Install Snap-Fasteners on the Electronics Case Lid with Wire Leads**

The snap-fasteners function as electrode connection points for the heart rate 
monitor strap, which collects EOG and EEG signals. This connection is essential
for accurate sleep monitoring. Take your time with this step.

Materials needed:
- Two wire strands (22-30 AWG), at least 5" (13cm) long
- Thicker wire (22 AWG recommended) provides better electrical contact

Preparation steps:
1. Strip approximately 20-25mm of insulation from one end of each wire
2. Locate the internal face of the electronic lid (the non-smooth surface)
3. With the internal face up, thread the exposed wire through one of the round holes
4. Position the wire carefully in the notch as shown in the photo below:

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image14.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Then, insert one of the male snap-fasteners into the same hole.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image15.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Flip the electronic lid over. Bend the exposed wiring over the male snap
fastener. Trim excess wire.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image16.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Next, place a female snap-fastener over the male snap fastener **while 
maintaining the exposed wire's position**. It's normal for some wire strands to
shift slightly during this process—as long as most of the wiring stays in place, 
the connection will function properly.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image17.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Press the snap-fastener assembly together firmly by hand. This creates an initial
connection that prevents the wire from easily pulling free. You'll notice small
gaps between the snap-fastener assembly (as shown in the photo below). Don't 
worry — we'll address this in the next step.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image18.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

To close these gaps and create a secure electrical connection, we'll now properly
crimp the snap-fastener. Gather your snap-fastener setter and hammer. The setter
is the metal rod with a concave end which is shaped to fit over the female end. 

Find a sturdy corner of a hard, flat surface for this step. Using a corner is 
important as it provides targeted support directly under the snap-fastener while 
keeping the electronics case lid's side tabs free from pressure that could damage
them.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image19.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

First, verify the wire remains in the notch on the internal face. Then position the 
electronics case over the corner so that only the male end of the snap fastener
receives support from below, without the corner touching any other part of the 
case lid. This positioning will prevent any damage to the four side 
tabs on the lid.

Place the setter tool directly on top of the female snap fastener and strike firmly 
with the non-rubber side of the hammer. Don't hesitate to use sufficient force 
or multiple strikes to achieve a proper crimp—this connection needs to be secure.

While it is possible to over crimp the snap fastener and cut the wire, this is
difficult to achieve if the wire is positioned in the notch from the start.


<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image20.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


**Remember, the goal is to have a tight, secure fit that will not come
undone and will make solid contact with the exposed wiring.** This is
the conductive path for the EOG and EEG signals and it is essential for
accurate sleep monitoring.

Repeat the process for the other hole. Make sure the snap fasteners are
secure. Below is a complete electronics case lid with attached
snap-fasteners:

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image21.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


It is okay to have a little gap as shown below if the connection is
snug. Again note that over crimping can lead to the wire being cut, but
if the wires are placed correctly in the notch this is unlikely.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image22.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>

<br><br>

## Step 4. Prepare the AD8232

<br>

**Goal: Begin preparing the PCBs for connection with the MCU. First PCB to prepare
is the AD8232.**

Before assembling all components together, each circuit board may require 
some preparation. We'll start with the AD8232 EKG board.

The AD8232 EKG board includes a 3.5mm headphone jack that we won't be using in
our design. Since we'll connect directly to the board's RA and LA pins 
(leaving the RL pin unused), this jack must be removed to allow the board to fit
properly inside the electronics case.


*For those interested in more information about this design choice, please refer
to the section below titled, 
[Additional Information on the AD8232](#additional-information-on-the-ad8232) below*

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image23.png" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>

**Quick Method:** Use wire cutters to firmly pry the jack off the board. Don't
hesitate to apply reasonable force.

**Alternative Method:** If you plan to repurpose this board later, consider 
desoldering the jack instead. Prying may occasionally detach electrode contacts,
though this won't affect our current application.

**Note on Reliability:** We've tested this removal method on numerous boards and
found prying to be both quick and reliable, with no board failures to date.

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/JackRemoval.gif" style="width: 50%; alt="3.5mm Jack Removal Process" style="display: block; margin-left: auto; margin-right: auto;">
</figure>

Once the 3.5mm jack is removed, the AD8232 board should appear as in the
photo below:

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image24.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>

<br><br>

## Step 5. Prepare the PulseSensor

<br>

**Goal: Prepare the PulseSensor board.**

PulseSensor units will either come soldered with pins or with wires. The
OSSMM requires wires.

Even if the unit comes with wires it is recommended replacing them with 
high-quality silicone-insulated wires. This will prolong the durability
and longevity of the device, and make later assembly easier.

Note: Future designs may permit the PulseSensor to only require pins. Wires coming
from the MCU could terminate with female Dupont connectors which would mate with
these pins. This would have several benefits. However, the current design does
not lend itself to this. 

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image25.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

If you have pins, it is easiest to remove the black separator then
desolder the pins one by one.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image26.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

**Wiring Decision:** You can add wires to the PulseSensor now or later.

Both approaches work, but **we recommend adding the wires later.** The 
PulseSensor's wires must pass through the rectangular slot in the electronic 
case lid. Adding the wires earlier makes the soldering more challenging.  

Regardless of when you choose to add the wires, the photo below shows the
correct wiring configuration. When rewiring please confirm that the order of the
electrodes of: 

* **S** (Signal)
* **+** (3.3V)
* **--** (Ground, 0V):

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image27.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>


<br><br>

## Step 6. Prepare the Vibration Motor

<br>

**Goal: Prepare the Vibration Motor Board**

If the vibration motor board comes with pins these must be removed.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image28.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

If the pins are bent, we recommend cutting below the bend, then remove
the plastic separator as shown in the photo below**. It is not
recommended to cut the pins as low as possible on the board.** They are
easiest to remove with tweezers or pliers while desoldering if there is
something to grasp.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image29.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

The prepared board should look as the below. Nothing external protruding
over the board's boundaries, and electrode pinholes ready for wires.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image30.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>

<br><br>

## Step 7. Solder Components Together According to the Layman's Schematic

<br>

**Goal: Assemble all the components!**

It is now time to assemble all the components with wires! Refer to the
Layman's schematic below for the connections. We will show step by step
soldering photos further below:

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image31.jpeg" style="width: 65%; style="display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

**Before proceeding, please note the following:**

1.  **MCU:** All wires exit from the bottom face of the board.

2. **AD8232 Board**: 
  - Side Pins (GND, 3.3V, Output): Wires exit from the bottom side (opposite face of the 3.5mm jack).
  - Top Pins (RA, LA): Wires exit from the top side (face with 3.5mm jack).

3. **Vibration Motor Board**: Wires can exit from either side. Top side is preferred.

4. **PulseSensor**: If you have soldered wires to the PulseSensor, remember to thread the wires through the rectangular slot in the electronics case lid before soldering to the MCU!

We will remind you of these again later in the tutorial.

There are many ways to go about connecting the components with the schematic 
above. We relate here the method we've found most reliable and efficient:

Begin by soldering all required wires to the appropriate pins on the MCU board:

1. Thread each wire through its designated pin hole from the bottom side of the board
2. Bend the wire on the top side to hold it in place
3. Solder each connection securely
4. Trim and clean off any excess


Shown below is the first and second step of this process. Here we have threaded
a red wire through the 3.3V pin of the MCU which will later power the Vibration
Motor. Already soldered are the three ground wires for the component PCBs.

We highlight again, upon completion wires must emerge from bottom of the board:

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image32.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Now it is time to solder the bent wire, and trim off any excess. Resoldering may
be done for a cleaner job.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image33.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


Now you should connect the wiring for the other side of the board as shown below.
Refer to the schematic if there is any confusion. Again we have threaded the
wiring through the pin holes and bent the wires so they hold themselves.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image34.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Solder these connections then trim any excess.

Now it is time to complete the connection between the MCU and the PulseSensor.


We highlight again here that the wires for the PulseSensor must go
through the rectangular slot in the electronics case lid. If you forget
to do this, don't worry. Simply desolder the connections on the PulseSensor, 
thread the wires correctly, then resolder.

We do not recommend resoldering the connection from the MCU side as the pins are
very small and not conducive to easy resoldering.

Below is an example demonstrating the PulseSensor with wires properly threaded
through the rectangular slot in the electronics case lid. Again this photo is for
illustrative purpose and we recommend connecting the PulseSensor to the wires
after they have already been attached to the MCU.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image35.jpeg" style="width: 65%; transform: rotate(180deg); display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


Please fully connect the PulseSensor to the MCU now.

Now you will connect the Vibration Motor Board as shown below:

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image36.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Finally, connect the AD8232 EKG Board. Start with the side connections 
(GND, 3.3V, and OUTPUT). Remember that these wires must exit from the bottom of 
the board (the side opposite where the 3.5mm jack was removed). Thread the wires
through the pin holes as shown in the image below.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image37.jpeg" style="width: 65%; transform: rotate(180deg); display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


Next solder then clean the connections by snipping off any excess.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image38.jpeg" style="width: 65%; transform: rotate(180deg); display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Now, solder the RA and LA connections using the two wires from the 
electronics case lid. In this tutorial, we've used thicker yellow and blue wires 
for these connections. Either wire can connect to LA or RA as the assignment 
doesn't matter. Remember that these wires should exit from the top of the board 
(the side where the 3.5mm jack was removed).


<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image39.jpeg" style="width: 65%; transform: rotate(180deg); display: block; margin-left: auto; margin-right: auto;">
</figure>

<br><br>

## Step 8. Connect the Battery

<br>

**Goal: Connect the Battery!**

Now it's time to connect the battery.


<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <div style="text-align: center; background-color: #fff3cd; padding: 15px; border-radius: 5px; border: 1px solid #ffeeba; margin: 10px;">
    ⚠️ <b>CRITICAL SAFETY CHECK</b> ⚠️
    <br>
    <b>IMPORTANT: YOU MUST VERIFY BATTERY LEAD POLARITY WITH MULTIMETER</b>
    <br>
    - RED should be POSITIVE (+)
    - BLACK should be NEGATIVE (-)
    <br>
    <b>CAUTION:</b> Some manufacturers reverse this standard color coding.
    <br>
    <b>⚠️ CONNECTING INCORRECT POLARITY WILL PERMANENTLY DAMAGE THE MCU ⚠️</b>
    <br>
    With the polarity of the battery leads verified, <b>carefully solder the leads to the MCU battery contacts</b> as shown in the photo below. Here RED is positive, and BLACK is negative.
  </div>
</figure>

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image40.JPG" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Accidentally soldering the leads to the wrong location (such as positive
to negative) will likely damage your board. The extent of the damage may
vary, but if this occurs the MCU should not be trusted even if it
appears to function.

Our testing has shown that sometimes the MCU will semi-function, but
other errors may present themselves in time, such as the MCU being
incapable of charging the battery.

<br><br>

## Step 9. Install Components into the Electronics case Bottom

<br>

**Goal: Slot all electronic components and wiring into the electronic
case bottom.**

Now that everything is connected, it's time to install the electronics
into the case bottom.

First, position the case bottom so you're looking into it. Verify the
version number (printed on the side) is in the upper left corner. The
MCU slot should be in the upper right corner.

Install the MCU (upside down), the battery, and Vibration Motor Board.
Loop the Vibration Motor Board wires around the upper right peg as shown
below. Likewise, the battery wires should thread through the bottom slot
of the MCU enclosure. 

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image41.png" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

Next, install the AD8232 Board into position. The side pins should be
located over the center of the electronics case, and the EOG/EEG (RA/LA)
pins should be towards the bottom left corner.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image42.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>

If the MCU is overly loose in its slot, we recommend covering it with
folded paper as shown in the figure below to ensure it remains in its
slot during use. Please note the following photos show a separate OSSMM
device printed in blue, and with thinner 30AWG wiring for the EOG/EEG
electrodes.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image43.jpeg" style="width: 40%; transform: rotate(90deg); display: block; margin-left: auto; margin-right: auto;">
</figure>
<br>


We also recommend installing one sheet of paper cutout as shown in the
photo below over the circuits. This provides an insulative barrier from
the metal snap-fastener electrodes and eliminates any possibility of
shorting with the underlying PCBs.

<br>
<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image44.jpeg" style="width: 40%; transform: rotate(90deg); display: block; margin-left: auto; margin-right: auto;">
</figure>

<br><br>

## Step 10. Close the Electronics case

<br>

**Goal: Close the case and finish!**

Now it's time to close the electronics case. Note that the tabs on the
electronics case lid are asymmetrical. It can only be closed in one way!

Before inserting, make sure the respective slots on the electronics case
bottom are free and clear. Remove any debris or support material which
may remain.

Align the tabs, insert on one side, then insert on the other. This may
require some slight bending of the electronics case walls to allow the
tabs to slip into their slots.

When it is finished it should look like the following:

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image45.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px; display: block;"><strong>Back</strong></figcaption>
</figure>

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image46.jpeg" style="width: 65%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px; display: block;"><strong>Front</strong></figcaption>
</figure>

<figure style="text-align: center; display: block; margin-left: auto; margin-right: auto;">
  <img src="{{ site.url }}/OSSMM/media/electronics-assembly/image47.jpeg" style="width: 25%; display: block; margin-left: auto; margin-right: auto;">
  <figcaption style="text-align: center; font-style: italic; margin-top: 4px; display: block;"><strong>Side with USB-C</strong></figcaption>
</figure>

<br><br>

## Step 11. Time for Full Assembly!

<br>

Refer to the assembly guide below on how to combine the heart monitor strap,
receiver and electronics module together! The biggest challenge is over!

**[Final Assembly](https://jvgiordano.github.io/OSSMM/final-assembly/)**


<br><br>

## Additional Information on the AD8232

<br>

*Regarding the removal of the 3.5mm jack, one of the project goals was
to minimize the size and weight of the OSSMM device. Under this lens,
the 3.5mm jack provides no benefits and consumes precious space
resources.*

*For those familiar with the AD8232, no connection to the RL pin indeed
means the Right Leg Drive Amplifier (RLD) is not used. Typically, the
RLD applies a small current which is inverse to the signal commonly
detected by both the RA and LA electrodes. Because the AD8232 acts as a
differential amplifier in this case, applying the inverse of the common
signal improves the Common-Mode Rejection Ratio, or in short,
improves the Signal to Noise Ratio (SNR) of the signal difference
between the electrodes.*

*We accept the trade-off of reduced signal quality by abandoning the RLD
for two principal reasons: perceived safety and constructability. Having
any current applied to the body, particularly the head, is considered
invasive and therefore makes any risk however infinitesimally negligible\*,
non-zero. Furthermore, the requirement for a third electrode to supply
this current to the body increases device costs and device complexity.
The performance of the OSSMM without the RLD is more than sufficient to
gladly accept this trade-off.\
\
\*To be very clear on how safe the RLD already is, please consider the
following: The AD8232 EKG board in its standard "Cardiac Monitor
configuration," which is used here prior to "safety" modification, is
set with an "RL" output resistor of 360kΩ limiting the output current to
a participant's body of ≤ 10 µA, provided the PCB voltage is 3.3V. In
the worst case scenario, even if the voltage were raised to 4.2V (i.e.
directly powered by a fully charged 3.7V LiPo battery, which it is not)
and the resistor had the lowest value within the ±10% tolerance range
(that is 324 KΩ), the maximum current would be 13 µA. In comparison,
tACS and tDCS devices supply current to a participants head of up to
2mA, or more than 150x the worst case scenario of the AD8232. However,
given that there is still a "risk" using the RLD, this would needlessly
complicate Health&Safety assessments and ethics approval.*